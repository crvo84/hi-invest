//
//  SettingsTableViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserAccount.h"
#import "InvestingGame.h"
#import "UserDefaultsKeys.h"
#import "ParseUserKeys.h"
#import "GameInfo+Create.h"
#import "ManagedObjectContextCreator.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *initialCashLabel;
@property (weak, nonatomic) IBOutlet UIStepper *initialCashStepper;
@property (weak, nonatomic) IBOutlet UISwitch *disguiseCompaniesSwitch;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL onlyForNewGamesAlertPresented;
@property (nonatomic) BOOL isAnonymousUser;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialCashStepper.stepValue = 50000;
    self.initialCashStepper.minimumValue = 50000;
    self.initialCashStepper.maximumValue = 1000000000;
    self.initialCashStepper.value = self.userAccount.simulatorInitialCash;
    
    self.disguiseCompaniesSwitch.on = self.userAccount.disguiseCompanies;

    self.onlyForNewGamesAlertPresented = NO;
    
    self.isAnonymousUser = [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]];
    
    [self updateUI];
}


- (void)updateUI
{
    // Initial cash
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.initialCashLabel.text = [self.numberFormatter stringFromNumber:@(self.initialCashStepper.value)];
    
    [self.tableView reloadData];
}


- (IBAction)initialCashStepperValueChanged:(UIStepper *)sender
{
    if (!self.onlyForNewGamesAlertPresented) {
        [self presentOnlyForNewGamesAlert];
        self.onlyForNewGamesAlertPresented = YES;
    }
    
    self.userAccount.simulatorInitialCash = self.initialCashStepper.value;

    [self updateUI];
}


- (IBAction)disguiseCompaniesSwitchValueChanged:(UISwitch *)sender
{
    if (!self.onlyForNewGamesAlertPresented) {
        [self presentOnlyForNewGamesAlert];
        self.onlyForNewGamesAlertPresented = YES;
    }
    
    self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.isOn;
    
    [self updateUI];
}

- (void)presentOnlyForNewGamesAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Changes will apply for new games only."
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - User Login/Logout

- (IBAction)logout:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self pauseUI];
        
        NSString *userIdToReset = [self.userAccount.userId copy];
        [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
            
            [self unpauseUI];
            
            if (!error) {
                
                if (self.isAnonymousUser && userIdToReset) {
                    [self resetSimulatorGamesFromUserId:userIdToReset];
                }

                [self performSegueWithIdentifier:@"logout" sender:self];
                
            } else {
                NSLog(@"Could not logout from user account. %@", [error localizedDescription]);
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)connectToFacebook:(id)sender
{
    [self pauseUI];
    
    PFUser *user = [PFUser currentUser];
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissions block:^(BOOL succeeded, NSError *error) {
            
            [self unpauseUI];
            
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                
                self.isAnonymousUser = NO;
                
                [self loadFacebookUserInfo];
                
                [self updateUI];
                
            } else {
                if (error) NSLog(@"Could not connect to Facebook. %@", [error localizedDescription]);
            }
            
            [self presentFacebookConnectionAlertWithSuccess:succeeded];
            
        }];
    }
}

- (void)resetSimulatorGamesFromUserId:(NSString *)userId
{
    NSManagedObjectContext *context = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    
    [GameInfo removeExistingGameInfoWithScenarioFilename:nil
                                              withUserId:userId
                                intoManagedObjectContext:context];
}

// IF ANY CHANGE MADE HERE, DO IT ALSO IN THE SAME METHOD AT SIGNUP VIEW CONTROLLER!!
- (void)loadFacebookUserInfo
{
    PFUser *currentUser = [PFUser currentUser];
    if ([PFFacebookUtils isLinkedWithUser:currentUser]) {
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                
                // Get first name and email from userData and set them to current facebook user
                NSString *firstName = userData[@"first_name"];
                NSString *email = userData[@"email"];
                currentUser[ParseUserFirstName] = firstName;
                currentUser.email = email;
                [currentUser saveEventually];
                
                // Downloading facebook profile picture (in jpg, aprox 10kb) and save it in user defaults
                NSString *facebookId = userData[@"id"];
                NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_res", facebookId]];
                NSData *pictureData = [NSData dataWithContentsOfURL:pictureURL];
                [[NSUserDefaults standardUserDefaults] setObject:pictureData forKey:UserDefaultsProfilePictureKey];
                
            }
        }];
    }
}

- (void)presentFacebookConnectionAlertWithSuccess:(BOOL)success
{
    NSString *title = success ? @"Facebook connection successful" : @"Could not connect to Facebook";
    NSString *subtitle = success ? nil : @"Another user is linked to this facebook account";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:subtitle
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pauseUI
{
    [self.activityIndicator startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)unpauseUI
{
    [self.activityIndicator stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isAnonymousUser) {
        return 4;
    } else {
        return 3;
    }
}


#pragma mark - Getters

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 0;
        
        if (self.userAccount.currentInvestingGame) {
            _numberFormatter.locale = self.userAccount.currentInvestingGame.locale;
        } else {
            _numberFormatter.locale = self.userAccount.localeDefault;
        }
    }
    
    return _numberFormatter;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activityIndicator.center = self.view.center;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityIndicator];
    }
    
    return _activityIndicator;
}









@end

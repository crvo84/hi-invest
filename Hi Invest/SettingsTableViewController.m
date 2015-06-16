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

#import "SideMenuRootViewController.h"


@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *initialCashLabel;
@property (weak, nonatomic) IBOutlet UIStepper *initialCashStepper;
@property (weak, nonatomic) IBOutlet UISwitch *disguiseCompaniesSwitch;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
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
    self.userAccount.simulatorInitialCash = self.initialCashStepper.value;

    [self updateUI];
}


- (IBAction)disguiseCompaniesSwitchValueChanged:(UISwitch *)sender
{
    if (!sender.isOn) {
        [self presentAlertViewWithTitle:@"Disguise disabled" withMessage:@"Simulator results will not be recorded." withActionTitle:@"Dismiss"];
    }
    
    self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.isOn;
    
    [self updateUI];
}


#pragma mark - User Login/Logout

- (IBAction)logout:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self pauseUI];
    
        [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
            
            [self unpauseUI];
            
            if (!error) {
                
                [self performSegueWithIdentifier:@"logout" sender:self];
                
            } else {

                [self presentAlertViewWithTitle:@"Could not Log Out" withMessage:[error localizedDescription] withActionTitle:@"Dismiss"];
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

    if (!user.objectId) {
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                // The object has been saved.
                [self.userAccount migrateUserInfoToParseUser];
                
                [self linkParseUserWithFacebookAccount];
                
            }  else {

                NSString *message = error ? [error localizedDescription] : @"Please try again";
                [self presentAlertViewWithTitle:@"Could not connect to Facebook" withMessage:message withActionTitle:@"Dismiss"];
            }
            
            [self unpauseUI];
        }];
        
    } else { // Parse user already in the cloud
        
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue]) {
            [self.userAccount migrateUserInfoToParseUser];
        }
        
        [self linkParseUserWithFacebookAccount];
    }
}

- (void)linkParseUserWithFacebookAccount
{
    PFUser *user = [PFUser currentUser];
    
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissions block:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                
                self.isAnonymousUser = NO;
                
                SideMenuRootViewController *sideMenuRootViewController = (SideMenuRootViewController *)self.sideMenuViewController;
                [sideMenuRootViewController loadFacebookUserInfo];
                
            }
            
            [self updateUI];
            
            [self unpauseUI];
            
            NSString *title = succeeded ? @"Facebook connection successful!" : @"Could not connect to Facebook";
            NSString *message = succeeded ? nil : [error localizedDescription];
            [self presentAlertViewWithTitle:title withMessage:message withActionTitle:@"Dismiss"];
            
        }];
        
    } else {
        [self unpauseUI];
    }
}

- (void)presentAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pauseUI
{
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if (![app isIgnoringInteractionEvents]) {
        [app beginIgnoringInteractionEvents];
    }
}

- (void)unpauseUI
{
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app isIgnoringInteractionEvents]) {
        [app endIgnoringInteractionEvents];
    }
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

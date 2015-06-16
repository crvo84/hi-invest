//
//  SignupLoginViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SignupLoginViewController.h"
#import "ManagedObjectContextCreator.h"
#import "UserAccount.h"
#import "ManagedObjectContextCreator.h"
#import "InvestingGame.h"
#import "SideMenuRootViewController.h"
#import "Scenario.h"
#import "GameInfo+Create.h"
#import "UserDefaultsKeys.h"
#import "ParseUserKeys.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface SignupLoginViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UserAccount *userAccount;

@end

@implementation SignupLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showAllSubviews:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:ParseUserInfoSavedInParseUser] boolValue];
    
    if ([PFFacebookUtils isLinkedWithUser:user] || (user.objectId  && infoSavedInParseUser)) {
        // If current user is linked to facebook, or guest is already saved in the cloud
        
        [self performSegueWithIdentifier:@"Login" sender:self];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:ParseUserGuestAutomaticLogin] boolValue]) {
        
        [self pauseUI];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                // The user has been saved in the cloud
                
                [self.userAccount migrateUserInfoToParseUser];
                
            } else {
                // Could not save user. Maybe no internet connection
                
            }
            
            [self unpauseUI];
            
            [self performSegueWithIdentifier:@"Login" sender:self];
            
        }];
    }
    
    [self showAllSubviews:YES animated:YES];
}


- (IBAction)facebookLogin:(id)sender
{
    [self pauseUI];
    
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
            [self unpauseUI];
            
            [self presentFacebookConnectionAlertWithSuccess:NO withErrorMessage:error.description];
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            [self.userAccount deleteAllGameInfoManagedObjects];
            
            [self.userAccount deleteAllUserDefaults];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ParseUserInfoSavedInParseUser];
            
            [self loadFacebookUserInfo];
            
        } else {
            NSLog(@"User logged in through Facebook!");
            
            [self.userAccount deleteAllGameInfoManagedObjects];
            
            [self.userAccount deleteAllUserDefaults];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ParseUserInfoSavedInParseUser];
            
            [self loadFacebookUserInfo];
            
        }
        
    }];
}


- (IBAction)anonymousLogin:(id)sender
{
    [self pauseUI];
    
    // Try to save in the cloud
    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
            // If failed to log in, maybe no internet connection
            // User Info will be saved locally
            NSLog(@"Anonymous login failed.");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@(YES) forKey:ParseUserGuestAutomaticLogin];
            [defaults setObject:@(NO) forKey:ParseUserInfoSavedInParseUser];
            
        } else {
            // Anonymous user saved in the cloud
            // User Info will be saved in ParseUser
            NSLog(@"Anonymous user logged in.");
//            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ParseUserInfoSavedInParseUser];
            [self.userAccount migrateUserInfoToParseUser];
            
        }
             
        [self unpauseUI];
        
        [self performSegueWithIdentifier:@"Login" sender:self];
    }];
    
}

- (void)presentFacebookConnectionAlertWithSuccess:(BOOL)success withErrorMessage:(NSString *)errorMessage
{
    NSString *title = success ? @"Facebook connection successful" : @"Could not connect to Facebook";
    NSString *subtitle = success ? nil : errorMessage;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:subtitle
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    
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

- (void)showAllSubviews:(BOOL)showAllSubviews animated:(BOOL)animated
{
    double duration = animated ? 0.3 : 0.0;
    
    for (UIView *subview in [self.view subviews]) {
        [UIView animateWithDuration:duration animations:^{
            subview.alpha = showAllSubviews ? 1.0 : 0.0;
        }];
    }
}

#pragma mark - Fetch user info from Facebook

// IF ANY CHANGE MADE HERE, DO IT ALSO IN THE SAME METHOD AT SETTINGS VIEW CONTROLLER!!
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
            
            [self unpauseUI];
            
            [self performSegueWithIdentifier:@"Login" sender:self];
        }];
    } else {
        NSLog(@"Error. Parse User not linked to Facebook, cannot load Facebook User Info");
        
        [self unpauseUI];
    }
}


#pragma mark - Getters

- (UserAccount *)userAccount
{
    if (!_userAccount) {
        
        _userAccount = [[UserAccount alloc] init];
    }
    
    return _userAccount;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activityIndicator.center = self.view.center;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview:_activityIndicator];
    }
    
    return _activityIndicator;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SideMenuRootViewController class]]) {
        SideMenuRootViewController *sideMenuRootViewController = (SideMenuRootViewController *)segue.destinationViewController;
        
        sideMenuRootViewController.userAccount = self.userAccount;
    }
}

#pragma mark - Unwind Segues

// Use it when login out the user account
- (IBAction)unwindToSignupViewController:(UIStoryboardSegue *)unwindSegue
{
    [self.userAccount deleteAllUserDefaults];
    [self.userAccount deleteAllGameInfoManagedObjects];
    self.userAccount = nil;
}

@end

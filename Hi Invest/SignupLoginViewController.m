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
#import "FriendStore.h"
#import "UserDefaultsKeys.h"
#import "ParseUserKeys.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface SignupLoginViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIView *facebookBackgroundView;
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *skipLoginButton;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UserAccount *userAccount;

@end

@implementation SignupLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoImageView.image = [[UIImage imageNamed:@"logoFit80x110"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.logoImageView.tintColor = [UIColor whiteColor];
    
    self.facebookBackgroundView.layer.cornerRadius = self.facebookBackgroundView.frame.size.height / 2;
    self.facebookBackgroundView.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.facebookBackgroundView.alpha = 0.0;
    self.facebookLoginButton.alpha = 0.0;
    self.skipLoginButton.alpha = 0.0;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    if ([PFFacebookUtils isLinkedWithUser:user] || (user.objectId  && infoSavedInParseUser)) {
        // If current user is linked to facebook, or guest is already saved in the cloud
        
        [self performSegueWithIdentifier:@"Login" sender:self];
        
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsGuestAutomaticLogin] boolValue]) {
        
        [self pauseUI];
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                // The user has been saved in the cloud
                
                [self.userAccount migrateUserInfoToParseUser];
            }
            
            [self unpauseUI];
            
            [self performSegueWithIdentifier:@"Login" sender:self];
            
        }];
        
    } else {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.facebookBackgroundView.alpha = 1.0;
            self.facebookLoginButton.alpha = 1.0;
            self.skipLoginButton.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }

}


//- (void)moveLogoToFinalPosition
//{
//    CGPoint finalLogoCenter = self.logoImageView.center;
//    
//    // Starting Logo Center
//    CGPoint startingLogoCenter = self.view.center;
//
//    self.logoImageView.center = startingLogoCenter;
//    self.logoImageView.alpha = 1.0;
//
//    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.logoImageView.center = finalLogoCenter;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
//            self.facebookLoginButton.alpha = 1.0;
//            self.skipLoginButton.alpha = 1.0;
//        } completion:^(BOOL finished) {
//
//        }];
//    }];
//}


- (IBAction)facebookLogin:(id)sender
{
    [self pauseUI];
    
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
            [self unpauseUI];
            
            [self presentFacebookConnectionAlertWithSuccess:NO withErrorMessage:@"Please try again."];
            
        } else {
            
            NSLog(@"User logged in through Facebook!");
            
            [[FriendStore sharedStore] removeAllFriends];
            
            [self.userAccount deleteAllGameInfoManagedObjects];
            
            [self.userAccount deleteAllUserDefaults];
            
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:UserDefaultsInfoSavedInParseUser];
            
            [self unpauseUI];
            
            [self performSegueWithIdentifier:@"Login" sender:self];

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
            [defaults setObject:@(YES) forKey:UserDefaultsGuestAutomaticLogin];
            [defaults setObject:@(NO) forKey:UserDefaultsInfoSavedInParseUser];
            
        } else {
            // Anonymous user saved in the cloud
            // User Info will be saved in ParseUser
            NSLog(@"Anonymous user logged in.");

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
    
    [[FriendStore sharedStore] removeAllFriends];
    [self.userAccount deleteAllGameInfoManagedObjects];
    [self.userAccount deleteAllUserDefaults];
    self.userAccount = nil;
}

@end

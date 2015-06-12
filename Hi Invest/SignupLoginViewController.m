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

@end

@implementation SignupLoginViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"Login" sender:nil];
    }
}


- (IBAction)facebookLogin:(id)sender
{
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            
            [self resetSimulatorGamesExceptFromUserId:user.objectId];
            [self resetSettings];
            [self loadFacebookUserInfo];
            
        } else {
            NSLog(@"User logged in through Facebook!");
            
            [self resetSimulatorGamesExceptFromUserId:user.objectId];
            [self resetSettings];
            [self loadFacebookUserInfo];
        }
        
    }];
}

#pragma mark - Fetch user info from Facebook

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
                
                [self performSegueWithIdentifier:@"Login" sender:nil];
            }
        }];
    }
}

#pragma mark - Reset Simulator and settings

- (void)resetSimulatorGamesExceptFromUserId:(NSString *)userId
{
    NSManagedObjectContext *context = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    
    [GameInfo removeAllExistingGameInfoExceptFromUserId:userId
                               intoManagedObjectContext:context];
}

- (void)resetSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:UserDefaultsSelectedScenarioFilenameKey];
    [userDefaults removeObjectForKey:UserDefaultsSimulatorInitialCashKey];
    [userDefaults removeObjectForKey:UserDefaultsSimulatorDisguiseCompaniesKey];
    [userDefaults removeObjectForKey:UserDefaultsProfilePictureKey];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SideMenuRootViewController class]]) {
        SideMenuRootViewController *sideMenuRootViewController = (SideMenuRootViewController *)segue.destinationViewController;
        
        // TODO: do user account loading here!
        sideMenuRootViewController.userAccount = [[UserAccount alloc] init];
    }
}

#pragma mark - Unwind Segues
// Use it when login out the user account
- (IBAction)unwindToSignupViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end

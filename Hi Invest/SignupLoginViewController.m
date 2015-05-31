//
//  SignupLoginViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SignupLoginViewController.h"
#import "UserAccount.h"
#import "ManagedObjectContextCreator.h"
#import "InvestingGame.h"
#import "SideMenuRootViewController.h"
#import "Scenario.h"

@interface SignupLoginViewController ()

@end

@implementation SignupLoginViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSegueWithIdentifier:@"Login" sender:nil];
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
- (IBAction)unwindToInitialViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end

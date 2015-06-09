//
//  SideMenuRootViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SideMenuRootViewController.h"
#import "UserAccount.h"
#import "InvestingGame.h"
#import "UserAccountViewController.h"
#import "SimulatorTabBarController.h"
#import "CompaniesViewController.h"
#import "SelectOrderingValueViewController.h"
#import "LeftMenuViewController.h"
#import "TimeSimulationViewController.h"
#import "SimulatorInfoViewController.h"

@interface SideMenuRootViewController ()

@end

@implementation SideMenuRootViewController

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
//    self.contentViewShadowColor = [UIColor blackColor];
//    self.contentViewShadowOffset = CGSizeMake(0, 0);
//    self.contentViewShadowOpacity = 0.6;
//    self.contentViewShadowRadius = 12;
//    self.contentViewShadowEnabled = YES;
    self.contentViewFadeOutAlpha = 0.75;
    self.animationDuration = 0.15f;
    self.parallaxEnabled = NO;

    // Testing
    self.contentViewScaleValue = 1.0f;
    self.contentViewInPortraitOffsetCenterX = 100.0f;
    self.contentViewInLandscapeOffsetCenterX = 100.0f;
    
    self.delegate = self;
}


#pragma mark - Content View Controllers Initialization


// For Initial Content View Controller
- (UINavigationController *)getUserAccountNavigationControllerWithUserAccount:(UserAccount *)userAccount
{
    UINavigationController *userAccountNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"User Account UINavigationController"];
    if ([[userAccountNavigationController.viewControllers firstObject] isKindOfClass:[UserAccountViewController class]]) {
        UserAccountViewController *userAccountViewController = [userAccountNavigationController.viewControllers firstObject];
        userAccountViewController.userAccount = userAccount;
    }
    
    return userAccountNavigationController;
}

#pragma mark - Setters

- (void)setUserAccount:(UserAccount *)userAccount
{
    _userAccount = userAccount;
    
    // Initialize LeftMenuViewController
    LeftMenuViewController *leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    leftMenuViewController.userAccount = userAccount;
    self.leftMenuViewController = leftMenuViewController;
    
    // Initialize Initial ContentViewController (UserAccountViewController)
    UINavigationController *userAccountNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"User Account UINavigationController"];
    UserAccountViewController *userAccountViewController = [userAccountNavigationController.viewControllers firstObject];
    userAccountViewController.userAccount = userAccount;
    [self setContentViewController:userAccountNavigationController animated:NO];
    
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    if ([menuViewController isKindOfClass:[LeftMenuViewController class]]) {
        [((LeftMenuViewController *)menuViewController) updateUI];
    }
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
   
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{

}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{

}

#pragma mark - Time Simulation Menu


- (IBAction)presentTimeSimulationMenu:(id)sender
{
    InvestingGame *game = self.userAccount.currentInvestingGame;
    
    NSInteger initialDay = [game currentDay];
    NSInteger daysLeft = [game daysLeft];
    
    if (daysLeft == 0) {
        [self presentDayUpdateAfterNumberOfSeconds:0.1];
        return;
    }
    
    NSString *titleStr = @"Time Simulation";
    NSString *message = [NSString stringWithFormat:@"%ld days left", (long)daysLeft];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *dayAction = [UIAlertAction actionWithTitle:@"Day" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:0 andDays:1]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    UIAlertAction *weekAction = [UIAlertAction actionWithTitle:@"Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:0 andDays:7]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    UIAlertAction *monthAction = [UIAlertAction actionWithTitle:@"Month" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:1 andDays:0]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    UIAlertAction *sixMonthsAction = [UIAlertAction actionWithTitle:@"Six Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:6 andDays:0]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    UIAlertAction *yearAction = [UIAlertAction actionWithTitle:@"Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:1 months:0 andDays:0]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    // FOR DEBUGGING
    UIAlertAction *tenYearsAction = [UIAlertAction actionWithTitle:@"10 Years" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([game changeCurrentDateToDateWithTimeDifferenceInYears:10 months:0 andDays:0]) {
            NSInteger newDay = [game currentDay];
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(newDay - initialDay)];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:dayAction];
    [alert addAction:weekAction];
    [alert addAction:monthAction];
    [alert addAction:sixMonthsAction];
    [alert addAction:yearAction];
    [alert addAction:tenYearsAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Unwind Segues

- (IBAction)unwindToSideMenuRootViewController:(UIStoryboardSegue *)unwindSegue
{
    UIViewController *contentViewController = self.contentViewController;

    // GET THE VISIBLE VIEW CONTROLLER
    if ([contentViewController isKindOfClass:[UITabBarController class]]) {
        // if its a UITabBarController, get the selected tab
        contentViewController = ((UITabBarController *)contentViewController).selectedViewController;
    }
    if ([contentViewController isKindOfClass:[UINavigationController class]]) {
        // if its a UINavigationController
        UINavigationController *navigationController = (UINavigationController *)contentViewController;
        
        // Get the visible view controller from the UINavigation Controller
        contentViewController = navigationController.topViewController;
    }
    
    // UNWIND FROM TimeSimulationViewController
    if ([unwindSegue.sourceViewController isKindOfClass:[TimeSimulationViewController class]]) {

            [self presentDayUpdateAfterNumberOfSeconds:0.1];
    }
    
    // UNWIND FROM SimulatorGameOverViewController
    if ([unwindSegue.sourceViewController isKindOfClass:[SimulatorInfoViewController class]]) {
        if ([unwindSegue.identifier isEqualToString:@"Reset Game"]) {
            [self.userAccount deleteCurrentInvestingGame];
            [self.userAccount newInvestingGame];
            if ([self.contentViewController isKindOfClass:[SimulatorTabBarController class]]) {
                ((SimulatorTabBarController *)self.contentViewController).userAccount = self.userAccount;
                
            }
            [self presentDayUpdateAfterNumberOfSeconds:0.1];
        }
    }
    
    // UNWIND FROM SelectOrderingValueViewController
    if ([unwindSegue.sourceViewController isKindOfClass:[SelectOrderingValueViewController class]]) {
        if ([contentViewController isKindOfClass:[CompaniesViewController class]]) {
            SelectOrderingValueViewController *selectOrderingValueViewController = (SelectOrderingValueViewController *)unwindSegue.sourceViewController;
            CompaniesViewController *companiesViewController = (CompaniesViewController *)contentViewController;
            NSString *selectedIdentifier = selectOrderingValueViewController.selectedIdentifier;
            companiesViewController.sortingValueId = selectedIdentifier;
        }
    }
    
    if ([contentViewController respondsToSelector:@selector(updateUI)]) {
        // if the view controller UI can be updated
        [contentViewController performSelector:@selector(updateUI)];
    }
}

- (void)presentDayUpdateAfterNumberOfSeconds:(double)seconds
{
    // Wait some time to let TimeSimulationViewController dismiss completely
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self performSegueWithIdentifier:@"Simulator Info" sender:self];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SimulatorInfoViewController class]]) {
        [self prepareSimulatorInfoViewController:segue.destinationViewController withInvestingGame:[self.userAccount currentInvestingGame]];
    }
    
    if ([segue.destinationViewController isKindOfClass:[TimeSimulationViewController class]]) {
        if ([sender isKindOfClass:[NSNumber class]]) {
            NSNumber *senderNumber = (NSNumber *)sender;
            NSInteger numberOfDays = [senderNumber integerValue];
            [self prepareTimeSimulationViewController:segue.destinationViewController withNumberOfDays:numberOfDays];
        }
    }
}

- (void)prepareSimulatorInfoViewController:(SimulatorInfoViewController *)simulatorInfoViewController withInvestingGame:(InvestingGame *)game
{
    simulatorInfoViewController.game = game;
}

- (void)prepareTimeSimulationViewController:(TimeSimulationViewController *)timeSimulationViewController withNumberOfDays:(NSInteger)numberOfDays
{
    timeSimulationViewController.daysNum = numberOfDays;
}


@end

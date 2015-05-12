//
//  SideMenuRootViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SideMenuRootViewController.h"
#import "InvestingGame.h"
#import "CompaniesViewController.h"
#import "SelectOrderingValueViewController.h"
#import "PortfolioTableViewController.h"
#import "SimulatorInfoViewController.h"
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

#pragma mark - Setters

- (void)setGame:(InvestingGame *)game
{
    _game = game;
    
    self.contentViewController = [self getInvestTabBarViewControllerWithGame:game];
    
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
    if ([self.leftMenuViewController isKindOfClass:[LeftMenuViewController class]]) {
        [self prepareLeftMenuViewController:(LeftMenuViewController *)self.leftMenuViewController withInvestingGame:game];
    }
}


- (void)prepareInvestTabBarViewController:(UIViewController *)viewController withInvestingGame:(InvestingGame *)game
{
    /* FIND THE TAB BAR CONTROLLER */
    
    // Is it a split view controller (IPAD) ?
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        // In a split view controller, the UITabBarContrller will be at the master view controller
        viewController = ((UISplitViewController *)viewController).viewControllers[0];
    }
    
    // Is it a tab bar controller ?
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        // Tab bar controller found
        
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        NSUInteger tabsCount = [tabBarController.viewControllers count];
        
        if (tabsCount > 0) {
            /* COMPANIES VIEW CONTROLLER PREPARATION */
            // CompaniesViewController will be the first view controller (or embedded inside a Navigation Controller)
            UIViewController *companiesTabViewController = tabBarController.viewControllers[0];
            // Is it a navigation controller?
            if ([companiesTabViewController isKindOfClass:[UINavigationController class]]) {
                companiesTabViewController = [((UINavigationController *)companiesTabViewController).viewControllers firstObject];
            }
            if ([companiesTabViewController isKindOfClass:[CompaniesViewController class]]) {
                // Found the CompaniesViewController
                CompaniesViewController *companiesViewController = (CompaniesViewController *)companiesTabViewController;
                companiesViewController.game = game;
            }
        }
        
        if (tabsCount > 1) {
            /* PORFOLIO VIEW CONTROLLER PREPARATION */
            // PortfolioViewController will be the second view controller (or embedded inside a Navigation Controller)
            UIViewController *portfolioTabViewController = tabBarController.viewControllers[1];
            // Is it a navigation controller?
            if ([portfolioTabViewController isKindOfClass:[UINavigationController class]]) {
                portfolioTabViewController = [((UINavigationController *)portfolioTabViewController).viewControllers firstObject];
            }
            if ([portfolioTabViewController isKindOfClass:[PortfolioTableViewController class]]) {
                // Found the portfolioViewController
                PortfolioTableViewController *porfolioViewController = (PortfolioTableViewController *)portfolioTabViewController;
                porfolioViewController.game = game;
            }
        }
    
    }
}

- (void)prepareLeftMenuViewController:(LeftMenuViewController *)leftMenuViewController withInvestingGame:(InvestingGame *)game
{
    leftMenuViewController.game = game;
}


#pragma mark - Content View Controllers Initialization

- (UITabBarController *)getInvestTabBarViewControllerWithGame:(InvestingGame *)game
{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Invest UITabBarController"];
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *investTabBarViewController = (UITabBarController *)viewController;
        [self prepareInvestTabBarViewController:investTabBarViewController withInvestingGame:game];
        return investTabBarViewController;
    } else {
        return nil;
    }
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    // FOR TESTING
    self.contentViewInPortraitOffsetCenterX = 100.0f;
    self.contentViewInLandscapeOffsetCenterX = 100.0f;
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
    NSInteger daysLeft = [self.game daysLeft];
    
    NSString *message = [NSString stringWithFormat:@"Days left: %ld  |  Select a period of time.", (long)daysLeft];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Time Simulation"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *dayAction = [UIAlertAction actionWithTitle:@"Day" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:0 andDays:1]) {
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(1)];
        }
    }];
    
    UIAlertAction *weekAction = [UIAlertAction actionWithTitle:@"Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:0 andDays:7]) {
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(7)];
        }
    }];
    
    UIAlertAction *monthAction = [UIAlertAction actionWithTitle:@"Month" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:1 andDays:0]) {
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(30)];
        }
    }];
    
    UIAlertAction *sixMonthsAction = [UIAlertAction actionWithTitle:@"Six Months" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.game changeCurrentDateToDateWithTimeDifferenceInYears:0 months:6 andDays:0]) {
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(180)];
        }
    }];
    
    UIAlertAction *yearAction = [UIAlertAction actionWithTitle:@"Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self.game changeCurrentDateToDateWithTimeDifferenceInYears:1 months:0 andDays:0]) {
            [self performSegueWithIdentifier:@"Time Simulation" sender:@(365)];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if (daysLeft >= 1) [alert addAction:dayAction];
    if (daysLeft >= 7) [alert addAction:weekAction];
    if (daysLeft >= 30) [alert addAction:monthAction];
    if (daysLeft >= 180) [alert addAction:sixMonthsAction];
    if (daysLeft >= 365) [alert addAction:yearAction];
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
        [self prepareSimulatorInfoViewController:segue.destinationViewController withInvestingGame:self.game];
    }
    
    if ([segue.destinationViewController isKindOfClass:[TimeSimulationViewController class]]) {
        if ([sender isKindOfClass:[NSNumber class]]) {
            NSNumber *senderNumber = (NSNumber *)sender;
            NSInteger numberOfDays = [senderNumber integerValue];
            if (numberOfDays <= 365 || numberOfDays > 0) {
                [self prepareTimeSimulationViewController:segue.destinationViewController withNumberOfDays:numberOfDays];
            }
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

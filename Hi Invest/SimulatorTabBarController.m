//
//  SimulatorTabBarController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SimulatorTabBarController.h"
#import "CompaniesViewController.h"
#import "PortfolioTableViewController.h"
#import "UserAccount.h"
#import "InvestingGame.h"

@interface SimulatorTabBarController ()

@property (strong, nonatomic) InvestingGame *game;

@end

@implementation SimulatorTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Setters

- (void)setUserAccount:(UserAccount *)userAccount
{
    _userAccount = userAccount;
    
    [self prepareSimulatorTabBarControllerWithUserAccount:userAccount];
}


- (void)prepareSimulatorTabBarControllerWithUserAccount:(UserAccount *)userAccount
{
    NSUInteger tabsCount = [self.viewControllers count];
    
    InvestingGame *game = [userAccount currentInvestingGame];
    
    if (tabsCount > 0) {
        /* COMPANIES VIEW CONTROLLER PREPARATION */
        // CompaniesViewController will be the first view controller (or embedded inside a Navigation Controller)
        UIViewController *companiesTabViewController = self.viewControllers[0];
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
        UIViewController *portfolioTabViewController = self.viewControllers[1];
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


@end

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
#import "PortfolioActivityViewController.h"
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

- (void)didReceiveMemoryWarning
{
    [self.game.gameInfoContext save:nil];
    
    [super didReceiveMemoryWarning];
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

    if (tabsCount > 0) {
        /* PORFOLIO VIEW CONTROLLER PREPARATION */
        // PortfolioViewController will be the first view controller (or embedded inside a Navigation Controller)
        UIViewController *viewController = self.viewControllers[0];
        // Is it a navigation controller?
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [((UINavigationController *)viewController).viewControllers firstObject];
        }
        if ([viewController isKindOfClass:[PortfolioTableViewController class]]) {
            // Found the PortfolioViewController
            PortfolioTableViewController *portfolioViewController = (PortfolioTableViewController *)viewController;
            portfolioViewController.game = self.game;
        }
    }
    
    if (tabsCount > 1) {
        /* COMPANIES VIEW CONTROLLER PREPARATION */
        // CompaniesViewController will be the second view controller (or embedded inside a Navigation Controller)
        UIViewController *viewController = self.viewControllers[1];
        // Is it a navigation controller?
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [((UINavigationController *)viewController).viewControllers firstObject];
        }
        if ([viewController isKindOfClass:[CompaniesViewController class]]) {
            // Found the CompaniesViewController
            CompaniesViewController *companiesViewController = (CompaniesViewController *)viewController;
            companiesViewController.game = self.game;
        }
    }
    
    if (tabsCount > 2) {
        /* PORTFOLIO ACTIVITY VIEW CONTROLLER PREPARATION */
        // PortfolioActivityViewController will be the third view controller (Or embedded inside a Navigation Controller)
        UIViewController *viewController = self.viewControllers[2];
        // Is it a navigation controller?
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            viewController = [((UINavigationController *)viewController).viewControllers firstObject];
        }
        if ([viewController isKindOfClass:[PortfolioActivityViewController class]]) {
            // Found the PortfolioActivityViewController
            PortfolioActivityViewController *portfolioActivityViewController = (PortfolioActivityViewController *)viewController;
            portfolioActivityViewController.game = self.game;
        }
    }
}

#pragma mark - Getters

- (InvestingGame *)game
{
    if (!self.userAccount.currentInvestingGame) {
        [self.userAccount newInvestingGame];
    }
    
    return self.userAccount.currentInvestingGame;
}










@end

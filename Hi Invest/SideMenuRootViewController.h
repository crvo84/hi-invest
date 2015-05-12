//
//  SideMenuRootViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "RESideMenu.h"

@class InvestingGame;

@interface SideMenuRootViewController : RESideMenu <RESideMenuDelegate>

@property (strong, nonatomic) InvestingGame *game;

- (UITabBarController *)getInvestTabBarViewControllerWithGame:(InvestingGame *)game;

@end

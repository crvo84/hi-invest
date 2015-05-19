//
//  SideMenuRootViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "RESideMenu.h"

@class InvestingGame;
@class UserAccount;

@interface SideMenuRootViewController : RESideMenu <RESideMenuDelegate>

@property (strong, nonatomic) UserAccount *userAccount;

@end

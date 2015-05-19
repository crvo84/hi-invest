//
//  SimulatorTabBarController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAccount;

@interface SimulatorTabBarController : UITabBarController

@property (strong, nonatomic) UserAccount *userAccount;

@end

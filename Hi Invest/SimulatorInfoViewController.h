//
//  SimulatorInfoViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/20/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;
@class UserAccount;

@interface SimulatorInfoViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;
@property (strong, nonatomic) UserAccount *userAccount;

@end

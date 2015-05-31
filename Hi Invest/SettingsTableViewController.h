//
//  SettingsTableViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserAccount;

@interface SettingsTableViewController : UITableViewController

@property (strong, nonatomic) UserAccount *userAccount;

@end

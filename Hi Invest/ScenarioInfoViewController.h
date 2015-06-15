//
//  ScenarioInfoViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScenarioPurchaseInfo;
@class UserAccount;

@interface ScenarioInfoViewController : UIViewController

@property (strong, nonatomic) UserAccount *userAccount;
@property (strong, nonatomic) ScenarioPurchaseInfo *scenarioPurchaseInfo;
@property (strong, nonatomic) NSLocale *locale;
@property (nonatomic) BOOL isFileInBundle;

@end

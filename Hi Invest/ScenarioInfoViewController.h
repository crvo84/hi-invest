//
//  ScenarioInfoViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScenarioPurchaseInfo;

@interface ScenarioInfoViewController : UIViewController

@property (strong, nonatomic) ScenarioPurchaseInfo *scenarioPurchaseInfo;
@property (strong, nonatomic) NSLocale *locale;

@end

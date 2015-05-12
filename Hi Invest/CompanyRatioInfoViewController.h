//
//  CompanyRatioInfoViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/26/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface CompanyRatioInfoViewController : UIViewController

@property (strong, nonatomic) NSString *valueId;
@property (strong, nonatomic) NSString *ticker;
@property (strong, nonatomic) InvestingGame *game;

@end

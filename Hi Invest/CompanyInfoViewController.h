//
//  CompanyInfoViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface CompanyInfoViewController : UIViewController

@property (copy, nonatomic) NSString *ticker;
@property (strong, nonatomic) InvestingGame *game;

@end

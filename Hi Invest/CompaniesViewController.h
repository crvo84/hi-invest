//
//  CompaniesViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestingGame.h"

@interface CompaniesViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;

// This property is public so SelectOrderingValueViewController can access it.
@property (strong, nonatomic) NSString *sortingValueId;

@end

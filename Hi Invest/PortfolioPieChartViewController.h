//
//  PortfolioPieChartViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/22/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface PortfolioPieChartViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;
@property (strong, nonatomic) NSString *ticker;

@end

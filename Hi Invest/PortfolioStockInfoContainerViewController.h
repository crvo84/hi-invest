//
//  PortfolioStockInfoContainerViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;
@class Price;

@interface PortfolioStockInfoContainerViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;
@property (copy, nonatomic) NSString *ticker;

@end

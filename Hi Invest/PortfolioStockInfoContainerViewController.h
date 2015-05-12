//
//  PortfolioStockInfoContainerViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ContainerViewController.h"

@class InvestingGame;
@class Price;

@interface PortfolioStockInfoContainerViewController : ContainerViewController

@property (strong, nonatomic) InvestingGame *game;
@property (copy, nonatomic) NSString *ticker;

@end

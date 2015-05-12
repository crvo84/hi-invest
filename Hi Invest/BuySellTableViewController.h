//
//  BuySellTableViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface BuySellTableViewController : UITableViewController

@property (strong, nonatomic) InvestingGame *game;
@property (copy, nonatomic) NSString *ticker;

@end

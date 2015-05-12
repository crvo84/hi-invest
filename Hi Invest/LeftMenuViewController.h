//
//  LeftMenuViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface LeftMenuViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;

- (void)updateUI;

@end

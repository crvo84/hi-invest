//
//  InfoPageContentViewController.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface InfoPageContentViewController : UIViewController

@property (nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) InvestingGame *game;

@end

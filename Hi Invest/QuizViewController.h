//
//  QuizViewController.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvestingGame;

@interface QuizViewController : UIViewController

@property (strong, nonatomic) InvestingGame *game;
@property (strong, nonatomic) NSMutableArray *questions; // of QuizQuestion
@property (strong, nonatomic) NSString *categoryName;
@property (nonatomic) NSUInteger finalScore;

@end

//
//  UserAccount.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"

@class InvestingGame;

@interface UserAccount : NSObject

@property (nonatomic, readonly) NSInteger userLevel;
@property (strong, nonatomic, readonly) InvestingGame *currentInvestingGame;
// Settings
@property (nonatomic) double scenarioInitialCash;
@property (nonatomic) BOOL changeOriginalCompanyNamesAndTickers;

- (void)increaseQuizLevelForQuizType:(QuizType)quizType;

// Return the current (Unfinished quiz level) for the given quiz type
- (NSInteger)currentQuizLevelForQuizType:(QuizType)quizType;

// Return the user ninja level (1 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;

@end

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

@property (strong, nonatomic, readonly) InvestingGame *currentInvestingGame;
@property (copy, nonatomic) NSLocale *localeDefault; // Default NSLocale (Others: QuizGenerator, each scenario)
// Settings
@property (nonatomic) double simulatorInitialCash;
@property (nonatomic) BOOL disguiseCompanies;

- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType;

// Return the current number of successful quizzes for the given quiz type
// Return 0 (initial level) if there is no record for the given quiz type
- (NSInteger)successfulQuizzesForQuizType:(QuizType)quizType;

// Return the user ninja level (0 is the lowest) depending on answered quizzes
- (NSInteger)currentUserLevel;

// Return the quiz progress [0,1) to get to the next user level
- (double)progressForNextUserLevel;

- (void)newInvestingGame;
- (void)exitInvestingGame;

@end

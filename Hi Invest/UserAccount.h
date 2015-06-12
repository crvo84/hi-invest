//
//  UserAccount.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quiz.h"

@class InvestingGame;
@class GameInfo;

@interface UserAccount : NSObject

@property (copy, nonatomic, readonly) NSString *userId;
@property (copy, nonatomic) NSLocale *localeDefault; // Default NSLocale (Others: QuizGenerator, each scenario)
@property (strong, nonatomic) NSManagedObjectContext *gameInfoContext;

// Investing Game
@property (strong, nonatomic, readonly) InvestingGame *currentInvestingGame;
@property (copy, nonatomic) NSString *selectedScenarioFilename;
@property (strong, nonatomic, readonly) NSArray *availableScenarios; // of ScenarioPurchaseInfo

// Settings
@property (nonatomic) double simulatorInitialCash;
@property (nonatomic) BOOL disguiseCompanies;

- (void)updateUserSimulatorInfoWithFinishedGameInfo:(GameInfo *)gameInfo;

- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType;

// Return the current number of successful quizzes for the given quiz type
// Return 0 (initial level) if there is no record for the given quiz type
- (NSInteger)successfulQuizzesForQuizType:(QuizType)quizType;

// Return the user ninja level (0 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;

// Return the quiz progress [0,1) to get to the next user level
- (double)progressForNextUserLevel;

- (void)newInvestingGame;
// Load an investing game. If given GameInfo managed object is nil, then create a completely new GameInfo.
- (void)loadInvestingGameWithGameInfo:(GameInfo *)gameInfo;
// Set the current investing game to nil
- (void)exitCurrentInvestingGame;
// Remove current investing game, if there is one.
- (void)deleteCurrentInvestingGame;
// Remove all investing games of the current user.
- (void)deleteAllUserSavedGames;

- (NSString *)userName;


@end

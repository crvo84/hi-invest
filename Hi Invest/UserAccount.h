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
@class PFUser;

@interface UserAccount : NSObject

@property (copy, nonatomic) NSLocale *localeDefault; // Default NSLocale (Others: QuizGenerator, each scenario)
@property (strong, nonatomic) NSArray *friends; // of Friend

// Investing Game
@property (strong, nonatomic, readonly) InvestingGame *currentInvestingGame;
@property (strong, nonatomic, readonly) NSArray *availableScenarios; // of ScenarioPurchaseInfo
@property (strong, nonatomic) NSManagedObjectContext *gameInfoContext; // Managed Object for GameInfo fetching

// User Settings
@property (copy, nonatomic) NSString *selectedScenarioFilename;
@property (nonatomic) double simulatorInitialCash;
@property (nonatomic) BOOL disguiseCompanies;

// User Results
@property (strong, nonatomic, readonly) NSMutableDictionary *successfulQuizzesCount; // @{ @"QuizType" : @(Current Level) }
@property (strong, nonatomic, readonly) NSMutableDictionary *finishedScenariosCount; // @{ scenarioFilename : @(finished scenarios) }
@property (strong, nonatomic, readonly) NSMutableDictionary *averageReturns; // @{ scenarioFilename : @(average Return) }
@property (strong, nonatomic, readonly) NSMutableDictionary *lowestReturns; // @{ scenarioFilename : @(lowest Return) }
@property (strong, nonatomic, readonly) NSMutableDictionary *highestReturns; // @{ scenarioFilename : @(highest Return) }

// In-App Purchases
@property (strong, nonatomic) NSDictionary *products; // @{ scenarioFilename : SKProduct }

#pragma mark - Class Methods

// Return the user ninja level (0 is the lowest) depending on answered quizzes from the given dictionary
+ (NSInteger)userLevelFromSuccessfulQuizzesCount:(NSDictionary *)successfulQuizzesCount;

#pragma mark - User Info
// Return the current user objectId, if the user is not saved on the cloud, objectId will be nil, so return @"Guest"
- (NSString *)userId;
// Return the user ninja level (0 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;
// Return the userName. If user is logged as Guest, return @"Guest", if not return Facebook first name
- (NSString *)userName;

#pragma mark - User Info management
// When a InvestingGame is finished, user its GameInfo to update user simulator Results. (only for disguised investingGames)
- (void)updateUserSimulatorInfoWithFinishedGameInfo:(GameInfo *)gameInfo;
// Copy the corresponding user info from NSUserDefaults to Parse User. Removes the info from NSUserDefaults. Updates GameInfo managed objects with parseUser objectId as userId
- (void)migrateUserInfoToParseUser;
// Reset NSUserDefaults
- (void)deleteAllUserDefaults;
// Delete all GameInfo managed objects existing in database
- (void)deleteAllGameInfoManagedObjects;

#pragma mark - Tutorial
- (void)resetTutorialsPresentedCount;
- (void)setTutorialPresented:(NSString *)tutorialPresented;
- (BOOL)wasTutorialPresented:(NSString *)tutorial;

#pragma mark - Quizzes
// Increase the number of successful quizzes finished for the given quizType and save it to the user info
- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType;
// Return the current number of successful quizzes for the given quiz type
// Return 0 (initial level) if there is no record for the given quiz type
- (NSInteger)successfulQuizzesForQuizType:(QuizType)quizType;
// Return the quiz progress [0,1) to get to the next user level.
- (double)progressForNextUserLevel;

#pragma mark - Investing Games
- (void)newInvestingGame;
// Load an investing game. If given GameInfo managed object is nil, then create a completely new GameInfo.
- (void)loadInvestingGameWithGameInfo:(GameInfo *)gameInfo;
// Set the current investing game to nil
- (void)exitCurrentInvestingGame;
// Remove current investing game, if there is one.
- (void)deleteCurrentInvestingGame;

#pragma mark - In-App Purchases
// Return YES if the scenario for the given filename is available (Free or already Purchased)
- (BOOL)isAccessOpenToScenarioWithFilename:(NSString *)filename;
- (void)setAccessOpenToScenarioWithFilename:(NSString *)filename;
- (BOOL)shouldPresentAds;
- (void)removeAds;

@end

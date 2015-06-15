//
//  UserAccount.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccount.h"
#import "InvestingGame.h"
#import "ManagedObjectContextCreator.h"
#import "ScenarioPurchaseInfo.h"
#import "Quiz.h"
#import "Scenario.h"
#import "GameInfo+Create.h"
#import "ParseUserKeys.h"
#import "UserDefaultsKeys.h"
#import <Parse/Parse.h>


@interface UserAccount ()

@property (copy, nonatomic, readwrite) NSString *userId;
@property (strong, nonatomic, readwrite) InvestingGame *currentInvestingGame;
@property (strong, nonatomic, readwrite) NSArray *availableScenarios; // of ScenarioPurchaseInfo
// PFUser info:
@property (strong, nonatomic, readwrite) NSMutableDictionary *successfulQuizzesCount; // @{ @"QuizType" : @(Current Level) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *finishedScenariosCount; // @{ scenarioFilename : @(finished) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *averageReturns; // @{ scenarioFilename : @(averageReturn) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *lowestReturns; // @{ scenarioFilename : @(lowestReturn) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *highestReturns; // @{ scenarioFilename : @(highestReturn) }

@end


@implementation UserAccount

// 7 cannot change because it was the inital number of Quiz Type. (to maintain user level continuity)
// Cannot change even in future versions of the application
#define UserAccountSuccessfulQuizzesPerUserLevel 7

#pragma mark - User Info

- (NSString *)userName
{
    // TODO: Get UserName from facebook, if not available then:
    NSString *facebookFirstName = [PFUser currentUser][ParseUserFirstName];
    
    return facebookFirstName ? facebookFirstName : @"Guest";
}

// Return the user level (0 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;
{
    return [self totalSuccessfulQuizzesCount] / UserAccountSuccessfulQuizzesPerUserLevel;
}

- (void)updateUserSimulatorInfoWithFinishedGameInfo:(GameInfo *)gameInfo
{
    PFUser *user = [PFUser currentUser];

    NSString *filename = gameInfo.scenarioFilename;
    
    double newReturn = [gameInfo.currentReturn doubleValue];
    
    
      // ------------------------ //
     // FINISHED SCENARIOS COUNT //
    // -------------------------//
    
    NSMutableDictionary *allFinishedCount = self.finishedScenariosCount;
    NSNumber *previousFinishedCountNumber = allFinishedCount[filename];
    NSNumber *newFinishedCountNumber;
    
    
    if (previousFinishedCountNumber) {
        newFinishedCountNumber = @([previousFinishedCountNumber integerValue] + 1);
        
    } else {
        newFinishedCountNumber = @(1);
    }
    allFinishedCount[filename] = newFinishedCountNumber;
    user[ParseUserFinishedScenariosCount] = allFinishedCount;
    
    
      // --------------- //
     // AVERAGE RETURNS //
    // --------------- //
    
    NSMutableDictionary *allAverageReturns = self.averageReturns;
    NSNumber *previousAverageReturnNumber = allAverageReturns[filename];
    NSNumber *newAverageReturnNumber;
    
    if (previousAverageReturnNumber) {
        
        double previousAverageReturn = [previousAverageReturnNumber doubleValue];
        NSInteger newGamesFinished = [allFinishedCount[filename] integerValue];
        NSInteger previousGamesFinished = newGamesFinished - 1; // newGamesFinished includes current finished game
        newAverageReturnNumber = @((previousAverageReturn * previousGamesFinished + newReturn) / newGamesFinished);
        
    } else {
        newAverageReturnNumber = @(newReturn);
    }
    allAverageReturns[filename] = newAverageReturnNumber;
    user[ParseUserAverageReturns] = allAverageReturns;
    
    
      // --------------- //
     // LOWEST RETURNS  //
    // --------------- //
    
    NSMutableDictionary *allLowestReturns = self.lowestReturns;
    NSNumber *previousLowestReturnNumber = allLowestReturns[filename];
    NSNumber *newLowestReturnNumber;
    
    if (previousLowestReturnNumber) {
        
        double previousLowestReturn = [previousLowestReturnNumber doubleValue];
        newLowestReturnNumber = newReturn < previousLowestReturn ? @(newReturn) : previousLowestReturnNumber;
        
    } else {
        newLowestReturnNumber = @(newReturn);
    }
    allLowestReturns[filename] = newLowestReturnNumber;
    user[ParseUserLowestReturns] = allLowestReturns;
    
    
      // --------------- //
     // HIGHEST RETURNS //
    // --------------- //
    
    NSMutableDictionary *allHighestReturns = self.highestReturns;
    NSNumber *previousHighestReturnNumber = allHighestReturns[filename];
    NSNumber *newHighestReturnNumber;
    
    if (previousHighestReturnNumber) {
        
        double previousHighestReturn = [previousHighestReturnNumber doubleValue];
        newHighestReturnNumber = newReturn > previousHighestReturn ? @(newReturn) : previousHighestReturnNumber;
        
    } else {
        newHighestReturnNumber = @(newReturn);
    }
    allHighestReturns[filename] = newHighestReturnNumber;
    user[ParseUserHighestReturns] = allHighestReturns;
    
    [self saveParseUserInfo];
}

- (void)saveParseUserInfo
{
    [[PFUser currentUser] saveEventually];
}

#pragma mark - Quizzes

// Return the quiz progress [0,1) to get to the next user level
- (double)progressForNextUserLevel
{
    return ([self totalSuccessfulQuizzesCount] % UserAccountSuccessfulQuizzesPerUserLevel) / (double)UserAccountSuccessfulQuizzesPerUserLevel;
}

- (NSInteger)totalSuccessfulQuizzesCount
{
    NSDictionary *successfulQuizzesCount = self.successfulQuizzesCount;
    
    NSInteger totalSuccessfulQuizzesCount = 0;
    
    for (NSString *key in successfulQuizzesCount) {
        
        NSNumber *quizCount = successfulQuizzesCount[key];
        totalSuccessfulQuizzesCount += [quizCount integerValue];
    }

    return totalSuccessfulQuizzesCount;
}

- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType
{
    NSNumber *newSuccessfulQuizzesNumber = @([self successfulQuizzesForQuizType:quizType] + 1);
    
    NSMutableDictionary *successfullQuizzesCount = self.successfulQuizzesCount;
    
    successfullQuizzesCount[[self stringKeyForQuizType:quizType]] = newSuccessfulQuizzesNumber;
    
    self.successfulQuizzesCount = successfullQuizzesCount;
    
    [self saveParseUserInfo];
}

// Return the current number of successful quizzes for the given quiz type
// Return 0 (initial level) if there is no record for the given quiz type
- (NSInteger)successfulQuizzesForQuizType:(QuizType)quizType
{
    NSNumber *currentSuccessfulQuizzesNumber = self.successfulQuizzesCount[[self stringKeyForQuizType:quizType]];
    
    if (currentSuccessfulQuizzesNumber) {
        return [currentSuccessfulQuizzesNumber integerValue];
    }
    
    return 0;
}

- (NSString *)stringKeyForQuizType:(QuizType)quizType
{
    return [NSString stringWithFormat:@"%ld", (long)quizType];
}

- (void)newInvestingGame
{
    [self loadInvestingGameWithGameInfo:nil];
}

// Load an investing game. If given GameInfo managed object is nil, then create a completely new GameInfo.
- (void)loadInvestingGameWithGameInfo:(GameInfo *)gameInfo
{
    NSString *scenarioFilename = gameInfo ? gameInfo.scenarioFilename : self.selectedScenarioFilename;
    
    NSManagedObjectContext *scenarioContext = [ManagedObjectContextCreator createMainQueueManagedObjectContextWithScenarioFilename:scenarioFilename];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scenario"];
    NSError *error;
    NSArray *matches = [scenarioContext executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        
        NSLog(@"Error fetching Scenario from database");
        
    } else if ([matches count] == 0) {
        
        NSLog(@"No Scenario in database");
        
    } else {
        
        Scenario *scenario = [matches firstObject];
        
        if (!gameInfo) {
            
            gameInfo = [GameInfo gameInfoWithUserId:self.userId scenarioFilename:scenarioFilename scenarioName:scenario.name initialCash:self.simulatorInitialCash currentDate:scenario.initialScenarioDate disguisingCompanies:self.disguiseCompanies intoManagedObjectContext:self.gameInfoContext];
        }
        
        if (gameInfo) {
            self.currentInvestingGame = [[InvestingGame alloc] initInvestingGameWithGameInfo:gameInfo withScenario:scenario];
        }
    }
}


// Set the current investing game to nil
- (void)exitCurrentInvestingGame
{
    self.currentInvestingGame = nil;
}

// Remove current investing game, if there is one.
- (void)deleteCurrentInvestingGame
{
    [GameInfo removeExistingGameInfoWithScenarioFilename:self.selectedScenarioFilename withUserId:self.userId intoManagedObjectContext:self.currentInvestingGame.gameInfoContext];
    
    [self exitCurrentInvestingGame];
}

// Remove all investing games of the current user.
- (void)deleteAllUserSavedGames
{
    NSManagedObjectContext *context = self.currentInvestingGame.gameInfoContext;

    if (!context) {
        context = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    }
    
    [GameInfo removeExistingGameInfoWithScenarioFilename:nil withUserId:self.userId intoManagedObjectContext:context];
    
    self.currentInvestingGame = nil;
}

#pragma mark - Getters

- (NSString *)userId
{
    NSString *currentUserObjectId = [PFUser currentUser].objectId;
    
    return currentUserObjectId;
}

- (NSString *)selectedScenarioFilename //No guardar en parse user
{
    NSString *selectedFilename = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSelectedScenarioFilenameKey];
    
    return selectedFilename ? selectedFilename : @"DEMO_001A";
}

- (double)simulatorInitialCash // No guardar en parse user
{
    NSNumber *initialCashNumber = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSimulatorInitialCashKey];
    
    return initialCashNumber ? [initialCashNumber doubleValue] : 1000000.0;
}

- (BOOL)disguiseCompanies // No guardar en parse user
{
    NSNumber *disguiseCompaniesNumber = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSimulatorDisguiseCompaniesKey];
    
    return disguiseCompaniesNumber ? [disguiseCompaniesNumber boolValue] : NO;
}

- (NSMutableDictionary *)successfulQuizzesCount
{
    NSDictionary *succesfulQuizzesCount = [PFUser currentUser][ParseUserSuccessfulQuizzesCount];
    
    return succesfulQuizzesCount ? [succesfulQuizzesCount mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)finishedScenariosCount
{
    NSDictionary *finishedScenariosCount = [PFUser currentUser][ParseUserFinishedScenariosCount];
    
    return finishedScenariosCount ? [finishedScenariosCount mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)averageReturns
{
    NSDictionary *averageReturns = [PFUser currentUser][ParseUserAverageReturns];
    
    return averageReturns ? [averageReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)lowestReturns
{
    NSDictionary *lowestReturns = [PFUser currentUser][ParseUserLowestReturns];
    
    return lowestReturns ? [lowestReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)highestReturns
{
    NSDictionary *highestReturns = [PFUser currentUser][ParseUserHighestReturns];
    
    return highestReturns ? [highestReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}


- (NSManagedObjectContext *)gameInfoContext
{
    if (!_gameInfoContext) {
        _gameInfoContext = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    }
    
    return _gameInfoContext;
}

- (NSLocale *)localeDefault
{
    if (!_localeDefault) {
        _localeDefault = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    }
    
    return _localeDefault;
}

- (NSArray *)availableScenarios
{
    // TODO: implemente in app purchases system here
    
    if (!_availableScenarios) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        // DEMO SCENARIO
        ScenarioPurchaseInfo *scenarioPurchaseInfoDemo = [[ScenarioPurchaseInfo alloc] init];
        scenarioPurchaseInfoDemo.name = @"DEMO";
        scenarioPurchaseInfoDemo.filename = @"DEMO_001A";
        scenarioPurchaseInfoDemo.descriptionForScenario = @"Scenario Demo";
        scenarioPurchaseInfoDemo.initialDate = [dateFormatter dateFromString:@"8/20/2014"];
        scenarioPurchaseInfoDemo.endingDate = [dateFormatter dateFromString:@"12/19/2014"];
        scenarioPurchaseInfoDemo.numberOfCompanies = 5;
        scenarioPurchaseInfoDemo.numberOfDays = 122;
        scenarioPurchaseInfoDemo.withAdds = NO;
        scenarioPurchaseInfoDemo.price = 0.0; // Free Demo
        scenarioPurchaseInfoDemo.sizeInMegas = [ManagedObjectContextCreator sizeInMegabytesOfDatabaseWithFilename:@"DEMO_001A"];
        
        // DEFAULT DOW JONES SCENARIO
        ScenarioPurchaseInfo *scenarioPurchaseInfo1 = [[ScenarioPurchaseInfo alloc] init];
        scenarioPurchaseInfo1.name = @"DOW JONES 30";
        scenarioPurchaseInfo1.filename = @"DJI_001A";
        scenarioPurchaseInfo1.descriptionForScenario = @"Dow Jones Industrial Average Companies.";
        scenarioPurchaseInfo1.initialDate = [dateFormatter dateFromString:@"12/20/2010"];
        scenarioPurchaseInfo1.endingDate = [dateFormatter dateFromString:@"12/19/2014"];
        scenarioPurchaseInfo1.numberOfCompanies = 30;
        scenarioPurchaseInfo1.numberOfDays = 1461;
        scenarioPurchaseInfo1.withAdds = NO;
        scenarioPurchaseInfo1.price = 0.99;
        scenarioPurchaseInfo1.sizeInMegas = [ManagedObjectContextCreator sizeInMegabytesOfDatabaseWithFilename:@"DJI_001A"];
        
        _availableScenarios = @[scenarioPurchaseInfoDemo, scenarioPurchaseInfo1];
    }
    
    return _availableScenarios;
}

#pragma mark - Setters

- (void)setSelectedScenarioFilename:(NSString *)selectedScenarioFilename
{
    [[NSUserDefaults standardUserDefaults] setObject:selectedScenarioFilename forKey:UserDefaultsSelectedScenarioFilenameKey];
}

- (void)setSimulatorInitialCash:(double)simulatorInitialCash
{
    [[NSUserDefaults standardUserDefaults] setObject:@(simulatorInitialCash) forKey:UserDefaultsSimulatorInitialCashKey];
}

- (void)setDisguiseCompanies:(BOOL)disguiseCompanies
{
    [[NSUserDefaults standardUserDefaults] setObject:@(disguiseCompanies) forKey:UserDefaultsSimulatorDisguiseCompaniesKey];
}

- (void)setSuccessfulQuizzesCount:(NSMutableDictionary *)successfulQuizzesCount
{
    [PFUser currentUser][ParseUserSuccessfulQuizzesCount] = successfulQuizzesCount;
}

- (void)setFinishedScenariosCount:(NSMutableDictionary *)finishedScenariosCount
{
    [PFUser currentUser][ParseUserFinishedScenariosCount] = finishedScenariosCount;
}

- (void)setAverageReturns:(NSMutableDictionary *)averageReturns
{
    [PFUser currentUser][ParseUserAverageReturns] = averageReturns;
}

- (void)setLowestReturns:(NSMutableDictionary *)lowestReturns
{
    [PFUser currentUser][ParseUserLowestReturns] = lowestReturns;
}

- (void)setHighestReturns:(NSMutableDictionary *)highestReturns
{
    [PFUser currentUser][ParseUserHighestReturns] = highestReturns;
}
   
   
   
   
   
   
   
   
   
   
   
   
@end

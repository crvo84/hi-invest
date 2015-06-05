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

@interface UserAccount ()

@property (strong, nonatomic, readwrite) InvestingGame *currentInvestingGame;
@property (strong, nonatomic) NSMutableDictionary *successfulQuizzesCount; // @{ @"QuizType" : @(Current Level) }
@property (strong, nonatomic, readwrite) NSArray *availableScenarios; // of ScenarioPurchaseInfo
@property (strong, nonatomic) NSManagedObjectContext *gameInfoContext;

@end

// 7 cannot change because it was the inital number of Quiz Type. (to maintain user level continuity)
// Cannot change even in future versions of the application
#define UserAccountSuccessfulQuizzesPerUserLevel 7

@implementation UserAccount

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // TODO: Should be loaded from user account
        self.simulatorInitialCash = 1000000.0;
        self.disguiseCompanies = NO;
        
        self.selectedScenarioFilename = @"DEMO_001A";
    }
    
    return self;
}

#pragma mark - User Info

- (NSString *)userName
{
    return @"Carlos Rogelio";
}

// Return the user level (0 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;
{
    return [self totalSuccessfulQuizzesCount] / UserAccountSuccessfulQuizzesPerUserLevel;
}


#pragma mark - Quizzes

// Return the quiz progress [0,1) to get to the next user level
- (double)progressForNextUserLevel
{
    return ([self totalSuccessfulQuizzesCount] % UserAccountSuccessfulQuizzesPerUserLevel) / (double)UserAccountSuccessfulQuizzesPerUserLevel;
}

- (NSInteger)totalSuccessfulQuizzesCount
{
    NSInteger totalSuccessfulQuizzesCount = 0;
    for (NSString *key in self.successfulQuizzesCount) {
        
        NSNumber *quizCount = self.successfulQuizzesCount[key];
        totalSuccessfulQuizzesCount += [quizCount integerValue];
    }

    return totalSuccessfulQuizzesCount;
}

- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType
{
    NSInteger previousSuccessfulQuizzes = [self successfulQuizzesForQuizType:quizType];
    
    self.successfulQuizzesCount[[self stringKeyForQuizType:quizType]] = @(++previousSuccessfulQuizzes);
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
    // TODO: Edit ManagedObjectContextCreator to get a context with a given scenario id
    // using self.selectedScenarioId
    NSManagedObjectContext *scenarioContext = [ManagedObjectContextCreator createMainQueueManagedObjectContextWithScenarioFilename:self.selectedScenarioFilename];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scenario"];
    NSError *error;
    NSArray *matches = [scenarioContext executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        
        NSLog(@"Error fetching Scenario from database");
        
    } else if ([matches count] == 0) {
        
        NSLog(@"No Scenario in database");
        
    } else {
        
        Scenario *scenario = [matches firstObject];
        
        GameInfo *gameInfo = [GameInfo gameInfoWithScenarioFilename:self.selectedScenarioFilename initialCash:self.simulatorInitialCash currentDate:scenario.initialScenarioDate disguisingCompanies:self.disguiseCompanies intoManagedObjectContext:self.gameInfoContext];

        if (gameInfo) {
            self.currentInvestingGame = [[InvestingGame alloc] initInvestingGameWithGameInfo:gameInfo withScenario:scenario];
        }
    }
}

- (void)deleteCurrentInvestingGame
{
    [GameInfo removeExistingGameInfoWithScenarioFilename:self.selectedScenarioFilename
                                intoManagedObjectContext:self.currentInvestingGame.gameInfoContext];
    self.currentInvestingGame = nil;
}


#pragma mark - Getters

- (NSManagedObjectContext *)gameInfoContext
{
    if (!_gameInfoContext) {
        _gameInfoContext = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    }
    
    return _gameInfoContext;
}

- (NSMutableDictionary *)successfulQuizzesCount
{
    if (!_successfulQuizzesCount) {
        // Previous user? Load existing info
        
        // New user?...
        _successfulQuizzesCount = [[NSMutableDictionary alloc] init];
    }
    
    return _successfulQuizzesCount;
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
        scenarioPurchaseInfoDemo.numberOfDays = 121;
        scenarioPurchaseInfoDemo.withAdds = NO;
        scenarioPurchaseInfoDemo.price = 0.0; // Free Demo
        scenarioPurchaseInfoDemo.sizeInMegas = 0.5; // PROVISIONAL
        
        // DEFAULT DOW JONES SCENARIO
        ScenarioPurchaseInfo *scenarioPurchaseInfo1 = [[ScenarioPurchaseInfo alloc] init];
        scenarioPurchaseInfo1.name = @"DOW JONES 30";
        scenarioPurchaseInfo1.filename = @"DJI_001A";
        scenarioPurchaseInfo1.descriptionForScenario = @"Dow Jones Industrial Average Companies.";
        scenarioPurchaseInfo1.initialDate = [dateFormatter dateFromString:@"12/20/2010"];
        scenarioPurchaseInfo1.endingDate = [dateFormatter dateFromString:@"12/19/2014"];
        scenarioPurchaseInfo1.numberOfCompanies = 30;
        scenarioPurchaseInfo1.numberOfDays = 1460;
        scenarioPurchaseInfo1.withAdds = NO;
        scenarioPurchaseInfo1.price = 0.99;
        scenarioPurchaseInfo1.sizeInMegas = 1.96;
        
        _availableScenarios = @[scenarioPurchaseInfoDemo, scenarioPurchaseInfo1];
    }
    
    return _availableScenarios;
}

#pragma mark - Setters

- (void)setSelectedScenarioFilename:(NSString *)selectedScenarioFilename
{
    if (![selectedScenarioFilename isEqualToString:_selectedScenarioFilename]) {
        _selectedScenarioFilename = selectedScenarioFilename;
        [self newInvestingGame];
    }
}


@end

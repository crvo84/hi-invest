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
#import "Quiz.h"

@interface UserAccount ()

@property (nonatomic, readwrite) NSInteger userLevel;
@property (copy, nonatomic) NSString *selectedScenearioId;
@property (strong, nonatomic, readwrite) InvestingGame *currentInvestingGame;
@property (strong, nonatomic) NSMutableDictionary *successfulQuizzesCount; // @{ @"QuizType" : @(Current Level) }

@end

// 7 cannot change because it was the inital number of Quiz Type. (to maintain user level continuity)
// Cannot change even in future versions of the application
#define UserAccountSuccessfulQuizzesPerUserLevel 7

@implementation UserAccount

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.userLevel = 0;
        // TODO: Should be loaded from user account
        self.simulatorInitialCash = 1000000.0;
        self.disguiseCompanies = NO;
    }
    
    return self;
}

// Return the user level (0 is the lowest) depending on answered quizzes
- (NSInteger)currentUserLevel;
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
    NSManagedObjectContext *context = [ManagedObjectContextCreator createMainQueueManagedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scenario"];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        
        NSLog(@"Error fetching Scenario from database");
        
    } else if ([matches count] == 0) {
        
        NSLog(@"No Scenario in database");
        
    } else {
        
        Scenario *scenario = [matches firstObject];
        self.currentInvestingGame = [[InvestingGame alloc] initInvestingGameWithInitialCash:self.simulatorInitialCash disguisingRealNamesAndTickers:self.disguiseCompanies scenario:scenario andPortfolioPictures:nil];
        
    }
}

- (void)exitInvestingGame
{
    self.currentInvestingGame = nil;
}


#pragma mark - Getters

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

- (NSString *)selectedScenearioId
{
    return @"scenario_DJI001A";
}






@end

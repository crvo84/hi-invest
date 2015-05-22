//
//  UserAccount.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccount.h"
#import "UserDefaultsKeys.h"
#import "InvestingGame.h"
#import "ManagedObjectContextCreator.h"

@interface UserAccount ()

@property (nonatomic, readwrite) NSInteger userLevel;
@property (strong, nonatomic, readwrite) InvestingGame *currentInvestingGame;
@property (strong, nonatomic) NSMutableDictionary *currentQuizLevels; // @{ @"QuizType" : @(Current Level) }

@end

@implementation UserAccount

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.userLevel = 1;
    }
    
    return self;
}

#pragma mark - Quizzes

- (void)increaseQuizLevelForQuizType:(QuizType)quizType
{
    NSInteger previousQuizLevel = [self currentQuizLevelForQuizType:quizType];
    
    NSString *quizTypeAsStr = [NSString stringWithFormat:@"%ld", (long)quizType];
    
    self.currentQuizLevels[quizTypeAsStr] = @(++previousQuizLevel);
}

// Return the current (Unfinished quiz level) for the given quiz type
// Return 1 f there is no record for the given quiz type
- (NSInteger)currentQuizLevelForQuizType:(QuizType)quizType
{
    NSString *quizTypeAsStr = [NSString stringWithFormat:@"%ld", (long)quizType];
    NSNumber *currentLevelNumber = self.currentQuizLevels[quizTypeAsStr];
    
    if (currentLevelNumber) {
        return [currentLevelNumber integerValue];
    }
    
    return 1;
}

#pragma mark - Getters

- (InvestingGame *)currentInvestingGame
{
    if (!_currentInvestingGame) {
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
            _currentInvestingGame = [[InvestingGame alloc] initInvestingGameWithInitialCash:SettingsDefaultInitialCash scenario:scenario andPortfolioPictures:nil];
            
        }
    }
    
    return _currentInvestingGame;
}

- (NSMutableDictionary *)currentQuizLevels
{
    if (!_currentQuizLevels) {
        // Previous user? Load existing info
        
        // New user?...
        _currentQuizLevels = [[NSMutableDictionary alloc] init];
    }
    
    return _currentQuizLevels;
}












@end

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


@end

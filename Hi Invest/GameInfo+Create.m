//
//  GameInfo+Create.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GameInfo+Create.h"
#import "HistoricalValue.h"
#import "Ticker.h"
#import "Transaction.h"

@implementation GameInfo (Create)

+ (GameInfo *)gameInfoWithScenarioFilename:(NSString *)scenarioFilename
                               initialCash:(double)initialCash
                               currentDate:(NSDate *)currentDate
                       disguisingCompanies:(BOOL)disguiseCompanies
                  intoManagedObjectContext:(NSManagedObjectContext *)context
{
    GameInfo *gameInfo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"scenarioFilename = %@", scenarioFilename];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error trying to fetch GameInfo from database. %@", [error localizedDescription]);
    } else if ([matches count] > 1) {
        NSLog(@"More than one GameInfo Managed Object with same scenarioFilename");
    } else if ([matches count] == 1) {
        gameInfo = [matches firstObject];
    } else {
        
        gameInfo = [NSEntityDescription insertNewObjectForEntityForName:@"GameInfo" inManagedObjectContext:context];
        gameInfo.scenarioFilename = scenarioFilename;
        gameInfo.initialCash = @(initialCash);
        gameInfo.currentDate = currentDate;
        gameInfo.disguiseCompanies = @(disguiseCompanies);
        gameInfo.finished = @(NO);
        
        NSError *saveError;
        if (![context save:&saveError]) {
            NSLog(@"%@", [saveError localizedDescription]);
        }
    }
    
    return gameInfo;
}


+ (void)removeExistingGameInfoWithScenarioFilename:(NSString *)scenarioFilename
                          intoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"scenarioFilename = %@", scenarioFilename];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error trying to fetch GameInfo from database. %@", [error localizedDescription]);
        
    } else if ([matches count] > 1) {
        
        for (GameInfo *gameInfo in matches) {
            // Delete Rule Cascade selected will delete also Transaction, Ticker and HistoricalValue related managed objects
            [context deleteObject:gameInfo];
        }
        
    } else if ([matches count] == 1) {
        GameInfo *gameInfo = [matches firstObject];
        // Delete Rule Cascade selected will delete also Transaction, Ticker and HistoricalValue related managed objects
        [context deleteObject:gameInfo];
    }
    
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"%@", [saveError localizedDescription]);
    }
}

@end

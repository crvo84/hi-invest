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

+ (GameInfo *)gameInfoWithUserId:(NSString *)userId
                scenarioFilename:(NSString *)scenarioFilename
                    scenarioName:(NSString *)scenarioName
                     initialCash:(double)initialCash
                     currentDate:(NSDate *)currentDate
             disguisingCompanies:(BOOL)disguiseCompanies
        intoManagedObjectContext:(NSManagedObjectContext *)context
{
    GameInfo *gameInfo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"(scenarioFilename = %@) AND (userId = %@)", scenarioFilename, userId];
    
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
        gameInfo.userId = userId;
        gameInfo.scenarioFilename = scenarioFilename;
        gameInfo.scenarioName = scenarioName;
        gameInfo.initialCash = @(initialCash);
        gameInfo.currentDate = currentDate;
        gameInfo.disguiseCompanies = @(disguiseCompanies);
        gameInfo.finished = @(NO);
        gameInfo.currentDay = @(1);
        gameInfo.currentReturn = @(0.0);
        
        NSError *saveError;
        if (![context save:&saveError]) {
            NSLog(@"%@", [saveError localizedDescription]);
        }
    }
    
    return gameInfo;
}


// Remove the GameInfo managed object with the given scenario filename, with the given userId.
// If scenarioFilename is given as nil, remove GameInfo managed objects for that userId
// If userId is given as nil, remove all GameInfo managed objects for that scenarioFilename
// If string parameters are given as nil, remove all existing GameInfo managed objects.
+ (void)removeExistingGameInfoWithScenarioFilename:(NSString *)scenarioFilename
                                        withUserId:(NSString *)userId
                          intoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GameInfo"];
    
    if (scenarioFilename && userId) { // All GameInfo with given scenarioFilename and userId
        request.predicate = [NSPredicate predicateWithFormat:@"(scenarioFilename = %@) AND (userId = %@)", scenarioFilename, userId];
        
    } else if (scenarioFilename) { // All GameInfo with a given scenarioFilename
        request.predicate = [NSPredicate predicateWithFormat:@"scenarioFilename = %@", scenarioFilename];
        
    } else if (userId) { // All GameInfo with a given userId
        request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        
    }
    
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

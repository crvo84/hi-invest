//
//  HistoricalValue+Create.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "HistoricalValue+Create.h"

@implementation HistoricalValue (Create)

// Return an HistoricalValue with the given information. If there is already a HistoricalValue with same scenario filename and same (or later) day, do not create one and return nil.
+ (HistoricalValue *)historicalValueWithGameInfo:(GameInfo *)gameInfo
                                  portfolioValue:(double)portfolioValue
                                          andDay:(NSInteger)day
{
    HistoricalValue *historicalValue = nil;
    
    NSManagedObjectContext *context = gameInfo.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HistoricalValue"];
    request.predicate = [NSPredicate predicateWithFormat:@"scenarioFilename = %@", gameInfo.scenarioFilename];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching HistoricalValue managed objects. %@", [error localizedDescription]);
    } else if ([matches count] > 1) {
        HistoricalValue *lastHistoricalValue = [matches lastObject];
        if ([lastHistoricalValue.day integerValue] >= day) {
            return nil;
        }
    }
    
    historicalValue = [NSEntityDescription insertNewObjectForEntityForName:@"HistoricalValue" inManagedObjectContext:context];
    historicalValue.gameInfo = gameInfo;
    historicalValue.portfolioValue = @(portfolioValue);
    historicalValue.day = @(day);
    historicalValue.scenarioFilename = gameInfo.scenarioFilename;
    
//    NSError *saveError;
//    if (![gameInfo.managedObjectContext save:&saveError]) {
//        NSLog(@"%@", [saveError localizedDescription]);
//    }
    
    return historicalValue;
}

// Return an array of HistoricalValue managed objects in ascending order sorted by day.
+ (NSArray *)historicalValuesFromGameInfo:(GameInfo *)gameInfo
{

    NSArray *historicalValues = [gameInfo.historicalValues allObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day"
                                                                   ascending:YES];
    
    return [historicalValues sortedArrayUsingDescriptors:@[sortDescriptor]];
}

@end

//
//  Ticker+Create.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Ticker+Create.h"

@implementation Ticker (Create)

+ (Ticker *)tickerWithGameInfo:(GameInfo *)gameInfo
                 realTickerStr:(NSString *)realTickerStr
                      UITicker:(NSString *)UITicker
                        UIName:(NSString *)UIName
             UIPriceMultiplier:(double)UIPriceMultiplier
{
    Ticker *ticker = nil;
    
    NSManagedObjectContext *context = gameInfo.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ticker"];
    request.predicate = [NSPredicate predicateWithFormat:@"(scenarioFilename = %@) AND (realTicker = %@)", gameInfo.scenarioFilename, realTickerStr];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching Ticker managed object. %@", [error localizedDescription]);
    } else if ([matches count] == 0) {
        ticker = [NSEntityDescription insertNewObjectForEntityForName:@"Ticker" inManagedObjectContext:context];
        ticker.gameInfo = gameInfo;
        ticker.scenarioFilename = gameInfo.scenarioFilename;
        ticker.realTicker = realTickerStr;
        ticker.uiTicker = UITicker;
        ticker.uiName = UIName;
        ticker.uiPriceMultiplier = @(UIPriceMultiplier);
        
        NSError *saveError;
        if (![gameInfo.managedObjectContext save:&saveError]) {
            NSLog(@"%@", [saveError localizedDescription]);
        }
    }
    
    return ticker;
}

+ (NSArray *)tickersFromGameInfo:(GameInfo *)gameInfo
{
    return [gameInfo.tickers allObjects];
}

@end

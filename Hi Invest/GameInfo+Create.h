//
//  GameInfo+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GameInfo.h"

@interface GameInfo (Create)

// Create and return a new GameInfo Managed Object. If a GameInfo with same scenario Filename is already in database, return nil.
+ (GameInfo *)gameInfoWithScenarioFilename:(NSString *)scenarioFilename
                               initialCash:(double)initialCash
                               currentDate:(NSDate *)currentDate
                       disguisingCompanies:(BOOL)disguiseCompanies
                  intoManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)removeExistingGameInfoWithScenarioFilename:(NSString *)scenarioFilename
                          intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

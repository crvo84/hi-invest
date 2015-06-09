//
//  GameInfo+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GameInfo.h"

@interface GameInfo (Create)

+ (GameInfo *)gameInfoWithUserId:(NSString *)userId
                scenarioFilename:(NSString *)scenarioFilename
                    scenarioName:(NSString *)scenarioName
                     initialCash:(double)initialCash
                     currentDate:(NSDate *)currentDate
             disguisingCompanies:(BOOL)disguiseCompanies
        intoManagedObjectContext:(NSManagedObjectContext *)context;

// Remove the GameInfo managed object with the given scenario filename, with the given userId.
// If scenarioFilename is given as nil, remove GameInfo managed objects for that userId
// If userId is given as nil, remove all GameInfo managed objects for that scenarioFilename
// If string parameters are given as nil, remove all existing GameInfo managed objects.
+ (void)removeExistingGameInfoWithScenarioFilename:(NSString *)scenarioFilename
                                        withUserId:(NSString *)userId
                          intoManagedObjectContext:(NSManagedObjectContext *)context;

@end

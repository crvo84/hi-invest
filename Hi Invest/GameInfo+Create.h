//
//  GameInfo+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GameInfo.h"

@interface GameInfo (Create)

// Return a GameInfo managed object with the given userId and scenarioFilename. Create it if necessary.
+ (GameInfo *)gameInfoWithUserId:(NSString *)userId
                scenarioFilename:(NSString *)scenarioFilename
                    scenarioName:(NSString *)scenarioName
                     initialCash:(double)initialCash
                     currentDate:(NSDate *)currentDate
             disguisingCompanies:(BOOL)disguiseCompanies
        intoManagedObjectContext:(NSManagedObjectContext *)context;

// Return an existing GameInfo with the given scenarioFilename and userId. nil if it does not exist
+ (GameInfo *)existingGameInfoWithScenarioFilename:(NSString *)scenarioFilename withUserId:(NSString *)userId intoManagedObjectContext:(NSManagedObjectContext *)context;

// Remove the GameInfo managed object with the given scenario filename, with the given userId.
// If scenarioFilename is given as nil, remove GameInfo managed objects for that userId
// If userId is given as nil, remove all GameInfo managed objects for that scenarioFilename
// If string parameters are given as nil, remove all existing GameInfo managed objects.
+ (void)removeExistingGameInfoWithScenarioFilename:(NSString *)scenarioFilename
                                        withUserId:(NSString *)userId
                          intoManagedObjectContext:(NSManagedObjectContext *)context;

// Remove all existing GameInfo managed objects which userId is not equal to the given string.
// If userId is nil, then remove all existing GameInfo managed objects
+ (void)removeAllExistingGameInfoExceptFromUserId:(NSString *)userId intoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)allExistingGameInfoFromManagedObjectContext:(NSManagedObjectContext *)context;

@end

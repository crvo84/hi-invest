//
//  ManagedObjectContextCreator.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectContextCreator : NSObject

+ (NSManagedObjectContext *)createMainQueueManagedObjectContextWithScenarioFilename:(NSString *)scenarioFilename;

+ (BOOL)scenarioDatabaseExistsAtApplicationDocumentsDirectoryWithFilename:(NSString *)scenarioFilename;

+ (BOOL)scenarioDatabaseExistsAtBundleWithFilename:(NSString *)scenarioFilename;

@end

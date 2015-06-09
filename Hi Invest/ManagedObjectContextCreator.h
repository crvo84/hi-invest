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

// Database File Extensions
#define DataModelFileExtension @"momd"
#define DatabaseFileExtension @"sqlite"

#pragma mark - Simulator Scenarios

// Scenario Database Filenames
#define ScenarioDataModelFilename @"FinancialDataModel"

+ (NSManagedObjectContext *)createMainQueueManagedObjectContextWithScenarioFilename:(NSString *)scenarioFilename;

+ (BOOL)scenarioDatabaseExistsAtBundleOrDocumentsDirectoryWithFilename:(NSString *)scenarioFilename;


#pragma mark - Investing Game Activity

// InvestingGameActivity Database Filenames
#define InvestingGameActivityDatabaseFilename @"InvestingGameActivity"
#define InvestingGameActivityDataModelFilename @"InvestingGameActivityDataModel"

+ (NSManagedObjectContext *)createMainQueueGameActivityManagedObjectContext;

+ (BOOL)investingGameActivityDatabaseExistsAtBundleOrDocumentDirectory;

+ (double)sizeInMegabytesOfDatabaseWithFilename:(NSString *)databaseFilename;


#pragma mark - File managing

+ (BOOL)databaseExistsAtDocumentsDirectoryWithFilename:(NSString *)databaseFilename;

+ (BOOL)databaseExistsAtBundleWithFilename:(NSString *)databaseFilename;

@end

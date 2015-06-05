//
//  ManagedObjectContextCreator.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ManagedObjectContextCreator.h"

@implementation ManagedObjectContextCreator


#pragma mark - Simulator Scenarios

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)createMainQueueManagedObjectContextWithScenarioFilename:(NSString *)scenarioFilename
{
    NSManagedObjectContext *managedObjectContext = nil;
    
    // If the scenario database exists in the application documents directory access it from there
    // If not, access it from the bundle
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinatorFromApplicationDocumentsDirectoryOrBundleWithScenarioFilename:scenarioFilename];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}


/* USE THIS METHOD TO ACCESS THE DATABASE FILE FROM THE DOCUMENTS DIRECTORY, IF DOES NOT EXISTS THERE, ACCESS IT FROM THE BUNDLE */
// Returns the persistent store coordinator for the application.
// No changes can be done to the database with a persistent store coordinator created with this method.
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorFromApplicationDocumentsDirectoryOrBundleWithScenarioFilename:(NSString *)scenarioFilename
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModelWithDataModelFilename:ScenarioDataModelFilename];
    
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", scenarioFilename, DatabaseFileExtension];
    
    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // If there is no such file at the documents directory
        // Get the url for the default database in the main bundle
        storeURL = [[NSBundle mainBundle] URLForResource:scenarioFilename withExtension:DatabaseFileExtension];
    }
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    // options Dictionary added to avoid .wal and .shm files. Also to set read only core database
    NSDictionary *options = @{NSReadOnlyPersistentStoreOption : @YES, NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}};
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return persistentStoreCoordinator;
}


+ (BOOL)scenarioDatabaseExistsAtBundleOrDocumentsDirectoryWithFilename:(NSString *)scenarioFilename
{
    return [self databaseExistsAtBundleWithFilename:scenarioFilename] || [self databaseExistsAtDocumentsDirectoryWithFilename:scenarioFilename];
}


#pragma mark - Investing Game Activity

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)createMainQueueGameActivityManagedObjectContext
{
    NSManagedObjectContext *managedObjectContext = nil;
    
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinatorWithInvestingGameActivityFilename:InvestingGameActivityDatabaseFilename withDataModelFilename:InvestingGameActivityDataModelFilename];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorWithInvestingGameActivityFilename:(NSString *)databaseFilename withDataModelFilename:(NSString *)dataModelFilename
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModelWithDataModelFilename:dataModelFilename];
    
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", databaseFilename, DatabaseFileExtension];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}


// Method to delete database

+ (BOOL)investingGameActivityDatabaseExistsAtBundleOrDocumentDirectory
{
    return [self databaseExistsAtBundleWithFilename:InvestingGameActivityDatabaseFilename] || [self databaseExistsAtDocumentsDirectoryWithFilename:InvestingGameActivityDatabaseFilename];
}


#pragma mark - General

// Returns the URL to the application's Documents directory
+ (NSURL *)applicationDocumentsDirectory
{
//    NSURL *documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//    NSLog(@"%@", documentsDirectoryURL);
//    return documentsDirectoryURL;
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)createManagedObjectModelWithDataModelFilename:(NSString *)dataModelFilename
{
    NSManagedObjectModel *managedObjectModel = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:dataModelFilename withExtension:DataModelFileExtension];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

+ (BOOL)databaseExistsAtDocumentsDirectoryWithFilename:(NSString *)databaseFilename
{
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", databaseFilename, DatabaseFileExtension];
    
    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
}

+ (BOOL)databaseExistsAtBundleWithFilename:(NSString *)databaseFilename
{
    NSURL *fileAtBundleURL = [[NSBundle mainBundle] URLForResource:databaseFilename withExtension:DatabaseFileExtension];
    
    if (fileAtBundleURL) {
        return YES;
    }
    
    return NO;
}

// Return a double with the number of Megabytes of the scenario with the given filename
// Return NSNotFound if the file of the given filename does not exist.
+ (double)sizeInMegabytesOfDatabaseWithFilename:(NSString *)databaseFilename
{
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", databaseFilename, DatabaseFileExtension];
    
    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // If there is no such file at the documents directory
        // Get the url for the default database in the main bundle
        storeURL = [[NSBundle mainBundle] URLForResource:databaseFilename withExtension:DatabaseFileExtension];
    }
    
    if (!storeURL) {
        return NSNotFound;
    }
    
    NSError *attributesError = nil;
    NSDictionary *scenarioAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[storeURL path] error:&attributesError];
    
    return  [[scenarioAttributes objectForKey:NSFileSize] longLongValue] / 1000000.0;
}





















#pragma mark - Former Methods

/*   ACCESS THE DATABASE DIRECTLY FROM THE BUNDLE  */
///*
// USE THIS METHOD TO ACCESS THE DATABASE FILE DIRECTLY FROM THE BUNDLE
// (This approach can only be used when the app is making NO changes to the database.)
// */
//// Returns the persistent store coordinator for the application.
//// If the coordinator doesn't already exist, it is created and the application's store added to it.
//+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorFromBundleWithDatabaseFilename:(NSString *)databaseFilename
//{
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
//    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModel];
//    
//    NSURL *fileAtBundleURL = [[NSBundle mainBundle] URLForResource:@"scenario_DJI001A" withExtension:ScenarioDatabaseExtension];
//    
//    NSError *error = nil;
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
//    
//    // options Dictionary added to avoid .wal and .shm files. Also to set read only core database
//    NSDictionary *options = @{NSReadOnlyPersistentStoreOption : @YES, NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}};
//    
//    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileAtBundleURL options:options error:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    }
//    
//    return persistentStoreCoordinator;
//}


//----------------//


/*   COPIES THE DATABASE FROM THE BUNDLE TO THE APPLICATION DOCUMENTS DIRECTORY AND ACCESS IT FROM THERE  */
///*
// USE THIS METHOD TO COPY THE DATABASE FILE IN THE APP BUNDLE TO THE APP DIRECTORY AND ACCESS IT FROM THERE
// (If the app is making changes to the database, this approach must be chosen, because no changes can be made to files in the bundle.)
// */
//// Returns the persistent store coordinator for the application.
//// If the coordinator doesn't already exist, it is created and the application's store added to it.
//+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorWithScenarioFilename:(NSString *)scenarioFilename
//{
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
//    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModel];
//    
//    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", scenarioFilename, ScenarioDatabaseExtension];
//    
//    // Gets url for the database in the documents directory
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:[storeURL path]]) {
//        // If there is no such file at the documents directory
//        // Get the url for the default database in the main bundle
//        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:scenarioFilename withExtension:ScenarioDatabaseExtension];
//        if (defaultStoreURL) {
//            // if there is a database at the main bundle, copy the file to the documents directory
//            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
//        }
//    }
//    
//    NSError *error = nil;
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
//    
//    // options Dictionary added to avoid .wal and .shm files. Also to set read only core database
//    NSDictionary *options = @{NSReadOnlyPersistentStoreOption : @YES, NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}};
//    
//    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
//         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    }
//    
//    return persistentStoreCoordinator;
//}


@end

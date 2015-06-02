//
//  ManagedObjectContextCreator.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ManagedObjectContextCreator.h"

// Database filename
#define ScenarioDataModelFilename @"FinancialDataModel"
#define ScenarioDataModelFileExtension @"momd"
#define ScenarioDatabaseExtension @"sqlite"


@implementation ManagedObjectContextCreator


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
+ (NSManagedObjectContext *)createMainQueueManagedObjectContextWithScenarioFilename:(NSString *)scenarioFilename
{
    NSManagedObjectContext *managedObjectContext = nil;
    
    // If the scenario database exists in the application documents directory access it from there
    // If not, access it from the bundle
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinatorFromApplicationDocumentsDirectoryOrBundleWithDatabaseFilename:scenarioFilename];
    
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
+ (NSManagedObjectModel *)createManagedObjectModel
{
    NSManagedObjectModel *managedObjectModel = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ScenarioDataModelFilename withExtension:ScenarioDataModelFileExtension];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}


/* USE THIS METHOD TO ACCESS THE DATABASE FILE FROM THE DOCUMENTS DIRECTORY, IF DOES NOT EXISTS THERE, ACCESS IT FROM THE BUNDLE */
// Returns the persistent store coordinator for the application.
// No changes can be done to the database with a persistent store coordinator created with this method.
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorFromApplicationDocumentsDirectoryOrBundleWithDatabaseFilename:(NSString *)databaseFilename
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModel];
    
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", databaseFilename, ScenarioDatabaseExtension];
    
    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // If there is no such file at the documents directory
        // Get the url for the default database in the main bundle
       storeURL = [[NSBundle mainBundle] URLForResource:databaseFilename withExtension:ScenarioDatabaseExtension];
    }

    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    // options Dictionary added to avoid .wal and .shm files. Also to set read only core database
    NSDictionary *options = @{NSReadOnlyPersistentStoreOption : @YES, NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}};
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return persistentStoreCoordinator;
}

+ (BOOL)scenarioDatabaseExistsAtApplicationDocumentsDirectoryWithFilename:(NSString *)scenarioFilename
{
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", scenarioFilename, ScenarioDatabaseExtension];

    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];


    return [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
}

+ (BOOL)scenarioDatabaseExistsAtBundleWithFilename:(NSString *)scenarioFilename
{
    NSURL *fileAtBundleURL = [[NSBundle mainBundle] URLForResource:scenarioFilename withExtension:ScenarioDatabaseExtension];
    
    if (fileAtBundleURL) {
        return YES;
    }
    
    return NO;
}

// Return a double with the number of Megabytes of the scenario with the given filename
// Return NSNotFound if the file of the given filename does not exist.
+ (double)sizeInMegabytesOfScenarioWithFilename:(NSString *)scenarioFilename
{
    NSString *databasePathComponent = [NSString stringWithFormat:@"%@.%@", scenarioFilename, ScenarioDatabaseExtension];
    
    // Gets url for the database in the documents directory
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:databasePathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // If there is no such file at the documents directory
        // Get the url for the default database in the main bundle
        storeURL = [[NSBundle mainBundle] URLForResource:scenarioFilename withExtension:ScenarioDatabaseExtension];
    }
    
    if (!storeURL) {
        return NSNotFound;
    }
    
    NSError *attributesError = nil;
    NSDictionary *scenarioAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[storeURL path] error:&attributesError];
    
    return  [[scenarioAttributes objectForKey:NSFileSize] longLongValue] / 1000000.0;
}


// Returns the URL to the application's Documents directory
+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
























// ORIGINAL METHODS

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

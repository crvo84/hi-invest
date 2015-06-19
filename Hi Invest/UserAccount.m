//
//  UserAccount.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccount.h"
#import "InvestingGame.h"
#import "ManagedObjectContextCreator.h"
#import "ScenarioPurchaseInfo.h"
#import "Quiz.h"
#import "Scenario.h"
#import "GameInfo+Create.h"
#import "ParseUserKeys.h"
#import "UserDefaultsKeys.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface UserAccount ()

@property (strong, nonatomic, readwrite) InvestingGame *currentInvestingGame;
@property (strong, nonatomic, readwrite) NSArray *availableScenarios; // of ScenarioPurchaseInfo
// PFUser info:
@property (strong, nonatomic, readwrite) NSMutableDictionary *successfulQuizzesCount; // @{ @"QuizType" : @(Current Level) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *finishedScenariosCount; // @{ scenarioFilename : @(finished) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *averageReturns; // @{ scenarioFilename : @(averageReturn) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *lowestReturns; // @{ scenarioFilename : @(lowestReturn) }
@property (strong, nonatomic, readwrite) NSMutableDictionary *highestReturns; // @{ scenarioFilename : @(highestReturn) }

@end


@implementation UserAccount

// 7 cannot change because it was the inital number of Quiz Type. (to maintain user level continuity)
// Cannot change even in future versions of the application
#define UserAccountSuccessfulQuizzesPerUserLevel 7

#pragma mark - User Info

// Return the current user objectId, if the user is not saved on the cloud, objectId will be nil, so return @"Guest"
- (NSString *)userId
{
    NSString *userId = [PFUser currentUser].objectId;
    
    return userId ? userId : ParseUserGuestUserId;
}


- (NSString *)userName
{
    NSString *facebookFirstName = [PFUser currentUser][ParseUserFirstName];
    
    return facebookFirstName ? facebookFirstName : ParseUserGuestUserId;
}

// Return the user level (0 is the lowest) depending on answered quizzes
- (NSInteger)userLevel;
{
    return [self totalSuccessfulQuizzesCount] / UserAccountSuccessfulQuizzesPerUserLevel;
}

+ (NSInteger)userLevelFromSuccessfulQuizzesCount:(NSDictionary *)successfulQuizzesCount
{
    return [self totalSuccessfulQuizzesCountFromSuccessfulQuizzesCount:successfulQuizzesCount] / UserAccountSuccessfulQuizzesPerUserLevel;
}

- (void)updateUserSimulatorInfoWithFinishedGameInfo:(GameInfo *)gameInfo
{
    if (![gameInfo.disguiseCompanies boolValue]) {
        // ONLY SCORES FROM GAMES WITH DISGUISED INFO ARE SAVED
        return;
    }
    
    NSString *filename = gameInfo.scenarioFilename;
    
    double newReturn = [gameInfo.currentReturn doubleValue];
    
    
      // ------------------------ //
     // FINISHED SCENARIOS COUNT //
    // -------------------------//
    
    NSMutableDictionary *allFinishedCount = self.finishedScenariosCount;
    NSNumber *previousFinishedCountNumber = allFinishedCount[filename];
    NSNumber *newFinishedCountNumber;
    
    
    if (previousFinishedCountNumber) {
        newFinishedCountNumber = @([previousFinishedCountNumber integerValue] + 1);
        
    } else {
        newFinishedCountNumber = @(1);
    }
    allFinishedCount[filename] = newFinishedCountNumber;
    
    self.finishedScenariosCount = allFinishedCount;
    
    
      // --------------- //
     // AVERAGE RETURNS //
    // --------------- //
    
    NSMutableDictionary *allAverageReturns = self.averageReturns;
    NSNumber *previousAverageReturnNumber = allAverageReturns[filename];
    NSNumber *newAverageReturnNumber;
    
    if (previousAverageReturnNumber) {
        
        double previousAverageReturn = [previousAverageReturnNumber doubleValue];
        NSInteger newGamesFinished = [allFinishedCount[filename] integerValue];
        NSInteger previousGamesFinished = newGamesFinished - 1; // newGamesFinished includes current finished game
        newAverageReturnNumber = @((previousAverageReturn * previousGamesFinished + newReturn) / newGamesFinished);
        
    } else {
        newAverageReturnNumber = @(newReturn);
    }
    allAverageReturns[filename] = newAverageReturnNumber;
    
    self.averageReturns = allAverageReturns;
    
    
      // --------------- //
     // LOWEST RETURNS  //
    // --------------- //
    
    NSMutableDictionary *allLowestReturns = self.lowestReturns;
    NSNumber *previousLowestReturnNumber = allLowestReturns[filename];
    NSNumber *newLowestReturnNumber;
    
    if (previousLowestReturnNumber) {
        
        double previousLowestReturn = [previousLowestReturnNumber doubleValue];
        newLowestReturnNumber = newReturn < previousLowestReturn ? @(newReturn) : previousLowestReturnNumber;
        
    } else {
        newLowestReturnNumber = @(newReturn);
    }
    allLowestReturns[filename] = newLowestReturnNumber;
    
    self.lowestReturns = allLowestReturns;
    
    
      // --------------- //
     // HIGHEST RETURNS //
    // --------------- //
    
    NSMutableDictionary *allHighestReturns = self.highestReturns;
    NSNumber *previousHighestReturnNumber = allHighestReturns[filename];
    NSNumber *newHighestReturnNumber;
    
    if (previousHighestReturnNumber) {
        
        double previousHighestReturn = [previousHighestReturnNumber doubleValue];
        newHighestReturnNumber = newReturn > previousHighestReturn ? @(newReturn) : previousHighestReturnNumber;
        
    } else {
        newHighestReturnNumber = @(newReturn);
    }
    allHighestReturns[filename] = newHighestReturnNumber;
    
    self.highestReturns = allHighestReturns;
    
    [self saveParseUserInfo];
}

- (void)saveParseUserInfo
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    /* Only if the ParseUser has already been saved in the cloud and got an ObjectId.
       and only if the user info has been copied from NSUserDefaults to the Parse User, 
       which happens only in SignupViewController at login, or in SettingsViewController at facebook linking
     */
    if (user.objectId && infoSavedInParseUser) {
        
        [user saveEventually];
    }
}

- (void)migrateUserInfoToParseUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![[defaults objectForKey:UserDefaultsInfoSavedInParseUser] boolValue]) {
        
        [self copyUserDefaultsToParseUser];
        [self deleteUserDefaultsAlreadyInParseUser];
        [self updateGuestSavedGameInfoManagedObjectsWithNewParseObjectId];
        
        [defaults setObject:@(YES) forKey:UserDefaultsInfoSavedInParseUser];
    }
}

// Copies the guest user simulator results info to the new parse user
- (void)copyUserDefaultsToParseUser
{
    NSString *objectId = [PFUser currentUser].objectId;
    
    if (objectId) { // If objectId is not nil, then PFUser is saved in the cloud

        // Getters: (objectId && ParseUserInfoSavedInParseUser) ? get from PFUser : get from NSUserDefaults
        // Setters: (objectId) ? set to PFUser : set to NSUserDefaults
        // Get NSMutableDictionary. Must Set NSMutableDictionary
        
        self.successfulQuizzesCount = [self.successfulQuizzesCount copy];
        self.finishedScenariosCount = [self.finishedScenariosCount copy];
        self.averageReturns = [self.averageReturns copy];
        self.lowestReturns = [self.lowestReturns copy];
        self.highestReturns = [self.highestReturns copy];
    }
}

- (void)deleteUserDefaultsAlreadyInParseUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:ParseUserSuccessfulQuizzesCount];
    [defaults removeObjectForKey:ParseUserFinishedScenariosCount];
    [defaults removeObjectForKey:ParseUserAverageReturns];
    [defaults removeObjectForKey:ParseUserLowestReturns];
    [defaults removeObjectForKey:ParseUserHighestReturns];
}

// Update the GameInfo saved games userId from Guest, to new parse user objectId
- (void)updateGuestSavedGameInfoManagedObjectsWithNewParseObjectId
{
    NSManagedObjectContext *context = [ManagedObjectContextCreator createPrivateQueueGameActivityManagedObjectContext];
    
    NSArray *userGameInfos = [GameInfo existingGameInfoManagedObjectsWithUserId:ParseUserGuestUserId fromManagedObjectContext:context];
    
    NSString *newUserObjectId = [PFUser currentUser].objectId;
    
    
    if (newUserObjectId) {
        for (GameInfo *gameInfo in userGameInfos) {
            gameInfo.userId = newUserObjectId;
        }
    }
    
    NSError *saveError;
    if (![context save:&saveError]) {
        NSLog(@"%@", [saveError localizedDescription]);
    }
}

- (void)deleteAllUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:UserDefaultsProfilePictureKey];
    [defaults removeObjectForKey:UserDefaultsSelectedScenarioFilenameKey];
    [defaults removeObjectForKey:UserDefaultsSimulatorDisguiseCompaniesKey];
    [defaults removeObjectForKey:UserDefaultsSimulatorInitialCashKey];
    [defaults removeObjectForKey:UserDefaultsGuestAutomaticLogin];
    [defaults removeObjectForKey:UserDefaultsInfoSavedInParseUser];
    [defaults removeObjectForKey:UserDefaultsFriendsFacebookIds];
    
}

- (void)deleteAllGameInfoManagedObjects
{
    [GameInfo removeExistingGameInfoWithScenarioFilename:nil withUserId:nil intoManagedObjectContext:self.gameInfoContext];
}


#pragma mark - Quizzes

// Return the quiz progress [0,1) to get to the next user level.
- (double)progressForNextUserLevel
{
    return ([self totalSuccessfulQuizzesCount] % UserAccountSuccessfulQuizzesPerUserLevel) / (double)UserAccountSuccessfulQuizzesPerUserLevel;
}

- (NSInteger)totalSuccessfulQuizzesCount
{
    NSInteger totalSuccessfulQuizzesCount = 0;
    
    NSDictionary *successfulQuizzesCount = self.successfulQuizzesCount;
    
    for (NSString *key in successfulQuizzesCount) {
        
        NSNumber *quizCount = successfulQuizzesCount[key];
        totalSuccessfulQuizzesCount += [quizCount integerValue];
    }

    return totalSuccessfulQuizzesCount;
}

+ (NSInteger)totalSuccessfulQuizzesCountFromSuccessfulQuizzesCount:(NSDictionary *)successfulQuizzesCount
{
    NSInteger totalSuccessfulQuizzesCount = 0;
    
    for (NSString *key in successfulQuizzesCount) {
        
        NSNumber *quizCount = successfulQuizzesCount[key];
        totalSuccessfulQuizzesCount += [quizCount integerValue];
    }
    
    return totalSuccessfulQuizzesCount;
    
}

- (void)increaseSuccessfulQuizzesForQuizType:(QuizType)quizType
{
    NSNumber *newSuccessfulQuizzesNumber = @([self successfulQuizzesForQuizType:quizType] + 1);
    
    NSMutableDictionary *successfullQuizzesCount = self.successfulQuizzesCount;
    
    successfullQuizzesCount[[self stringKeyForQuizType:quizType]] = newSuccessfulQuizzesNumber;
    
    self.successfulQuizzesCount = successfullQuizzesCount;
    
    [self saveParseUserInfo];
}

// Return the current number of successful quizzes for the given quiz type
// Return 0 (initial level) if there is no record for the given quiz type
- (NSInteger)successfulQuizzesForQuizType:(QuizType)quizType
{
    NSNumber *currentSuccessfulQuizzesNumber = self.successfulQuizzesCount[[self stringKeyForQuizType:quizType]];
    
    if (currentSuccessfulQuizzesNumber) {
        return [currentSuccessfulQuizzesNumber integerValue];
    }
    
    return 0;
}

- (NSString *)stringKeyForQuizType:(QuizType)quizType
{
    return [NSString stringWithFormat:@"%ld", (long)quizType];
}

#pragma mark - Investing Games

- (void)newInvestingGame
{
    [self loadInvestingGameWithGameInfo:nil];
}

// Load an investing game. If given GameInfo managed object is nil, then create a completely new GameInfo.
- (void)loadInvestingGameWithGameInfo:(GameInfo *)gameInfo
{
    NSString *scenarioFilename = gameInfo ? gameInfo.scenarioFilename : self.selectedScenarioFilename;
    
    NSManagedObjectContext *scenarioContext = [ManagedObjectContextCreator createMainQueueManagedObjectContextWithScenarioFilename:scenarioFilename];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Scenario"];
    NSError *error;
    NSArray *matches = [scenarioContext executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count] > 1) {
        
        NSLog(@"Error fetching Scenario from database");
        
    } else if ([matches count] == 0) {
        
        NSLog(@"No Scenario in database");
        
    } else {
        
        Scenario *scenario = [matches firstObject];
        
        if (!gameInfo) {
            
            gameInfo = [GameInfo gameInfoWithUserId:[self userId] scenarioFilename:scenarioFilename scenarioName:scenario.name initialCash:self.simulatorInitialCash currentDate:scenario.initialScenarioDate disguisingCompanies:self.disguiseCompanies intoManagedObjectContext:self.gameInfoContext];
        }
        
        if (gameInfo) {
            self.currentInvestingGame = [[InvestingGame alloc] initInvestingGameWithGameInfo:gameInfo withScenario:scenario];
        }
    }
}


// Set the current investing game to nil
- (void)exitCurrentInvestingGame
{
    self.currentInvestingGame = nil;
}

// Remove current investing game, if there is one.
- (void)deleteCurrentInvestingGame
{
    [GameInfo removeExistingGameInfoWithScenarioFilename:self.selectedScenarioFilename withUserId:[self userId] intoManagedObjectContext:self.currentInvestingGame.gameInfoContext];
    
    [self exitCurrentInvestingGame];
}

#pragma mark - Getters

- (NSString *)selectedScenarioFilename //No guardar en parse user
{
    NSString *selectedFilename = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSelectedScenarioFilenameKey];
    
    return selectedFilename ? selectedFilename : @"DEMO_001A";
}

- (double)simulatorInitialCash // No guardar en parse user
{
    NSNumber *initialCashNumber = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSimulatorInitialCashKey];
    
    return initialCashNumber ? [initialCashNumber doubleValue] : 1000000.0;
}

- (BOOL)disguiseCompanies // No guardar en parse user
{
    NSNumber *disguiseCompaniesNumber = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSimulatorDisguiseCompaniesKey];
    
    return disguiseCompaniesNumber ? [disguiseCompaniesNumber boolValue] : YES;
}

- (NSMutableDictionary *)successfulQuizzesCount
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    NSDictionary *succesfulQuizzesCount;
    
    if (user.objectId && infoSavedInParseUser) {
        
        succesfulQuizzesCount = user[ParseUserSuccessfulQuizzesCount];
        
    } else {
        
        succesfulQuizzesCount = [[NSUserDefaults standardUserDefaults] objectForKey:ParseUserSuccessfulQuizzesCount];
    }
    
    return succesfulQuizzesCount ? [succesfulQuizzesCount mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)finishedScenariosCount
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    NSDictionary *finishedScenariosCount;
    
    if (user.objectId && infoSavedInParseUser) {
        
        finishedScenariosCount = user[ParseUserFinishedScenariosCount];
        
    } else {
        
        finishedScenariosCount = [[NSUserDefaults standardUserDefaults] objectForKey:ParseUserFinishedScenariosCount];
    }
    
    return finishedScenariosCount ? [finishedScenariosCount mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)averageReturns
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    NSDictionary *averageReturns;
    
    if (user.objectId && infoSavedInParseUser) {
        
        averageReturns = user[ParseUserAverageReturns];
        
    } else {
        
        averageReturns = [[NSUserDefaults standardUserDefaults] objectForKey:ParseUserAverageReturns];
    }
    
    return averageReturns ? [averageReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)lowestReturns
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    NSDictionary *lowestReturns;
    
    if (user.objectId && infoSavedInParseUser) {
        
       lowestReturns = user[ParseUserLowestReturns];
        
    } else {
        
        lowestReturns = [[NSUserDefaults standardUserDefaults] objectForKey:ParseUserLowestReturns];
    }
    
    return lowestReturns ? [lowestReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}

- (NSMutableDictionary *)highestReturns
{
    PFUser *user = [PFUser currentUser];
    
    BOOL infoSavedInParseUser = [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsInfoSavedInParseUser] boolValue];
    
    NSDictionary *highestReturns;
    
    if (user.objectId && infoSavedInParseUser) {
        
        highestReturns = user[ParseUserHighestReturns];
        
    } else {
        
        highestReturns = [[NSUserDefaults standardUserDefaults] objectForKey:ParseUserHighestReturns];
    }
    
    return highestReturns ? [highestReturns mutableCopy] : [[NSMutableDictionary alloc] init];
}


- (NSManagedObjectContext *)gameInfoContext
{
    if (!_gameInfoContext) {
        _gameInfoContext = [ManagedObjectContextCreator createMainQueueGameActivityManagedObjectContext];
    }
    
    return _gameInfoContext;
}

- (NSLocale *)localeDefault
{
    if (!_localeDefault) {
        _localeDefault = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    }
    
    return _localeDefault;
}

- (NSArray *)availableScenarios
{
    // TODO: implemente in app purchases system here
    
    if (!_availableScenarios) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        // DEMO SCENARIO
        ScenarioPurchaseInfo *scenarioPurchaseInfoDemo = [[ScenarioPurchaseInfo alloc] init];
        scenarioPurchaseInfoDemo.name = @"DEMO";
        scenarioPurchaseInfoDemo.filename = @"DEMO_001A";
        scenarioPurchaseInfoDemo.descriptionForScenario = @"Scenario Demo";
        scenarioPurchaseInfoDemo.initialDate = [dateFormatter dateFromString:@"8/20/2014"];
        scenarioPurchaseInfoDemo.endingDate = [dateFormatter dateFromString:@"12/19/2014"];
        scenarioPurchaseInfoDemo.numberOfCompanies = 5;
        scenarioPurchaseInfoDemo.numberOfDays = 122;
        scenarioPurchaseInfoDemo.withAdds = NO;
        scenarioPurchaseInfoDemo.price = 0.0; // Free Demo
        scenarioPurchaseInfoDemo.sizeInMegas = [ManagedObjectContextCreator sizeInMegabytesOfDatabaseWithFilename:@"DEMO_001A"];
        
        // DEFAULT DOW JONES SCENARIO
        ScenarioPurchaseInfo *scenarioPurchaseInfo1 = [[ScenarioPurchaseInfo alloc] init];
        scenarioPurchaseInfo1.name = @"DOW JONES 30";
        scenarioPurchaseInfo1.filename = @"DJI_001A";
        scenarioPurchaseInfo1.descriptionForScenario = @"Dow Jones Industrial Average Companies.";
        scenarioPurchaseInfo1.initialDate = [dateFormatter dateFromString:@"12/20/2010"];
        scenarioPurchaseInfo1.endingDate = [dateFormatter dateFromString:@"12/19/2014"];
        scenarioPurchaseInfo1.numberOfCompanies = 30;
        scenarioPurchaseInfo1.numberOfDays = 1461;
        scenarioPurchaseInfo1.withAdds = NO;
        scenarioPurchaseInfo1.price = 0.99;
        scenarioPurchaseInfo1.sizeInMegas = [ManagedObjectContextCreator sizeInMegabytesOfDatabaseWithFilename:@"DJI_001A"];
        
        _availableScenarios = @[scenarioPurchaseInfoDemo, scenarioPurchaseInfo1];
    }
    
    return _availableScenarios;
}

#pragma mark - Setters

- (void)setSelectedScenarioFilename:(NSString *)selectedScenarioFilename
{
    [[NSUserDefaults standardUserDefaults] setObject:selectedScenarioFilename forKey:UserDefaultsSelectedScenarioFilenameKey];
}

- (void)setSimulatorInitialCash:(double)simulatorInitialCash
{
    [[NSUserDefaults standardUserDefaults] setObject:@(simulatorInitialCash) forKey:UserDefaultsSimulatorInitialCashKey];
}

- (void)setDisguiseCompanies:(BOOL)disguiseCompanies
{
    [[NSUserDefaults standardUserDefaults] setObject:@(disguiseCompanies) forKey:UserDefaultsSimulatorDisguiseCompaniesKey];
}

- (void)setSuccessfulQuizzesCount:(NSMutableDictionary *)successfulQuizzesCount
{
    PFUser *user = [PFUser currentUser];
    
    if (user.objectId) {
        
        user[ParseUserSuccessfulQuizzesCount] = successfulQuizzesCount;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:successfulQuizzesCount forKey:ParseUserSuccessfulQuizzesCount];
    }
}

- (void)setFinishedScenariosCount:(NSMutableDictionary *)finishedScenariosCount
{
    PFUser *user = [PFUser currentUser];
    
    if (user.objectId) {
        
        user[ParseUserFinishedScenariosCount] = finishedScenariosCount;
    
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:finishedScenariosCount forKey:ParseUserFinishedScenariosCount];
    }
}

- (void)setAverageReturns:(NSMutableDictionary *)averageReturns
{
    PFUser *user = [PFUser currentUser];
    
    if (user.objectId) {
        
        user[ParseUserAverageReturns] = averageReturns;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:averageReturns forKey:ParseUserAverageReturns];
    }
}

- (void)setLowestReturns:(NSMutableDictionary *)lowestReturns
{
    PFUser *user = [PFUser currentUser];
    
    if (user.objectId) {
        
        user[ParseUserLowestReturns] = lowestReturns;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:lowestReturns forKey:ParseUserLowestReturns];
    }
}

- (void)setHighestReturns:(NSMutableDictionary *)highestReturns
{
    PFUser *user = [PFUser currentUser];
    
    if (user.objectId) {
        
        user[ParseUserHighestReturns] = highestReturns;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:highestReturns forKey:ParseUserHighestReturns];
    }
}
   
   
   
   
   
   
   
   
   
   
   
   
@end

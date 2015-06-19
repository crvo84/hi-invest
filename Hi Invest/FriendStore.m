//
//  FriendStore.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "FriendStore.h"
#import "UserDefaultsKeys.h"
#import "Friend.h"
#import "UserAccount.h"
#import "ParseUserKeys.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FriendStore ()

@property (strong, nonatomic) NSMutableDictionary *privateFriends;

@end

@implementation FriendStore

+ (instancetype)sharedStore
{
    static FriendStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    
    // Not thread safe
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    
    // Thread safe singleton
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// If a programmer calls [[BNRItemStore alloc] init], let him know the error of his ways
- (instancetype) init
{
    [NSException raise:@"Singleton" format:@"Use +[FriendStore sharedStore]"];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateFriends = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the dictionary hadn't been saved previously, create a new empty one
        if (!_privateFriends) {
            _privateFriends = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"friends.archive"];
}

- (NSDictionary *)allFriendsDictionary
{
    return [self.privateFriends copy];
}

- (NSArray *)friendsOrderedByLevel
{
    NSDictionary *allFriendsDictionary = [self allFriendsDictionary];
    
    NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:[allFriendsDictionary count]];
    for (NSString *facebookId in [allFriendsDictionary allKeys]) {
        [friends addObject:allFriendsDictionary[facebookId]];
    }
    
    [friends sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSInteger level1 = [(Friend *)obj1 level];
        NSInteger level2 = [(Friend *)obj2 level];
        if (level1 > level2) return NSOrderedAscending;
        if (level1 < level2) return NSOrderedDescending;
        return NSOrderedSame;
    }];

    return friends;
}

- (Friend *)friendWithFacebookId:(NSString *)facebookId
{
    return [self.privateFriends[facebookId] copy];
}


- (NSData *)pictureForFriendWithFacebookId:(NSString *)facebookId
{
    Friend *friend = self.privateFriends[facebookId];

    return friend ? [friend.picture copy] : nil;
}

- (void)setPicture:(NSData *)picture forFriendWithFacebookId:(NSString *)facebookId
{
    Friend *friend = self.privateFriends[facebookId];
    friend.picture = [picture copy];
    
    [self saveChanges];
}

- (void)removeAllFriends
{
    [self.privateFriends removeAllObjects];
    
    [self saveChanges];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateFriends toFile:path];
}

#pragma mark - Fetching Friends Info

- (void)fetchFriendsFacebookIds
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if (!error) {
            
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:friendIds forKey:UserDefaultsFriendsFacebookIds];
            
        } else {
            NSLog(@"Facebook Graph Friends Request. Error: %@", [error localizedDescription]);
        }
        
    }];
}


- (void)updateFriendsWithParseUsers:(NSArray *)parseUsers
{
    // Get all FacebookIds from the given parse users into an array
    NSMutableArray *parseUsersFacebookIds = [[NSMutableArray alloc] init];
    for (PFUser *parseUser in parseUsers) {
        NSString *facebookId = parseUser[ParseUserFacebookId];
        if (facebookId) {
            [parseUsersFacebookIds addObject:facebookId];
        }
    }
    
    // Remove stored friends who are not friends anymore
    for (NSString *facebookId in [self.privateFriends allKeys]) {
        if (![parseUsersFacebookIds containsObject:facebookId]) {
            [self.privateFriends removeObjectForKey:facebookId];
        }
    }
    
    // Update friends info with given parse Users
    for (PFUser *parseUser in parseUsers) {
        
        Friend *friend = self.privateFriends[parseUser[ParseUserFacebookId]];
        
        NSString *facebookId = parseUser[ParseUserFacebookId];
        NSString *name = parseUser[ParseUserFirstName];
        NSDictionary *successfulQuizzesCount = parseUser[ParseUserSuccessfulQuizzesCount];
        NSInteger level = [UserAccount userLevelFromSuccessfulQuizzesCount:successfulQuizzesCount];
        
        if (!friend) { // Create new friend with parseUser facebookId
            
            friend = [[Friend alloc] init];
            friend.facebookId = facebookId;
            [self.privateFriends setObject:friend forKey:facebookId];
        }
        
        friend.name = name;
        friend.level = level;
    }
    
    [self saveChanges];
}


@end

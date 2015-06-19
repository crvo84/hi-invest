//
//  FriendStore.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Friend;

@interface FriendStore : NSObject

+ (instancetype)sharedStore;

- (NSDictionary *)allFriendsDictionary;

- (NSArray *)friendsOrderedByLevel;

- (Friend *)friendWithFacebookId:(NSString *)facebookId;

- (void)removeAllFriends;

- (NSData *)pictureForFriendWithFacebookId:(NSString *)facebookId;

- (void)setPicture:(NSData *)picture forFriendWithFacebookId:(NSString *)facebookId;

- (void)updateFriendsWithParseUsers:(NSArray *)parseUsers;

//- (void)fetchFriendsParseUsersAndUpdateFriendsInfo;

@end

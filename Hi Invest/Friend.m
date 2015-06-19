//
//  Friend.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Friend.h"

@implementation Friend

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.facebookId forKey:FriendEncoderFacebookId];
    [aCoder encodeObject:self.name forKey:FriendEncoderName];
    [aCoder encodeObject:self.picture forKey:FriendEncoderPicture];
    [aCoder encodeInteger:self.level forKey:FriendEncoderLevel];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _facebookId = [aDecoder decodeObjectForKey:FriendEncoderFacebookId];
        _name = [aDecoder decodeObjectForKey:FriendEncoderName];
        _picture = [aDecoder decodeObjectForKey:FriendEncoderPicture];
        _level = [aDecoder decodeIntegerForKey:FriendEncoderLevel];
    }
    
    return self;
}

@end

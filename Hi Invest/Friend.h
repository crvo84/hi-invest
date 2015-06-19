//
//  Friend.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FriendEncoderFacebookId @"facebookId"
#define FriendEncoderName @"name"
#define FriendEncoderLevel @"level"
#define FriendEncoderPicture @"picture"

@interface Friend : NSObject <NSCoding>

@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSData *picture;
@property (nonatomic) NSInteger level;



@end

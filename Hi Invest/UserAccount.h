//
//  UserAccount.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/13/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InvestingGame;

@interface UserAccount : NSObject

@property (nonatomic, readonly) NSInteger userLevel;
@property (strong, nonatomic, readonly) InvestingGame *currentInvestingGame;

@end

//
//  Transaction.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameInfo;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * shares;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * scenarioFilename;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * orderingValue;
@property (nonatomic, retain) NSString * ticker;
@property (nonatomic, retain) GameInfo *gameInfo;

@end

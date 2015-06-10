//
//  HistoricalValue.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameInfo;

@interface HistoricalValue : NSManagedObject

@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * portfolioValue;
@property (nonatomic, retain) NSString * scenarioFilename;
@property (nonatomic, retain) GameInfo *gameInfo;

@end

//
//  HistoricalValue+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "HistoricalValue.h"
#import "GameInfo.h"

@interface HistoricalValue (Create)

// Return an HistoricalValue with the given information. If there is already a HistoricalValue with same scenario filename and same (or later) day, do not create one and return nil.
+ (HistoricalValue *)historicalValueWithGameInfo:(GameInfo *)gameInfo
                                  portfolioValue:(double)portfolioValue
                                          andDay:(NSInteger)day;

// Return an array of HistoricalValue managed objects in ascending order sorted by day.
+ (NSArray *)historicalValuesFromGameInfo:(GameInfo *)gameInfo;

@end

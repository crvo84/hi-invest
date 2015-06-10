//
//  Ticker.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GameInfo;

@interface Ticker : NSManagedObject

@property (nonatomic, retain) NSString * realTicker;
@property (nonatomic, retain) NSString * scenarioFilename;
@property (nonatomic, retain) NSString * uiName;
@property (nonatomic, retain) NSNumber * uiPriceMultiplier;
@property (nonatomic, retain) NSString * uiTicker;
@property (nonatomic, retain) GameInfo *gameInfo;

@end

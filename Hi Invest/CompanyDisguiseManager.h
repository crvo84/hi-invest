//
//  CompanyDisguiseManager.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameInfo;
@class Ticker;

@interface CompanyDisguiseManager : NSObject

// Designated initializer
// Receive a GameInfo managed object, a NSArray of real Tickers to disguise and a NSDictionary mapping fictional names with fictional tickers @{name : ticker}
// If it is a new game generate new disguised info
// If it is an existing game, user existing info
- (instancetype)initWithGameInfo:(GameInfo *)gameInfo withCompanyRealTickers:(NSArray *)realTickers withFictionalNamesAndTickers:(NSDictionary *)fictionalNamesAndTickers;

- (NSString *)nameFromTicker:(NSString *)ticker;
- (NSString *)tickerFromTicker:(NSString *)ticker;
- (NSUInteger)priceMultiplierFromTicker:(NSString *)ticker;

@end

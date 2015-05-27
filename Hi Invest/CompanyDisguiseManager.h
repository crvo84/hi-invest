//
//  CompanyDisguiseManager.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyDisguiseManager : NSObject

// Designated initializer
// Receive an NSArray of real Tickers to disguise and a NSDictionary mapping fictional names with fictional tickers @{name : ticker}
- (instancetype)initWithCompaniesRealTickers:(NSArray *)realTickers withFictionalNamesAndTickers:(NSDictionary *)fictionalNamesAndTickers;

- (NSString *)nameFromTicker:(NSString *)ticker;
- (NSString *)tickerFromTicker:(NSString *)ticker;
- (NSUInteger)priceMultiplierFromTicker:(NSString *)ticker;

@end

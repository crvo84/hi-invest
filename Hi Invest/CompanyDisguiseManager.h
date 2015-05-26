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
- (instancetype)initWithCompaniesRealTickers:(NSArray *)realTickers andFictionalNames:(NSArray *)fictionalNames;

- (NSString *)nameFromTicker:(NSString *)ticker;
- (NSString *)tickerFromTicker:(NSString *)ticker;
- (double)priceMultiplierFromTicker:(NSString *)ticker;

@end

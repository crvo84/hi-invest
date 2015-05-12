//
//  PortfolioPicture.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortfolioPicture : NSObject

@property (strong, nonatomic) NSDate *date;
@property (nonatomic) double cash;
@property (strong, nonatomic) NSDictionary *equity; // { Ticker NSString : StockInvestment }
@property (nonatomic) double totalValueAtPictureDate;

- (NSArray *)tickersInPortfolioPicture;

- (NSInteger)sharesInPortfolioPictureOfStockWithTicker:(NSString *)ticker;

// Return YES if the given portfolio picture is equal than the receiver. (EXCLUDING DATE)
// If given otherPortfolioPicture parameter is nil, return NO
- (BOOL)hasEqualCompositionThanPortfolioPicture:(PortfolioPicture *)otherPortfolioPicture;

@end

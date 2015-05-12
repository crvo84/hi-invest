//
//  PortfolioPicture.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioPicture.h"
#import "StockInvestment.h"

@implementation PortfolioPicture

- (NSArray *)tickersInPortfolioPicture
{
    return [self.equity allKeys];
}

- (NSInteger)sharesInPortfolioPictureOfStockWithTicker:(NSString *)ticker
{
    StockInvestment *si = self.equity[ticker];
    return si ? si.shares : NSNotFound;
}

// Return YES if the given portfolio picture is equal than the receiver. (EXCLUDING DATE)
// If given otherPortfolioPicture parameter is nil, return NO
- (BOOL)hasEqualCompositionThanPortfolioPicture:(PortfolioPicture *)otherPortfolioPicture;
{
    if (!otherPortfolioPicture) return NO;
    
    if (self.cash != otherPortfolioPicture.cash) {
        // If different amount of cash
        return NO;
    }
    
    if ([self.equity count] != [otherPortfolioPicture.equity count]) {
        // If different number of companies in portfolio
        return NO;
    }
    
    for (NSString *ticker in self.equity) {
        StockInvestment *stockInvestment = self.equity[ticker];
        StockInvestment *otherStockInvestment = otherPortfolioPicture.equity[ticker];
        
        if (!otherStockInvestment) {
            // if one includes a company that the other does not
            return NO;
        }
        
        if (stockInvestment.shares != otherStockInvestment.shares) {
            // if different number of shares in a similar stock investment
            return NO;
        }
        
        if (stockInvestment.averageCost != otherStockInvestment.averageCost) {
            // if different average cost in similar stock investment
            return NO;
        }
    }
    
    return YES;
}

@end

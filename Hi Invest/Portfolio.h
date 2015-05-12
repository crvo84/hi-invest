//
//  Portfolio.h
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PortfolioPicture;

@interface Portfolio : NSObject

@property (nonatomic, readonly) double cash;
@property (strong, nonatomic, readonly) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }

// Initializers
- (instancetype)initPortfolioWithCash:(double)cash;
- (instancetype)initPortfolioWithPortfolioPicture:(PortfolioPicture *)portfolioPicture;

- (BOOL)investInStockWithTicker:(NSString *)ticker
                      withPrice:(double)price
                forSharesNumber:(NSUInteger)shares;

- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                        withPrice:(double)price
                  forSharesNumber:(NSUInteger)shares;

//- (void)addCashToPortfolioInAmount:(double)newCash;

- (NSInteger)sharesInPortfolioOfStockWithTicker:(NSString *)ticker;

- (BOOL)hasInvestmentWithTicker:(NSString *)ticker;

- (NSArray *)tickersOfStocksInPortfolio;

// Return NSNotFound if no shares owned of the company of the given ticker
- (double)averageCostForCompanyWithTicker:(NSString *)ticker;

@end

//
//  Portfolio.h
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PortfolioPicture;
@class PortfolioTransaction;

@interface Portfolio : NSObject

@property (nonatomic, readonly) double cash;
@property (strong, nonatomic, readonly) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }
@property (nonatomic, readonly) double totalDividendsReceived;
@property (nonatomic, readonly) double totalCommissionsPaid;

// Initializers
- (instancetype)initPortfolioWithCash:(double)cash;
- (instancetype)initPortfolioWithPortfolioPicture:(PortfolioPicture *)portfolioPicture;

// Return true if investment was successful. false otherwise
- (BOOL)investInStockWithTicker:(NSString *)ticker
                      price:(double)price
                numberOfShares:(NSUInteger)shares
                 commissionPaid:(double)commission
                          atDay:(NSInteger)day;

// Return true if deinvestment was successful. false otherwise
- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                        price:(double)price
                  numberOfShares:(NSUInteger)shares
                   commissionPaid:(double)commission
                            atDay:(NSInteger)day;

// Return true if dividend reception was successful. False otherwise (if no investments for that company)
- (BOOL)receiveDividendsFromStockWithTicker:(NSString *)ticker
                         withNumberOfShares:(NSInteger)shares
                             withCashAmount:(double)cashAmount
                                      atDay:(NSInteger)day;

- (NSArray *)transactionsFromDay:(NSInteger)day;

- (NSInteger)sharesInPortfolioOfStockWithTicker:(NSString *)ticker;

- (BOOL)hasInvestmentWithTicker:(NSString *)ticker;

- (NSArray *)tickersOfStocksInPortfolio;

// Return NSNotFound if no shares owned of the company of the given ticker
- (double)averageCostForCompanyWithTicker:(NSString *)ticker;

@end

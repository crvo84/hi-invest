//
//  Portfolio.h
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameInfo;
@class Transaction;

@interface Portfolio : NSObject

@property (strong, nonatomic) GameInfo *gameInfo;
@property (nonatomic, readonly) double cash;
@property (strong, nonatomic, readonly) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }


// Initializer
- (instancetype)initPortfolioWithGameInfo:(GameInfo *)gameInfo withCash:(double)cash;

// Return true if investment was successful. false otherwise
- (BOOL)investInStockWithTicker:(NSString *)ticker
                      price:(double)price
                numberOfShares:(NSUInteger)shares
                 commissionPaid:(double)commission
                          atDay:(NSInteger)day
          recreatingTransaction:(BOOL)recreatingTransaction;

// Return true if deinvestment was successful. false otherwise
- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                        price:(double)price
                  numberOfShares:(NSUInteger)shares
                   commissionPaid:(double)commission
                            atDay:(NSInteger)day
            recreatingTransaction:(BOOL)recreatingTransaction;

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

- (void)recreateTransaction:(Transaction *)transaction;

@end

//
//  Portfolio.m
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Portfolio.h"
#import "StockInvestment.h"
#import "PortfolioPicture.h"

@interface Portfolio ()

@property (nonatomic, readwrite) double cash;
@property (strong, nonatomic, readwrite) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }

@end

@implementation Portfolio

// Initializer
- (instancetype)initPortfolioWithCash:(double)cash
{
    self = [super init];
    
    if (self) {
        self.cash = cash;
    }
    
    return self;
}

// Initializer
- (instancetype)initPortfolioWithPortfolioPicture:(PortfolioPicture *)portfolioPicture
{
    self = [super init];
    
    if (self) {
        self.cash = portfolioPicture.cash;
        if (portfolioPicture.equity) {
            self.equity = [portfolioPicture.equity mutableCopy];
        }
    }

    return self;
}



- (BOOL)investInStockWithTicker:(NSString *)ticker
                          price:(double)price
                 numberOfShares:(NSUInteger)shares
                 commissionPaid:(double)commission
{
    if (price * shares + commission > self.cash) {
        return NO;
    } else {
        self.cash -= price * shares + commission;
    }
    
    StockInvestment *si = self.equity[ticker];
    
    if (si) {
        double totalShares = si.shares + shares;
        double newAvergageCost = ((si.averageCost * si.shares) + (price * shares)) / totalShares;
        si.averageCost = newAvergageCost;
        si.shares = totalShares;
    } else {
        si = [[StockInvestment alloc] init];
        si.ticker = ticker;
        si.averageCost = price;
        si.shares = shares;
    }
    
    [self.equity setObject:si forKey:ticker];
    
    return YES;
}

- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                            price:(double)price
                   numberOfShares:(NSUInteger)shares
                   commissionPaid:(double)commission
{
    StockInvestment *si = self.equity[ticker];
    
    if (!si) return NO;
    if (si.shares < shares) return NO;
    
    if (price * shares + self.cash < commission) {
        return NO;
    }
    
    self.cash += price * shares - commission;
    
    if (si.shares == shares) {
        [self.equity removeObjectForKey:ticker];
    } else {
        si.shares -= shares;
    }
    
    return YES;
}

- (void)addCashToPortfolioInAmount:(double)newCash
{
    self.cash += newCash;
}

- (NSInteger)sharesInPortfolioOfStockWithTicker:(NSString *)ticker
{
    StockInvestment *si = self.equity[ticker];
    
    if (!si) return 0;
    
    return si.shares;
}

- (BOOL)hasInvestmentWithTicker:(NSString *)ticker
{
    StockInvestment *stockInvestment = [self.equity objectForKey:ticker];
    
    return stockInvestment ? YES : NO;
}

- (NSArray *)tickersOfStocksInPortfolio
{
    NSMutableArray *tickers = [[NSMutableArray alloc] init];
    for (NSString *ticker in self.equity) {
        [tickers addObject:ticker];
    }

    return tickers;
}

// Return the average price for the company of the given ticker in the portfolio
// Return NSNotFound if not investment of such company in the portfolio
- (double)averageCostForCompanyWithTicker:(NSString *)ticker
{
    StockInvestment *stockInvestment = [self.equity objectForKey:ticker];
    if (stockInvestment) {
        return stockInvestment.averageCost;
    } else {
        return NSNotFound;
    }
}

#pragma mark - Getters

- (NSMutableDictionary *)equity
{
    if (!_equity) {
        _equity = [[NSMutableDictionary alloc] init];
    }
    
    return _equity;
}
















@end

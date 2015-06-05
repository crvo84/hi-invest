//
//  Portfolio.m
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Portfolio.h"
#import "StockInvestment.h"
#import "GameInfo.h"
#import "Transaction+Create.h"

@interface Portfolio ()

@property (nonatomic, readwrite) double cash;
@property (strong, nonatomic, readwrite) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }

@end

@implementation Portfolio

// Initializer
- (instancetype)initPortfolioWithGameInfo:(GameInfo *)gameInfo withCash:(double)cash
{
    self = [super init];
    
    if (self) {
        self.gameInfo = gameInfo;
        self.cash = cash;
    }
    
    return self;
}


// Return true if investment was successful. false otherwise
- (BOOL)investInStockWithTicker:(NSString *)ticker
                          price:(double)price
                 numberOfShares:(NSUInteger)shares
                 commissionPaid:(double)commission
                          atDay:(NSInteger)day
          recreatingTransaction:(BOOL)recreatingTransaction
{
    // CHECK IF POSSIBLE
    if (price * shares + commission > self.cash) {
        return NO;
    } else {
        self.cash -= price * shares + commission;
    }
    
    StockInvestment *si = self.equity[ticker];
    
    // INVEST
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
    
    if (!recreatingTransaction) {
        // REGISTER TRANSACTION
        // Add purchase transaction
        [Transaction transactionWithGameInfo:self.gameInfo type:PortfolioTransactionTypePurchase day:day amount:(price *shares) shares:shares andTicker:ticker];
        
        // Add commission transaction
        [Transaction transactionWithGameInfo:self.gameInfo type:PortfolioTransactionTypeCommissionPurchase day:day amount:commission shares:0 andTicker:ticker];
    }

    return YES;
}

// Return true if deinvestment was successful. false otherwise
- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                            price:(double)price
                   numberOfShares:(NSUInteger)shares
                   commissionPaid:(double)commission
                            atDay:(NSInteger)day
            recreatingTransaction:(BOOL)recreatingTransaction
{
    // CHECK IF POSSIBLE
    StockInvestment *si = self.equity[ticker];
    
    if (!si) return NO;
    if (si.shares < shares) return NO;
    
    if (price * shares + self.cash < commission) {
        return NO;
    }
    
    // DEINVEST
    self.cash += price * shares - commission;
    
    if (si.shares == shares) {
        [self.equity removeObjectForKey:ticker];
    } else {
        si.shares -= shares;
    }
    
    if (!recreatingTransaction) {
        // REGISTER TRANSACTION
        // Add sale transaction
        [Transaction transactionWithGameInfo:self.gameInfo type:PortfolioTransactionTypeSale day:day amount:(price * shares) shares:shares andTicker:ticker];
        
        // Add commission transaction
        [Transaction transactionWithGameInfo:self.gameInfo type:PortfolioTransactionTypeCommissionSale day:day amount:commission shares:shares andTicker:ticker];
    }

    return YES;
}


// Return true if dividend reception was successful. False otherwise (if no investments for that company)
- (BOOL)receiveDividendsFromStockWithTicker:(NSString *)ticker
                         withNumberOfShares:(NSInteger)shares
                             withCashAmount:(double)cashAmount
                                      atDay:(NSInteger)day
{
    // CHECK IF POSSIBLE
    if (![self hasInvestmentWithTicker:ticker] || cashAmount <= 0) {
        return NO;
    }
    
    // RECEIVE DIVIDEND
    self.cash += cashAmount;
    
    // REGISTER TRANSACTION
    [Transaction transactionWithGameInfo:self.gameInfo type:PortfolioTransactionTypeDividends day:day amount:cashAmount shares:shares andTicker:ticker];
    
    return YES;
}

- (NSArray *)transactionsFromDay:(NSInteger)day
{
    return [Transaction transactionsFromGameInfo:self.gameInfo fromDay:day];
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

#pragma mark - Game Recreation

- (void)recreateTransaction:(Transaction *)transaction
{
    PortfolioTransactionType type = [transaction.type integerValue];
    
    if (type == PortfolioTransactionTypeCommissionPurchase || type == PortfolioTransactionTypeCommissionSale) {
        self.cash -= [transaction.amount doubleValue];
    } else if (type == PortfolioTransactionTypeDividends) {
        self.cash += [transaction.amount doubleValue];
    } else {
        NSString *ticker = transaction.ticker;
        NSInteger day = [transaction.day integerValue];
        double amount = [transaction.amount doubleValue];
        NSInteger shares = [transaction.shares integerValue];
        double price = amount / shares;
        if (type == PortfolioTransactionTypePurchase) {
            [self investInStockWithTicker:ticker price:price numberOfShares:shares commissionPaid:0 atDay:day recreatingTransaction:YES];
        } else if (type == PortfolioTransactionTypeSale) {
            [self deinvestInStockWithTicker:ticker price:price numberOfShares:shares commissionPaid:0 atDay:day recreatingTransaction:YES];
        }
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

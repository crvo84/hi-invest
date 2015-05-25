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
#import "PortfolioTransaction.h"

@interface Portfolio ()

@property (nonatomic, readwrite) double cash;
@property (strong, nonatomic, readwrite) NSMutableDictionary *equity; // { Ticker NSString : StockInvestment }
@property (strong, nonatomic) NSMutableDictionary *transactions; // { [@(Day Number) asString] : NSMutableArray (of PortfolioTransaction) }
@property (nonatomic, readwrite) double totalCommissionsPaid;
@property (nonatomic, readwrite) double totalDividendsReceived;

@end

@implementation Portfolio

// Initializer
- (instancetype)initPortfolioWithCash:(double)cash
{
    self = [super init];
    
    if (self) {
        self.cash = cash;
        self.totalCommissionsPaid = 0;
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


// Return true if investment was successful. false otherwise
- (BOOL)investInStockWithTicker:(NSString *)ticker
                          price:(double)price
                 numberOfShares:(NSUInteger)shares
                 commissionPaid:(double)commission
                          atDay:(NSInteger)day
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
    
    self.totalCommissionsPaid += commission;
    
    // REGISTER TRANSACTION
    // Add purchase transaction
    PortfolioTransaction *purchaseTransaction = [[PortfolioTransaction alloc] init];
    purchaseTransaction.transactionType = PortfolioTransactionTypePurchase;
    purchaseTransaction.ticker = ticker;
    purchaseTransaction.day = day;
    purchaseTransaction.shares = shares;
    purchaseTransaction.amount = price * shares;
    [self registerTransaction:purchaseTransaction atDay:day];
    
    // Add commission transaction
    PortfolioTransaction *commissionTransaction  = [[PortfolioTransaction alloc] init];
    commissionTransaction.transactionType = PortfolioTransactionTypeCommissionPurchase;
    commissionTransaction.ticker = ticker;
    commissionTransaction.day = day;
    commissionTransaction.amount = commission;
    [self registerTransaction:commissionTransaction atDay:day];
    
    return YES;
}

// Return true if deinvestment was successful. false otherwise
- (BOOL)deinvestInStockWithTicker:(NSString *)ticker
                            price:(double)price
                   numberOfShares:(NSUInteger)shares
                   commissionPaid:(double)commission
                            atDay:(NSInteger)day
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
    
    self.totalCommissionsPaid += commission;
    
    // REGISTER TRANSACTION
    // Add sale transaction
    PortfolioTransaction *saleTransaction = [[PortfolioTransaction alloc] init];
    saleTransaction.transactionType = PortfolioTransactionTypeSale;
    saleTransaction.ticker = ticker;
    saleTransaction.day = day;
    saleTransaction.shares = shares;
    saleTransaction.amount = price * shares;
    [self registerTransaction:saleTransaction atDay:day];
    
    // Add commission transaction
    PortfolioTransaction *commissionTransaction  = [[PortfolioTransaction alloc] init];
    commissionTransaction.transactionType = PortfolioTransactionTypeCommissionSale;
    commissionTransaction.ticker = ticker;
    commissionTransaction.day = day;
    commissionTransaction.amount = commission;
    [self registerTransaction:commissionTransaction atDay:day];
    
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
    PortfolioTransaction *dividendTransaction = [[PortfolioTransaction alloc ] init];
    dividendTransaction.transactionType = PortfolioTransactionTypeDividends;
    dividendTransaction.ticker = ticker;
    dividendTransaction.day = day;
    dividendTransaction.shares = shares;
    dividendTransaction.amount = cashAmount;
    [self registerTransaction:dividendTransaction atDay:day];
    
    return YES;
}

- (void)registerTransaction:(PortfolioTransaction *)transaction atDay:(NSInteger)day
{
    NSString *dayKey = [@(day) stringValue];
    
    NSMutableArray *dayTransactions = self.transactions[dayKey];
    
    if (!dayTransactions) {
        
        dayTransactions = [[NSMutableArray alloc] init];
    }
    
    [dayTransactions addObject:transaction];
    
    self.transactions[dayKey] = dayTransactions;
}

- (NSArray *)transactionsFromDay:(NSInteger)day;
{
    return self.transactions[[@(day) stringValue]];
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

- (NSMutableDictionary *)transactions
{
    if (!_transactions) {
        _transactions = [[NSMutableDictionary alloc] init];
    }
    
    return _transactions;
}














@end

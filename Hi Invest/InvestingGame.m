//
//  InvestingGame.m
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "InvestingGame.h"

#import "ManagedObjectContextCreator.h"
#import "CompanyDisguiseManager.h"
#import "FictionalNamesKeys.h"
#import "FinancialDatabaseManager.h"
#import "PortfolioTransaction.h"
#import "Scenario.h"
#import "PortfolioPicture.h"
#import "PortfolioHistoricalValue.h"
#import "RatiosKeys.h"
#import "PortfolioKeys.h"
#import "CompaniesInfoKeys.h"
#import "Company.h"
#import "Price.h"
#import "Dividend.h"


@interface InvestingGame ()

@property (strong, nonatomic, readwrite) Portfolio *portfolio;
@property (strong, nonatomic, readwrite) NSArray *tickersOfCompaniesAvailable; // of NSString
@property (strong, nonatomic, readwrite) NSDate *initialDate;
@property (strong, nonatomic, readwrite) NSDate *endDate;
@property (strong, nonatomic, readwrite) NSDate *currentDate;
@property (strong, nonatomic, readwrite) NSDictionary *currentPrices; // @{NSString ticker : Price}
@property (nonatomic, readwrite) BOOL disguiseRealNamesAndTickers;
@property (strong, nonatomic, readwrite) CompanyDisguiseManager *disguiseManager;
@property (strong, nonatomic, readwrite) NSMutableArray *portfolioPictures; // of PortfolioPicture
@property (strong, nonatomic, readwrite) NSMutableArray *portfolioHistoricalValues; // of PortfolioHistoricalValue
@property (nonatomic, readwrite) double initialNetworth;

@end

@implementation InvestingGame

#define InvestingGameDefaultTransactionCommissionRate 0.0015

// Designated Initializer
// Return a initialized InvestingGame with initial cash and initial date
// If portfolioPictures parameter is given as nil, then is a new game.
- (instancetype)initInvestingGameWithInitialCash:(double)initialCash
                     disguisingRealNamesAndTickers:(BOOL)disguiseRealNamesAndTickers
                                        scenario:(Scenario *)scenario
                            andPortfolioPictures:(NSArray *)portfolioPictures
{
    self = [super init];
    
    if (self) {
        self.initialNetworth = initialCash;
        self.scenarioInfo = scenario;
        self.tickersOfCompaniesAvailable = [scenario.companyTickersStr componentsSeparatedByString:@","];
        self.initialDate = scenario.initialScenarioDate;
        self.endDate = scenario.endingScenarioDate;
        self.disguiseRealNamesAndTickers = disguiseRealNamesAndTickers;
        self.transactionCommissionRate = InvestingGameDefaultTransactionCommissionRate;
        self.managedObjectContext = scenario.managedObjectContext;
        
        if (portfolioPictures && [portfolioPictures count] > 0) {
            PortfolioPicture *lastPicture = [portfolioPictures lastObject];
            
            if ([scenario.endingScenarioDate timeIntervalSinceDate:lastPicture.date] < -(60*60*12)) {
                NSLog(@"Cannot load a game with a current date later than the maximum date");
                return nil;
            }
            
            if ([lastPicture.date timeIntervalSinceDate:scenario.initialScenarioDate] < -(60*60*12)) {
                NSLog(@"Cannot load a game with a current date earlier than minimum date");
                return nil;
            }
            
            self.currentDate = lastPicture.date;
            self.portfolio = [[Portfolio alloc] initPortfolioWithPortfolioPicture:lastPicture];
            self.portfolioPictures = [portfolioPictures mutableCopy];
            
        } else {
            self.currentDate = scenario.initialScenarioDate;
            self.portfolio = [[Portfolio alloc] initPortfolioWithCash:initialCash];
        }
    }
    
    return self;
}

// Sets the "current date" as a date with the given time difference from the current "current date"
// If the new date is weekend or bank holiday (no prices available), then the next later valid date is set as the new "current date"
// Negative time difference means earlier dates.
// If new date is later than the maximum date from user defaults, current date stays the same
// Return YES if the change was made. NO if the change was not made (maybe new date was later than endDate).
- (BOOL)changeCurrentDateToDateWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months andDays:(NSInteger)days
{
    NSDate *newDate = [FinancialDatabaseManager dateWithTimeDifferenceinYears:years months:months days:days hours:0 fromDate:self.currentDate];
    
    if ([newDate timeIntervalSinceDate:self.endDate] > (60*60*12)) {
        // new date is out of database available info range
        return NO;
    }
    
    while (![FinancialDatabaseManager arePricesAvailableForDate:newDate fromScenario:self.scenarioInfo]) {
        newDate = [FinancialDatabaseManager dateWithTimeDifferenceinYears:0 months:0 days:1 hours:0 fromDate:newDate];
        
        if ([newDate timeIntervalSinceDate:self.endDate] > (60*60*12)) {
            // new date is out of database available info range
            return NO;
        }
    }
    
    // If the new date is later than the current date, then take and save a picture of the current portfolio before forwarding the date
    // It will almost always be a later date. But the given time parameters could negative so the date could be earlier.
    if ([newDate timeIntervalSinceDate:self.currentDate] > (60*60*12)) {
        
        // Take a picture of the current portfolio
        PortfolioPicture *currentPortfolioPicture = [self takePortfolioPicture];
        
        [self updatePortfolioHistoricalValuesFromPortfolioPicture:currentPortfolioPicture untilADayBeforeDate:newDate];
        
        // If there were any changes in the portfolio composition. Add the picture to the end of the portfolioPictures array property.
        if (![currentPortfolioPicture hasEqualCompositionThanPortfolioPicture:[self.portfolioPictures lastObject]]) {
            [self.portfolioPictures addObject:currentPortfolioPicture];
        }
    }
    
    [self collectDividendsFromCompaniesWithTickers:[self.portfolio tickersOfStocksInPortfolio]
                                          fromDate:[NSDate dateWithTimeInterval:(60*60*24) sinceDate:self.currentDate]
                                            toDate:newDate];

    self.currentDate = newDate;
    self.currentPrices = nil; // reset prices to get the new date prices
    
//    NSLog(@"Portfolio historical values count: %ld", [self.portfolioHistoricalValues count]);
    
    return YES;
}

- (void)collectDividendsFromCompaniesWithTickers:(NSArray *)tickers fromDate:(NSDate *)initialDate toDate:(NSDate *)finalDate
{
    NSArray *dividends = [FinancialDatabaseManager arrayOfDividendsPaidFromCompaniesWithTickers:tickers fromDate:initialDate toDate:finalDate fromManagedObjectContext:self.managedObjectContext];
    
    for (Dividend *dividend in dividends) {
        NSInteger dividendDay = [self dayNumberFromDate:dividend.date];
        NSInteger sharesOwned = [self.portfolio sharesInPortfolioOfStockWithTicker:dividend.ticker];
        double dividendAmount = dividend.amountPerShare * sharesOwned;
        [self.portfolio receiveDividendsFromStockWithTicker:dividend.ticker withNumberOfShares:sharesOwned withCashAmount:dividendAmount atDay:dividendDay];
    }
    
}


// Return the number of days from the currentDate until the endDate
- (NSInteger)daysLeft
{
    NSInteger timeInterval = [self.endDate timeIntervalSinceDate:self.currentDate];
    return timeInterval / (60*60*24);
}

// Return the current day number. Starting from 1.
- (NSInteger)currentDay
{
    return [self dayNumberFromDate:self.currentDate];
}

// Return the day number from the given date
- (NSInteger)dayNumberFromDate:(NSDate *)date
{
    NSInteger timeInverval = [date timeIntervalSinceDate:self.initialDate];
    NSInteger daysInterval = timeInverval / (60*60*24);
    return daysInterval + 1;
}

// Return the current value of porfolio
- (double)currentNetWorth
{
    double stockValue = 0;
    for (NSString *ticker in [self.portfolio tickersOfStocksInPortfolio]) {
        Price *priceObject = self.currentPrices[ticker];
        if (priceObject) {
            double price = [priceObject.price doubleValue];
            stockValue += [self.portfolio sharesInPortfolioOfStockWithTicker:ticker] * price;
        }
    }

    return stockValue + self.portfolio.cash;
}

// Return the market price at the given date;
// Return nil if given date is earlier than the initial game date, or later than maximum game date
// Scenario Info has a string containing the available market prices in the database. Separated by a comma ",". The first market is the scenario comparing market
- (NSNumber *)scenarioMarketPriceAtDate:(NSDate *)date
{
    if ([self.initialDate timeIntervalSinceDate:date] > (60*60*6) || [date timeIntervalSinceDate:self.endDate] > (60*60*12)) {
        return nil;
    }
    NSArray *allMarketTickers = [self.scenarioInfo.marketTickersStr componentsSeparatedByString:@","];
    NSString *scenarioMarketTicker = [allMarketTickers firstObject];
    Price *scenarioMarketPrice = [[FinancialDatabaseManager arrayOfPricesWithTickers:@[scenarioMarketTicker] atDate:date fromManagedObjectContext:self.managedObjectContext] firstObject];
    if (scenarioMarketPrice) {
        return scenarioMarketPrice.price;
    }
    
    return nil;
}


// Return an NSDictionary with the ticker as key, and a NSNumber with the double of the weight of that stock in the portfolio (Using current prices) (If array is nil, return info for all companies available from prices)
- (NSDictionary *)weigthInPortfolioOfStocksWithTickers:(NSArray *)tickers
{
    NSMutableDictionary *weightsInPortfolio = [[NSMutableDictionary alloc] init];
    
    if (!tickers) {
        tickers = [self.currentPrices allKeys];
    }
    
    double netWorth = [self currentNetWorth];
    for (NSString *ticker in tickers) {
        NSInteger shares = [self.portfolio sharesInPortfolioOfStockWithTicker:ticker];
        Price *priceManagedObject = self.currentPrices[ticker];
        if (priceManagedObject) {
            double price = [priceManagedObject.price doubleValue];
            double weightInPortfolio = price * shares / netWorth;
            [weightsInPortfolio setObject:[NSNumber numberWithDouble:weightInPortfolio] forKey:ticker];
        }
    }
    
    return weightsInPortfolio;
}

// Return an NSArray with the ticker of the companies ordered by weight in portfolio with current prices.
- (NSArray *)tickersOfCompaniesInPortfolioOrderedByWeightInDescendingOrder:(BOOL)descendingOrder
{
    NSArray *tickers = [self.portfolio tickersOfStocksInPortfolio];
    NSDictionary *weights = [self weigthInPortfolioOfStocksWithTickers:tickers];
    
    if (weights) {
        
        tickers = [tickers sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *ticker1 = (NSString *)obj1;
            NSString *ticker2 = (NSString *)obj2;
            
            NSNumber *weight1Number = weights[ticker1];
            NSNumber *weight2Number = weights[ticker2];
            
            if (!weight1Number && !weight2Number) {
                // both weight numbers invalid
                return NSOrderedSame;
            }
            
            if (!weight2Number || [weight1Number doubleValue] > [weight2Number doubleValue]) {
                // weight 2 number invalid or weight 1 is larger than weight 2
                return descendingOrder ? NSOrderedAscending : NSOrderedDescending;
            }
            
            if (!weight1Number || [weight1Number doubleValue] < [weight2Number doubleValue]) {
                return descendingOrder ? NSOrderedDescending : NSOrderedAscending;
            }
            
            return NSOrderedSame;
        }];
    }
    
    return tickers;
}


// Returns a dictionary with the ratios for the companies available. @{NSString : NSNumber}
// If this is called many times with same info, maybe is better to create a property with lazy instantiation
- (NSDictionary *)sortingValuesForAllAvailableCompaniesWithSortingValueId:(NSString *)sortingValueId
{
    NSDictionary *sortingValues = [[NSDictionary alloc] init];
    
    if ([sortingValueId isEqualToString:FinancialRatioWeightInPortfolio]) {
        sortingValues = [self weigthInPortfolioOfStocksWithTickers:nil];
    } else {
        sortingValues = [FinancialDatabaseManager dictionaryOfSortingValuesWithPrices:self.currentPrices atDate:self.currentDate withSortingValueIdentifier:sortingValueId fromManagedObjectContext:self.managedObjectContext];
    }
    
    return sortingValues;
}

// Returns a NSMutableArray of NSDictionary containing Company info: ticker (NSString), price (Price), sortingValue (NSNumber)
// If parameter tickers is nil, return information of all available companies. If parameter sortingValueId is nil, the result wont contain sorting value information. Includes the market average with mkt name as ticker (if apply).(UPDATE for S&P 500 average and more)
- (NSMutableArray *)informationOfCompanies:(NSArray *)tickers withSortingValueId:(NSString *)sortingValueId
{
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    if (!tickers) {
        tickers = self.tickersOfCompaniesAvailable;
    }
    
    NSDictionary *sortingValues = [self sortingValuesForAllAvailableCompaniesWithSortingValueId:sortingValueId];
    
    for (NSString *ticker in tickers) {
        NSMutableDictionary *companyInfo = [[NSMutableDictionary alloc] init];
        Price *price = self.currentPrices[ticker];
        if (price) {
            [companyInfo setObject:ticker forKey:companyTicker];
            [companyInfo setObject:price.price forKey:companyPriceNumber];
            NSNumber *orderingValueNumber = sortingValues[ticker];
            if (orderingValueNumber) {
                [companyInfo setObject:orderingValueNumber forKey:companyOrderingValueNumber];
            }
            [info addObject:companyInfo];
        }
    }
    
    return info;
}

#pragma mark - Disguising

// Return the disguise value for the company of the given ticker

- (NSString *)UITickerForTicker:(NSString *)ticker
{
    if (self.disguiseRealNamesAndTickers) {
        return [self.disguiseManager tickerFromTicker:ticker];
    }
    
    return ticker;
}

- (NSString *)UINameForTicker:(NSString *)ticker
{
    if (self.disguiseRealNamesAndTickers) {
        return [self.disguiseManager nameFromTicker:ticker];
    }
    
    Price *price = self.currentPrices[ticker];
    
    if (price) {
        return price.company.name;
    }
    
    return nil;
}

- (NSUInteger)UIPriceMultiplierForTicker:(NSString *)ticker
{
    if (self.disguiseRealNamesAndTickers) {
        return [self.disguiseManager priceMultiplierFromTicker:ticker];
    }
    
    return 1;
}


#pragma mark - Historic Data

// Return a PortfolioPicture of the current portfolio state
- (PortfolioPicture *)takePortfolioPicture
{
    PortfolioPicture *portfolioPicture = [[PortfolioPicture alloc] init];
    portfolioPicture.date = [self.currentDate copy];
    portfolioPicture.cash = self.portfolio.cash;
    portfolioPicture.equity = [self.portfolio.equity copy];
    portfolioPicture.totalValueAtPictureDate = [self currentNetWorth];
    
    return portfolioPicture;
}

// Update the property NSMutableArray with the corresponding new historical portfolio values.
// Using the given portfolio picture composition. From the date when the last portfolio picture was taken, until the day before the given date.
// (DOES NOT INCLUDE THE GIVEN DATE NET WORTH)
- (void)updatePortfolioHistoricalValuesFromPortfolioPicture:(PortfolioPicture *)portfolioPicture untilADayBeforeDate:(NSDate *)limitDate
{
        NSDate *date = portfolioPicture.date;
        
        while ([limitDate timeIntervalSinceDate:date] > (60*60*12)) {
            
            PortfolioHistoricalValue *portfolioHistoricalValue = [self portfolioHistoricalValueFromPortfolioPicture:portfolioPicture atDate:date withManagedObjectContext:self.managedObjectContext];
            
            if (portfolioHistoricalValue) { // Check for weekends and bank holidays when there are no prices available
                [self.portfolioHistoricalValues addObject:portfolioHistoricalValue];
            }
            
            date = [FinancialDatabaseManager dateWithTimeDifferenceinYears:0 months:0 days:1 hours:0 fromDate:date];
        }
}


// Return a NSNumber with a double of the portfolio value with the given PortfolioPicture at the given date.
// If the date parameter is nil, it uses the PortfolioPicture date.
- (PortfolioHistoricalValue *)portfolioHistoricalValueFromPortfolioPicture:(PortfolioPicture *)portfolioPicture atDate:(NSDate *)date withManagedObjectContext:(NSManagedObjectContext *)context
{
    PortfolioHistoricalValue *portfolioHistoricalValue = nil;
    
    if (!date) {
        date = portfolioPicture.date;
    }
    
    NSArray *tickersInPortfolioPictureEquity = [portfolioPicture tickersInPortfolioPicture];
    
    NSDictionary *prices = [FinancialDatabaseManager dictionaryOfPricesWithTickers:tickersInPortfolioPictureEquity atDate:date fromManagedObjectContext:context];

    if (prices && [prices count] == [tickersInPortfolioPictureEquity count]) {
        double value = portfolioPicture.cash;
    
        for (NSString *ticker in prices) {
    
            NSInteger shares = [portfolioPicture sharesInPortfolioPictureOfStockWithTicker:ticker];
            Price *price = prices[ticker];
    
            if (shares != NSNotFound && price) {
                value += shares * [price.price doubleValue];
            }
        }
        
        portfolioHistoricalValue = [[PortfolioHistoricalValue alloc] init];
        portfolioHistoricalValue.date = date;
        portfolioHistoricalValue.value = value;
    }
    
    return portfolioHistoricalValue;
}

// Return a NSArray of PortfolioTransaction objects
// If initialDate is nil, the earliest game date will be used.
// If finalDate is nil, the current game date will be used.
// At least one transactionType must be given.
- (NSArray *)portfolioTransactionHistoryFromDate:(NSDate *)initialDate toDate:(NSDate *)finalDate withTransactionTypes:(PortfolioTransactionType)transactionType
{
    NSMutableArray *transactions = [[NSMutableArray alloc] init];
    
    if (!initialDate) {
        initialDate = self.initialDate;
    }
    
    if (!finalDate) {
        finalDate = self.currentDate;
    }
    
    
    return transactions;
}



#pragma mark - Getters

// Getter (with lazy instantiation) for a dictionary with the prices for the companies available. This can be set to nil to get new prices when the getter is called again (eg. when current date changes). @{NSString : Price}
- (NSDictionary *)currentPrices
{
    if (!_currentPrices) {
        NSMutableDictionary *prices = [[NSMutableDictionary alloc] init];
        NSArray *pricesFetched = [FinancialDatabaseManager arrayOfPricesWithTickers:self.tickersOfCompaniesAvailable
                                                                             atDate:self.currentDate
                                                           fromManagedObjectContext:self.managedObjectContext];
        for (Price *price in pricesFetched) {
            prices[price.ticker] = price;
        }
        _currentPrices = prices;
    }
    
    return _currentPrices;
}

- (NSMutableArray *)portfolioPictures
{
    if (!_portfolioPictures) {
        _portfolioPictures = [[NSMutableArray alloc] init];
    }
    
    return _portfolioPictures;
}

- (NSMutableArray *)portfolioHistoricalValues
{
    if (!_portfolioHistoricalValues) {
        
        _portfolioHistoricalValues = [[NSMutableArray alloc] init];
        
        PortfolioHistoricalValue *startingPortfolioValue = [[PortfolioHistoricalValue alloc] init];
        startingPortfolioValue.date = [NSDate dateWithTimeInterval:-(60*60*24) sinceDate:self.initialDate];
        startingPortfolioValue.value = self.initialNetworth;
        
        [_portfolioHistoricalValues addObject:startingPortfolioValue];
    }
    
    return _portfolioHistoricalValues;
}

- (NSLocale *)locale
{
    if (!_locale) {
        _locale = [NSLocale localeWithLocaleIdentifier:self.scenarioInfo.localeStr];
    }
    
    return _locale;
}

- (CompanyDisguiseManager *)disguiseManager
{
    if (!_disguiseManager) {
        _disguiseManager = [[CompanyDisguiseManager alloc] initWithCompaniesRealTickers:self.tickersOfCompaniesAvailable withFictionalNamesAndTickers:FictionalNamesGOTHousesDictionary];
    }
    
    return _disguiseManager;
}















@end

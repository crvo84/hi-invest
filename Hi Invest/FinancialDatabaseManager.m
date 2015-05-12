//
//  FinancialDatabaseManager.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "FinancialDatabaseManager.h"
#import "CompaniesInfoKeys.h"
#import "RatiosKeys.h"
#import "PortfolioKeys.h"
#import "Scenario.h"
#import "Price.h"
#import "Report.h"
#import "Company.h"
#import "IncomeStatement.h"
#import "BalanceSheet.h"
#import "CashFlow.h"

@implementation FinancialDatabaseManager

#pragma mark - Fetching methods

// Return an array of Company managed objects for the tickers (NSString) in the given array from the given managed object context
+ (NSArray *)arrayOfCompaniesWithTickers:(NSArray *)tickers
                fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Company"];
    request.predicate = [NSPredicate predicateWithFormat:@"ticker IN %@", tickers];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching Company managed objects from database with array of tickers. %@", [error localizedDescription]);
        return nil;
    } else if ([matches count] > [tickers count]) {
        NSLog(@"Companies fetch from database with array of tickers returned more matches than tickers.");
        return nil;
    } else if ([matches count] < [tickers count]) {
        NSLog(@"Companies fetch from database with array of tickers returned less matches than tickers.");
    }
    
    return matches;
}

// Return an array of Price managed objects for the tickers (NSString) in the given array, at the given date and from the given managed object context
+ (NSArray *)arrayOfPricesWithTickers:(NSArray *)tickers
                               atDate:(NSDate *)date
             fromManagedObjectContext:(NSManagedObjectContext *)context
{
    // All Prices have date with time at 5:00 or 6:00 vs game dates with time at 00:00. To avoid mistakes from exact comparison when fetching, we create a period from the given date to few hours after.
    NSDate *endPeriodDate = [NSDate dateWithTimeInterval:(60*60*6) sinceDate:date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (ticker in %@)", date, endPeriodDate, tickers];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching Price managed objects from database with array of tickers. %@", [error localizedDescription]);
        return nil;
    } else if ([matches count] == 0){
        NSLog(@"Price fetch from database returned no matches");
    } else if ([matches count] > [tickers count]) {
        NSLog(@"Price fetch from database with array of tickers returned more matches than tickers.");
        return nil;
    } else if ([matches count] < [tickers count]) {
        NSLog(@"Price fetch from database with array of tickers returned less matches than tickers.");
    }
    
    return matches;
}

// Return a dictionary of Price managed objects for the tickers (NSString) in the given array, at the given date and from the given managed object context
// Return nil if the result count is different than the given tickers array count
+ (NSDictionary *)dictionaryOfPricesWithTickers:(NSArray *)tickers
                                         atDate:(NSDate *)date
                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableDictionary *dictionaryOfPrices = [[NSMutableDictionary alloc] init];
    NSArray *arrayOfPrices = [self arrayOfPricesWithTickers:tickers atDate:date fromManagedObjectContext:context];
    
    if (!arrayOfPrices || [arrayOfPrices count] > [tickers count]) return nil;
    
    for (Price *price in arrayOfPrices) {
        [dictionaryOfPrices setObject:price forKey:price.ticker];
    }
    
    return dictionaryOfPrices;
}

// Return a NSArray containing all available Prices from the given Price (Not including the given price). For a maximum number of days (NEGATIVE for previous prices, POSITIVE for subsequent prices). If the paramater ascending is YES, earlier prices are at lower indexes, if it is NO, later prices are given at lower indexes. Return an empty array if no available prices from the fetch. Return nil if a fetch error occur.
+ (NSArray *)arrayOfAvailablePricesFromPrice:(Price *)price OfPreviousPrices:(BOOL)previousPrices forAMaximumNumberOfPrices:(NSUInteger)maxNumber inAscendingOrder:(BOOL)ascending;
{
    if (maxNumber == 0) return @[];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    if (previousPrices) {
        request.predicate = [NSPredicate predicateWithFormat:@"(date < %@) AND (ticker = %@)", price.date, price.ticker];
    } else {
        request.predicate = [NSPredicate predicateWithFormat:@"(date > %@) AND (ticker = %@)", price.date, price.ticker];
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:ascending]];
    request.fetchLimit = maxNumber;
    
    NSError *error;
    NSArray *matches = [price.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching Price managed objects from given price. %@", [error localizedDescription]);
        return nil;
    } else {
        return matches;
    }
}

// Return an array containing all Prices between the new date and the given price date (NOT including the price from the new date, INCLUDING THE GIVEN PRICE). Return empty array if not prices available from fetch or if time difference is 0. Return nil if error at fetching. If ascendingOrder is set to YES, the earlier dates are located at lower indexes
+ (NSArray *)arrayOfPricesBetweenDateWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days andDateFromPrice:(Price *)price inAscendingOrder:(BOOL)ascendingOrder
{
    if (!price) return nil;
    
    NSDate *newDate = [self dateWithTimeDifferenceinYears:years months:months days:days hours:0 fromDate:price.date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    if ([price.date timeIntervalSinceDate:newDate] == 0) return @[];

    NSDate *firstDate;
    NSDate *lastDate;
    // -5 and +12 hours to exclude. Prices exact time is 6:00 or 5:00.
    if ([price.date timeIntervalSinceDate:newDate] < 0) {
        firstDate = [NSDate dateWithTimeInterval:(60*60*12) sinceDate:price.date];
        lastDate = [NSDate dateWithTimeInterval:-(60*60*5) sinceDate:newDate];
    } else {
        firstDate = [NSDate dateWithTimeInterval:(60*60*12) sinceDate:newDate];
        lastDate = [NSDate dateWithTimeInterval:-(60*60*5) sinceDate:price.date];
    }
    
    request.predicate = [NSPredicate predicateWithFormat:@"(date > %@) AND (date < %@) AND (ticker = %@)", firstDate, lastDate, price.ticker];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:ascendingOrder]];
    
    NSError *error;
    NSArray *matches = [price.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching prices from price date to date with time difference. %@", [error localizedDescription]);
        return nil;
    } else if ([matches count] == 0) {
        // return empty array. Not even including the given price
        return @[];
    }
    
    if ([price.date timeIntervalSinceDate:newDate] < 0) {
        // price.date is earlier than newDate
        if (ascendingOrder) {
            matches = [@[price] arrayByAddingObjectsFromArray:matches];
        } else {
            matches = [matches arrayByAddingObject:price];
        }
    } else {
        // newDate is earlier than price.date
        if (ascendingOrder) {
            matches = [matches arrayByAddingObject:price];
        } else {
            matches = [@[price] arrayByAddingObjectsFromArray:matches];
        }
    }
    
    return matches;
}

// Return the Price corresponding to the date with the given time difference. If no price available, it returns the closest Price available after the date with the time difference. If no Price is available return nil. Negative parameters to get previous prices.
+ (Price *)priceWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days fromPrice:(Price *)price roundingToLaterPrice:(BOOL)roundToLaterPrice;
{
    NSDate *date = [self dateWithTimeDifferenceinYears:years months:months days:days hours:0 fromDate:price.date];
    BOOL ascendingOrder;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    
    if (roundToLaterPrice) {
        // -5 hours to avoid exact time check that could miss the target Price. Prices exact time is 6:00 or 5:00
        NSDate *dateToFetch = [NSDate dateWithTimeInterval:-(60*60*5) sinceDate:date];
        request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (ticker = %@)", dateToFetch, price.ticker];
        ascendingOrder = YES;
    } else { // round to earlier Price
        // +12 hours to avoid exact time check that could miss the target Price. Prices exact time is 6:00 or 5:00
        NSDate *dateToFetch = [NSDate dateWithTimeInterval:(60*60*12) sinceDate:date];
        request.predicate = [NSPredicate predicateWithFormat:@"(date <= %@) AND (ticker = %@)", dateToFetch, price.ticker];
        ascendingOrder = NO;
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:roundToLaterPrice]];
    request.fetchLimit = 1;
    
    NSError *error;
    NSArray *matches = [price.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error fetching Price managed object with time difference from given price. %@", [error localizedDescription]);
    } else if ([matches count] == 1) {
        return [matches firstObject];
    }
    
    return nil;
}

// Return a dictionary containing the last consecutive "number" of reports available for each company with the given tickers, at the given date.
// There could be less reports available than the given number contained in the correspondig array in the dictionary
// The latest report is contained at the first index. @{Ticker:@[Report4, Report3...],...}
+ (NSDictionary *)latestAvailableReportsForCompaniesWithTickers:(NSArray *)tickers
                                                         atDate:(NSDate *)date
                                             forNumberOfReports:(NSUInteger)number
                                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *edgarEntityIds = [self arrayOfEdgarEntityIdsForCompaniesWithTickers:tickers fromManagedObjectContext:context];
    NSDate *endDate = [NSDate dateWithTimeInterval:(60*60*12) sinceDate:date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Report"];
    request.predicate = [NSPredicate predicateWithFormat:@"(filingDate <= %@) AND (edgarEntityId IN %@)", endDate, edgarEntityIds];
    NSSortDescriptor *tickerSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"edgarEntityId" ascending:YES];
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"filingDate" ascending:NO];
    request.sortDescriptors = @[tickerSortDescriptor, dateSortDescriptor];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error) {
        NSLog(@"Error Fetching Latest Available Reports from FinancialDatabaseManager. %@", [error localizedDescription]);
        return nil;
    } else if (![matches count]) {
        NSLog(@"No results from Latest Available Reports from FinancialDatabaseManager");
        return nil;
    } else {
        // Create Dictionary with ticker as key and an Array of Reports as value
        NSMutableDictionary *reports = [[NSMutableDictionary alloc] init];
        for (Report *report in matches) {
            NSString *ticker = report.company.ticker;
            NSMutableArray *companyReports = reports[ticker];
            if (!companyReports) {
                companyReports = [[NSMutableArray alloc] init];
                [reports setObject:companyReports forKey:ticker];
            }
            [reports[ticker] addObject:report];
        }
        // Sort the Reports in the array by date, and take only the number asked
        for (NSString *ticker in tickers) { // Dont use dictionary iteration because elements will be modified
            NSArray *companyReports = reports[ticker];
            if (companyReports) {
                NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.filingDate" ascending:NO];
                companyReports = [companyReports sortedArrayUsingDescriptors:@[dateSortDescriptor]];
                if ([companyReports count] > number) {
                    NSArray *companyReportsCorrectSize = [companyReports subarrayWithRange:NSMakeRange(0, number)];
                    reports[ticker] = companyReportsCorrectSize;
                }
            }
        }
        
        return reports;
    }
}


#pragma mark - Fetching Helper Methods

// Return a NSDate corresponding to the given time difference from the given date. (Negative numbers to get previous dates). (Uses a Gregorian calendar)
+ (NSDate *)dateWithTimeDifferenceinYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days hours:(NSInteger)hours fromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:years];
    [comps setMonth:months];
    [comps setDay:days];
    [comps setHour:hours];
    
    return [gregorian dateByAddingComponents:comps toDate:date options:0];
}

// Return an array containing double edgarEntityId for each of the tickers in the given array
// This method could be removed if Report object had ticker attribute.
+ (NSArray *)arrayOfEdgarEntityIdsForCompaniesWithTickers:(NSArray *)tickers
                                 fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *edgarEntityIds = [[NSMutableArray alloc] init];
    
    NSArray *companies = [self arrayOfCompaniesWithTickers:tickers fromManagedObjectContext:context];
    for (Company *company in companies) {
        [edgarEntityIds addObject:company.edgarEntityId];
    }
    
    return edgarEntityIds;
}

// Return true if there are Price managed objects available for the given date (false otherwise). Weekends and bank holidays have no available Prices.
+ (BOOL)arePricesAvailableForDate:(NSDate *)date fromScenario:(Scenario *)scenario
{
    NSArray *scenarioTickers = [scenario.companyTickersStr componentsSeparatedByString:@","];
    NSArray *prices = [self arrayOfPricesWithTickers:scenarioTickers atDate:date fromManagedObjectContext:scenario.managedObjectContext];
    
    if (prices) {
        return [prices count] > 0;
    }
    
    return false;
}

#pragma mark - All Companies, one Ratio.

// Return a NSDictionary with the ticker as the key for the value for the sorting value identifier for each company. Only the companies with valid values are included in the dictionary
+ (NSDictionary *)dictionaryOfSortingValuesWithPrices:(NSDictionary *)prices
                                                atDate:(NSDate *)date
                            withSortingValueIdentifier:(NSString *)identifier
                              fromManagedObjectContext:(NSManagedObjectContext *)context
{
    if (!prices || !date || !identifier || !context) return nil;
    
    NSDictionary *sortingValues = nil;
    
    if ([identifier isEqualToString:FinancialRatioROA]) {
        sortingValues = [self dictionaryOfReturnOnAssetsRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioROE]) {
        sortingValues = [self dictionaryOfReturnOnEquityRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioPriceSales]) {
        sortingValues = [self dictionaryOfPriceSalesRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioPriceEarnings]) {
        sortingValues = [self dictionaryOfPriceEarningsRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioDividendYield]) {
        sortingValues = [self dictionaryOfDividendYieldOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioDividendPayout]) {
        sortingValues = [self dictionaryOfDividendPayoutRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioDebtEquity]) {
        sortingValues = [self dictionaryOfDebtEquityRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioPriceBook]) {
        sortingValues = [self dictionaryOfPriceBookRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioCurrentRatio]) {
        sortingValues = [self dictionaryOfCurrentRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioQuickRatio]) {
        sortingValues = [self dictionaryOfQuickRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioCashRatio]) {
        sortingValues = [self dictionaryOfCashRatioOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioGrossMargin]) {
        sortingValues = [self dictionaryOfGrossProfitMarginOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioEBITDAMargin]) {
        sortingValues = [self dictionaryOfEBITDAMarginOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioOperatingMargin]) {
        sortingValues = [self dictionaryOfOperatingMarginOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioEffectiveTaxRate]) {
        sortingValues = [self dictionaryOfEffectiveTaxRateOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioProfitMargin]) {
        sortingValues = [self dictionaryOfProfitMarginOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    } else if ([identifier isEqualToString:FinancialRatioFinancialLeverage]) {
        sortingValues = [self dictionaryOfFinancialLeverageOfCompaniesWithPrices:prices atDate:date fromManagedObjectContext:context];
    }

    
    return sortingValues;
}

// Return dictionary with available RETURN ON ASSETS ratios for the companies of the given prices. USE 4 QUARTER
// Use 4 reports assets average.
+ (NSDictionary *)dictionaryOfReturnOnAssetsRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                                atDate:(NSDate *)date
                                              fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *returnOnAssetsRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        if (reports) {
            NSNumber *returnOnAssetsRatioNumber = [self returnOnAssetsRatioFromReports:reports];
            if (returnOnAssetsRatioNumber) {
                [returnOnAssetsRatios setObject:returnOnAssetsRatioNumber forKey:ticker];
            }
        }
    }
    
    return returnOnAssetsRatios;
}

// Return dictionary with available RETURN ON EQUITY ratios for the companies of the given prices. USE 4 QUARTER
// Use 4 reports equity average.
+ (NSDictionary *)dictionaryOfReturnOnEquityRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                                atDate:(NSDate *)date
                                              fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *returnOnEquityRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        if (reports) {
            NSNumber *returnOnEquityRatioNumber = [self returnOnEquityRatioFromReports:reports];
            if (returnOnEquityRatioNumber) {
                [returnOnEquityRatios setObject:returnOnEquityRatioNumber forKey:ticker];
            }
        }
    }
    
    return returnOnEquityRatios;
}

// Return dictionary with available PRICE/EARNINGS ratios for the companies of the given prices. USE 4 QUARTERS
+ (NSDictionary *)dictionaryOfPriceEarningsRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                            atDate:(NSDate *)date
                                          fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *priceEarningsRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        Price *price = prices[ticker];
        if (reports && price) {
            NSNumber *priceEarningsRatioNumber = [self priceEarningsRatioFromReports:reports withPrice:price];
            if (priceEarningsRatioNumber) {
                [priceEarningsRatios setObject:priceEarningsRatioNumber forKey:ticker];
            }
        }
    }
    
    return priceEarningsRatios;
}

// Return dictionary with available PRICE/SALES ratios for the companies of the given prices. USE 4 REPORTS
+ (NSDictionary *)dictionaryOfPriceSalesRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                             atDate:(NSDate *)date
                                           fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *priceSalesRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        Price *price = prices[ticker];
        if (reports && price) {
            NSNumber *priceSalesRatioNumber = [self priceSalesRatioFromReports:reports withPrice:price];
            if (priceSalesRatioNumber) {
                [priceSalesRatios setObject:priceSalesRatioNumber forKey:ticker];
            }
        }
    }
    
    return priceSalesRatios;
}

// Return dictionary with available DIVIDEND YIELD ratios for the companies of the given prices. USE 4 REPORTS
+ (NSDictionary *)dictionaryOfDividendYieldOfCompaniesWithPrices:(NSDictionary *)prices
                                                          atDate:(NSDate *)date
                                        fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *dividendYields = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        Price *price = prices[ticker];
        if (reports && price) {
            NSNumber *dividendYieldNumber = [self dividendYieldFromReports:reports withPrice:price];
            if (dividendYieldNumber) {
                [dividendYields setObject:dividendYieldNumber forKey:ticker];
            }
        }
    }
    
    return dividendYields;
}

// Return dictionary with available DIVIDEND PAYOUT RATIOS for the companies of the given prices. USE 4 REPORTS
+ (NSDictionary *)dictionaryOfDividendPayoutRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                                atDate:(NSDate *)date
                                              fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    
    NSMutableDictionary *dividendPayoutRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        NSArray *reports = companiesReports[ticker];
        Price *price = prices[ticker];
        if (reports && price) {
            NSNumber *dividendPayoutRatioNumber = [self dividendPayoutRatioFromReports:reports];
            if (dividendPayoutRatioNumber) {
                [dividendPayoutRatios setObject:dividendPayoutRatioNumber forKey:ticker];
            }
        }
    }
    
    return dividendPayoutRatios;
}

// Return dictionary with available DEBT/EQUITY ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfDebtEquityRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                            atDate:(NSDate *)date
                                          fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *debtEquityRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *debtEquityRatioNumber = [self debtEquityRatioFromReport:report];
            if (debtEquityRatioNumber) {
                [debtEquityRatios setObject:debtEquityRatioNumber forKey:ticker];
            }
        }
    }
    
    return debtEquityRatios;
}

// Return dictionary with available PRICE/BOOK ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfPriceBookRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                           atDate:(NSDate *)date
                                         fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *priceBookRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        Price *price = prices[ticker];
        if (report && price) {
            NSNumber *priceBookRatioNumber = [self priceBookRatioFromReport:report withPrice:price];
            if (priceBookRatioNumber) {
                [priceBookRatios setObject:priceBookRatioNumber forKey:ticker];
            }
        }
    }
    
    return priceBookRatios;
}

// Return dictionary with available CURRENT RATIO ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfCurrentRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                         atDate:(NSDate *)date
                                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *currentRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *currentRatioNumber = [self currentRatioFromReport:report];
            if (currentRatioNumber) {
                [currentRatios setObject:currentRatioNumber forKey:ticker];
            }
        }
    }
    
    return currentRatios;
}

// Return dictionary with available QUICK RATIO ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfQuickRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                         atDate:(NSDate *)date
                                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *quickRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *quickRatioNumber = [self quickRatioFromReport:report];
            if (quickRatioNumber) {
                [quickRatios setObject:quickRatioNumber forKey:ticker];
            }
        }
    }
    
    return quickRatios;
}

// Return dictionary with available CASH RATIO ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfCashRatioOfCompaniesWithPrices:(NSDictionary *)prices
                                                       atDate:(NSDate *)date
                                     fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *cashRatios = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *cashRatioNumber = [self cashRatioFromReport:report];
            if (cashRatioNumber) {
                [cashRatios setObject:cashRatioNumber forKey:ticker];
            }
        }
    }
    
    return cashRatios;
}

// Return dictionary with available GROSS PROFIT MARGIN ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfGrossProfitMarginOfCompaniesWithPrices:(NSDictionary *)prices
                                                              atDate:(NSDate *)date
                                            fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *grossProfitMargins = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *grossProfitMarginNumber = [self grossProfitMarginFromReport:report];
            if (grossProfitMarginNumber) {
                [grossProfitMargins setObject:grossProfitMarginNumber forKey:ticker];
            }
        }
    }
    
    return grossProfitMargins;
}

// Return dictionary with available EBITDA MARGIN ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfEBITDAMarginOfCompaniesWithPrices:(NSDictionary *)prices
                                                              atDate:(NSDate *)date
                                            fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *EBITDAMargins = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *EBITDAMarginNumber = [self EBITDAMarginFromReport:report];
            if (EBITDAMarginNumber) {
                [EBITDAMargins setObject:EBITDAMarginNumber forKey:ticker];
            }
        }
    }
    
    return EBITDAMargins;
}

// Return dictionary with available OPERATING MARGIN ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfOperatingMarginOfCompaniesWithPrices:(NSDictionary *)prices
                                                         atDate:(NSDate *)date
                                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *operatingMargins = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *operatingMarginNumber = [self operatingMarginFromReport:report];
            if (operatingMarginNumber) {
                [operatingMargins setObject:operatingMarginNumber forKey:ticker];
            }
        }
    }
    
    return operatingMargins;
}

// Return dictionary with available EFFECTIVE TAX RATE ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfEffectiveTaxRateOfCompaniesWithPrices:(NSDictionary *)prices
                                                             atDate:(NSDate *)date
                                           fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    NSMutableDictionary *effectiveTaxRates = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *effectiveTaxRateNumber = [self effectiveTaxRateFromReport:report];
            if (effectiveTaxRateNumber) {
                [effectiveTaxRates setObject:effectiveTaxRateNumber forKey:ticker];
            }
        }
    }
    
    return effectiveTaxRates;
}

// Return dictionary with available PROFIT MARGIN ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfProfitMarginOfCompaniesWithPrices:(NSDictionary *)prices
                                                            atDate:(NSDate *)date
                                          fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *profitMargins = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *profitMarginNumber = [self profitMarginFromReport:report];
            if (profitMarginNumber) {
                [profitMargins setObject:profitMarginNumber forKey:ticker];
            }
        }
    }
    
    return profitMargins;
}

// Return dictionary with available FINANCIAL LEVERAGE ratios for the companies of the given prices. USE 1 QUARTER
+ (NSDictionary *)dictionaryOfFinancialLeverageOfCompaniesWithPrices:(NSDictionary *)prices
                                                         atDate:(NSDate *)date
                                       fromManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *tickers = [prices allKeys];
    NSDictionary *companiesReports = [self latestAvailableReportsForCompaniesWithTickers:tickers atDate:date forNumberOfReports:1 fromManagedObjectContext:context];
    
    NSMutableDictionary *financialLeverages = [[NSMutableDictionary alloc] init];
    for (NSString *ticker in companiesReports) {
        Report *report = [companiesReports[ticker] firstObject];
        if (report) {
            NSNumber *financialLeverageNumber = [self financialLeverageFromReport:report];
            if (financialLeverageNumber) {
                [financialLeverages setObject:financialLeverageNumber forKey:ticker];
            }
        }
    }
    
    return financialLeverages;
}


#pragma mark - One Company, All Ratios.

// Return a NSDictionary with the ratio identifier as the key for the ratio value for the given Company. Only the ratios with valid values are included in the dictionary
+ (NSDictionary *)dictionaryOfRatioValuesForCompanyWithPrice:(Price *)price
                                       withRatiosIdentifiers:(NSArray *)identifiers
                                    fromManagedObjectContext:(NSManagedObjectContext *)context
{
    if (!price || !identifiers) return nil;
    // if given managed object context is invalid. We try to get it from Price managed object:
    if (!context) {
        context = price.managedObjectContext;
        if (!context) return nil;
    }

    NSMutableDictionary *companyRatios = nil;

    NSDate *date = price.date;
    NSString *ticker = price.ticker;
    
    NSDictionary *reportsDictionary = [self latestAvailableReportsForCompaniesWithTickers:@[ticker] atDate:date forNumberOfReports:4 fromManagedObjectContext:context];
    NSArray *reports = reportsDictionary[ticker];
    Report *report = [reports firstObject]; // Latest report is first item in the array.
    
    if (report) {
        companyRatios = [[NSMutableDictionary alloc] init];
        for (NSString *identifier in identifiers) {
            NSNumber *ratioNumber = nil;
            if ([identifier isEqualToString:FinancialRatioROA]) {
                ratioNumber = [self returnOnAssetsRatioFromReports:reports];
            } else if ([identifier isEqualToString:FinancialRatioROE]) {
                ratioNumber = [self returnOnEquityRatioFromReports:reports];
            } else if ([identifier isEqualToString:FinancialRatioPriceEarnings]) {
                ratioNumber = [self priceEarningsRatioFromReports:reports withPrice:price];
            } else if ([identifier isEqualToString:FinancialRatioPriceSales]) {
                ratioNumber = [self priceSalesRatioFromReports:reports withPrice:price];
            } else if ([identifier isEqualToString:FinancialRatioDividendYield]) {
                ratioNumber = [self dividendYieldFromReports:reports withPrice:price];
            } else if ([identifier isEqualToString:FinancialRatioDividendPayout]) {
                ratioNumber = [self dividendPayoutRatioFromReports:reports];
            } else if ([identifier isEqualToString:FinancialRatioDebtEquity]) {
                ratioNumber = [self debtEquityRatioFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioPriceBook]) {
                ratioNumber = [self priceBookRatioFromReport:report withPrice:price];
            } else if ([identifier isEqualToString:FinancialRatioCurrentRatio]) {
                ratioNumber = [self currentRatioFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioQuickRatio]) {
                ratioNumber = [self quickRatioFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioCashRatio]) {
                ratioNumber = [self cashRatioFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioGrossMargin]) {
                ratioNumber = [self grossProfitMarginFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioEBITDAMargin]) {
                ratioNumber = [self EBITDAMarginFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioOperatingMargin]) {
                ratioNumber = [self operatingMarginFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioEffectiveTaxRate]) {
                ratioNumber = [self effectiveTaxRateFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioProfitMargin]) {
                ratioNumber = [self profitMarginFromReport:report];
            } else if ([identifier isEqualToString:FinancialRatioFinancialLeverage]) {
                ratioNumber = [self financialLeverageFromReport:report];
            }
            if (ratioNumber) {
                [companyRatios setObject:ratioNumber forKey:identifier];
            }
        }
    }
    
    return companyRatios;
}


#pragma mark - One Company, one Ratio.

// Return an NSNumber with the double of the RETURN ON ASSETS RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)returnOnAssetsRatioFromReports:(NSArray *)reports
{
    NSNumber *returnOnAssetsRatioNumber = nil;
    
    if ([reports count] == 4) {
        double annualNetIncome = 0;
        double assetsSum = 0;
        for (Report *report in reports) {
            NSNumber *reportNetIncomeNumber = report.incomeStatement.netIncomeApplicableToCommon;
            NSNumber *reportAssetsNumber = report.balanceSheet.totalAssets;
            if (reportNetIncomeNumber && reportAssetsNumber) {
                annualNetIncome += [reportNetIncomeNumber doubleValue];
                assetsSum += [reportAssetsNumber doubleValue];
            } else {
                return nil;
            }
        }
        double assetsAnnualAverage = assetsSum / 4;
        double returnOnAssetsRatio = annualNetIncome / assetsAnnualAverage;
        returnOnAssetsRatioNumber = [NSNumber numberWithDouble:returnOnAssetsRatio];
    }
    
    return returnOnAssetsRatioNumber;
}

// Return an NSNumber with the double of the RETURN ON EQUITY RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)returnOnEquityRatioFromReports:(NSArray *)reports
{
    NSNumber *returnOnEquityRatioNumber = nil;
    
    if ([reports count] == 4) {
        double annualNetIncome = 0;
        double equitySum = 0;
        for (Report *report in reports) {
            NSNumber *reportNetIncomeNumber = report.incomeStatement.netIncomeApplicableToCommon;
            NSNumber *reportEquityNumber = report.balanceSheet.totalStockholdersEquity;
            if (reportNetIncomeNumber && reportEquityNumber) {
                annualNetIncome += [reportNetIncomeNumber doubleValue];
                equitySum += [reportEquityNumber doubleValue];
            } else {
                return nil;
            }
        }
        double equityAnnualAverage = equitySum / 4;
        double returnOnEquityRatio = annualNetIncome / equityAnnualAverage;
        returnOnEquityRatioNumber = [NSNumber numberWithDouble:returnOnEquityRatio];
    }
    
    return returnOnEquityRatioNumber;
}

// Return an NSNumber with the double of the PRICE/EARNINGS RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)priceEarningsRatioFromReports:(NSArray *)reports withPrice:(Price *)price
{
    NSNumber *priceEarningsRatioNumber = nil;
    
    if ([reports count] == 4) {
        NSNumber *earningsPerShare = [self earningsPerShareFromReports:reports];
        if (price && earningsPerShare) {
            double priceEarningsRatio = [price.price doubleValue] / [earningsPerShare doubleValue];
            priceEarningsRatioNumber = [NSNumber numberWithDouble:priceEarningsRatio];
        }
    }
    
    return priceEarningsRatioNumber;
}

// Return an NSNumber with the double of the PRICE/SALES RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)priceSalesRatioFromReports:(NSArray *)reports withPrice:(Price *)price
{
    NSNumber *priceSalesRatioNumber = nil;
    
    if ([reports count] == 4) {
        NSNumber *salesPerShareNumber = [self salesPerShareFromReports:reports];
        if (price && salesPerShareNumber) {
            priceSalesRatioNumber = @([price.price doubleValue] / [salesPerShareNumber doubleValue]);
        }
    }
    
    return priceSalesRatioNumber;
}

// Return a NSNumber with the double of the DIVIDEND YIELD calculated from the given Report. nil if not a valid value.
+ (NSNumber *)dividendYieldFromReports:(NSArray *)reports withPrice:(Price *)price
{
    NSNumber *dividendYieldNumber = nil;
    
    if ([reports count] == 4) {
        NSNumber *dividendsPerShareNumber = [self dividendsPerShareFromReports:reports];
        if (price && dividendsPerShareNumber) {
            dividendYieldNumber = @([dividendsPerShareNumber doubleValue] / [price.price doubleValue]);
        }
    }
    
    return dividendYieldNumber;
}

+ (NSNumber *)dividendPayoutRatioFromReports:(NSArray *)reports
{
    NSNumber *dividendPayoutRatioNumber = nil;
    
    if ([reports count] == 4) {
        NSNumber *dividendsPerShareNumber = [self dividendsPerShareFromReports:reports];
        NSNumber *earningsPerShareNumber = [self earningsPerShareFromReports:reports];
        if (dividendsPerShareNumber && earningsPerShareNumber) {
            dividendPayoutRatioNumber = @([dividendsPerShareNumber doubleValue] / [earningsPerShareNumber doubleValue]);
        }
    }
    
    return dividendPayoutRatioNumber;
}


// Return an NSNumber with the double of the DEBT/EQUITY RATIO calculated from the given Report. nil if not a valid value.
// A measure of a company's financial leverage calculated by dividing its total liabilities by stockholders' equity.
+ (NSNumber *)debtEquityRatioFromReport:(Report *)report
{
    NSNumber *debtEquityRatioNumber = nil;
    
    NSNumber *debtNumber = report.balanceSheet.totalDebt;
    NSNumber *equityNumber = report.balanceSheet.totalStockholdersEquity;
    if (debtNumber && equityNumber) {
        double debt = [debtNumber doubleValue];
        double equity = [equityNumber doubleValue];
        double debtEquityRatio = debt / equity;
        debtEquityRatioNumber = [NSNumber numberWithDouble:debtEquityRatio];
    }
    
    return debtEquityRatioNumber;
}

// Return an NSNumber with the double of the PRICE BOOK RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)priceBookRatioFromReport:(Report *)report withPrice:(Price *)price
{
    NSNumber *priceBookRatioNumber = nil;
    
    NSNumber *bookValuePerShare = [self bookValuePerShareFromReport:report];
    if (price && bookValuePerShare) {
        double priceBookRatio = [price.price doubleValue] / [bookValuePerShare doubleValue];
        priceBookRatioNumber = [NSNumber numberWithDouble:priceBookRatio];
    }
    
    return priceBookRatioNumber;
}

// Return an NSNumber with the double of the CURRENT RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)currentRatioFromReport:(Report *)report
{
    NSNumber *currentRatioNumber = nil;
    
    NSNumber *currentAssetsNumber = [self currentAssetsFromReport:report];
    
    NSNumber *currentLiabilitiesNumber = [self currentLiabilitiesFromReport:report];
    
    
    if (currentAssetsNumber && currentLiabilitiesNumber) {
        double currentRatio = [currentAssetsNumber doubleValue] / [currentLiabilitiesNumber doubleValue];
        currentRatioNumber = [NSNumber numberWithDouble:currentRatio];
    }
    
    return currentRatioNumber;
}

// Return an NSNumber with the double of the QUICK RATIO calculated from the given Report. nil if not a valid value.
// The quick ratio measures the dollar amount of liquid assets available for each dollar of current liabilities.
+ (NSNumber *)quickRatioFromReport:(Report *)report
{
    NSNumber *quickRatioNumber = nil;
    
    NSNumber *liquidAssetsNumber = [self liquidAssetsFromReport:report];
    NSNumber *currentLiabilitiesNumber = [self currentLiabilitiesFromReport:report];
    
    if (liquidAssetsNumber && currentLiabilitiesNumber) {
        double currentLiabilities = [currentLiabilitiesNumber doubleValue];
        if (currentLiabilities != 0) {
            quickRatioNumber = @([liquidAssetsNumber doubleValue] / currentLiabilities);
        }
    }
    
    return quickRatioNumber;
}

// Return an NSNumber with the double of the CASH RATIO calculated from the given Report. nil if not a valid value.
+ (NSNumber *)cashRatioFromReport:(Report *)report
{
    NSNumber *cashRatioNumber = nil;
    
    NSNumber *cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashCashEquivalentsAndShortTermInvestments;
    if (!cashCashEquivalentAndShortTermInvestmentsNumber) { // If cash and cash equivalent and short term investments not available, use only cash and cash equivalents
        cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashAndCashEquivalents;
    }
    
    NSNumber *currentLiabilitiesNumber = [self currentLiabilitiesFromReport:report];
    
    if (cashCashEquivalentAndShortTermInvestmentsNumber && currentLiabilitiesNumber) {
        double cashRatio = [cashCashEquivalentAndShortTermInvestmentsNumber doubleValue] / [currentLiabilitiesNumber doubleValue];
        cashRatioNumber = @(cashRatio);
    }
    
    return cashRatioNumber;
}

// Return an NSNumber with the double of the GROSS PROFIT MARGIN calculated from the given Report. nil if not a valid value.
+ (NSNumber *)grossProfitMarginFromReport:(Report *)report
{
    NSNumber *grossProfitMarginNumber = nil;
    
    NSNumber *revenueNumber = report.incomeStatement.totalRevenue;
    
    NSNumber *grossProfitNumber = report.incomeStatement.grossProfit;
    if (!grossProfitNumber && revenueNumber) {
        NSNumber *costOfRevenueNumber = report.incomeStatement.costOfRevenue;
        if (costOfRevenueNumber) {
             grossProfitNumber = @([revenueNumber doubleValue] - [costOfRevenueNumber doubleValue]);
        }
    }
    
    if (revenueNumber && grossProfitNumber) {
        double grossProfitMargin = [grossProfitNumber doubleValue] / [revenueNumber doubleValue];
        grossProfitMarginNumber = @(grossProfitMargin);
    }
    
    return grossProfitMarginNumber;
}

// Return an NSNumber with the double of the EBITDA MARGIN calculated from the given Report. nil if not a valid value.
+ (NSNumber *)EBITDAMarginFromReport:(Report *)report
{
    NSNumber *EBITDAMarginNumber = nil;
    
    NSNumber *revenueNumber = report.incomeStatement.totalRevenue;
    NSNumber *totalOperatingExpensesNumber = report.incomeStatement.totalOperatingExpenses;
    NSNumber *depreciationAndAmortizationNumber = report.cashFlow.cfDepreciationAmortization;
    if (revenueNumber && totalOperatingExpensesNumber && depreciationAndAmortizationNumber) {
        double revenue = [revenueNumber doubleValue];
        double EBITDAMargin = (revenue - [totalOperatingExpensesNumber doubleValue] + [depreciationAndAmortizationNumber doubleValue]) / revenue;
        EBITDAMarginNumber = [NSNumber numberWithDouble:EBITDAMargin];
    }
    
    return EBITDAMarginNumber;
}

// Return an NSNumber with the double of the OPERATING MARGIN calculated from the given Report. nil if not a valid value.
+ (NSNumber *)operatingMarginFromReport:(Report *)report
{
    NSNumber *operatingMarginNumber = nil;
    
    NSNumber *revenueNumber = report.incomeStatement.totalRevenue;
    NSNumber *totalOperatingExpensesNumber = report.incomeStatement.totalOperatingExpenses;
    if (revenueNumber && totalOperatingExpensesNumber) {
        double revenue = [revenueNumber doubleValue];
        double operatingMargin = (revenue - [totalOperatingExpensesNumber doubleValue]) / revenue;
        operatingMarginNumber = [NSNumber numberWithDouble:operatingMargin];
    }
    
    return operatingMarginNumber;
}

// Return an NSNumber with the double of the EFFECTIVE TAX RATE
+ (NSNumber *)effectiveTaxRateFromReport:(Report *)report
{
    NSNumber *effectiveTaxRateNumber = nil;
    
    NSNumber *incomeBeforeTaxesNumber = report.incomeStatement.incomeBeforeTaxes;
    NSNumber *incomeTaxExpenseNumber = [self incomeTaxExpenseFromReport:report];
    
    if (incomeBeforeTaxesNumber && incomeTaxExpenseNumber) {
        effectiveTaxRateNumber = @([incomeTaxExpenseNumber doubleValue] / [incomeBeforeTaxesNumber doubleValue]);
    }
    
    return effectiveTaxRateNumber;
}

// Return an NSNumber with the double of the PROFIT MARGIN calculated from the given Report. nil if not a valid value.
+ (NSNumber *)profitMarginFromReport:(Report *)report
{
    NSNumber *profitMarginNumber = nil;
    
    NSNumber *revenueNumber = report.incomeStatement.totalRevenue;
    NSNumber *netIncomeNumber = report.incomeStatement.netIncomeApplicableToCommon;
    if (revenueNumber && netIncomeNumber) {
        double profitMargin = [netIncomeNumber doubleValue] / [revenueNumber doubleValue];
        profitMarginNumber = [NSNumber numberWithDouble:profitMargin];
    }
    
    return profitMarginNumber;
}

// Return an NSNumber with the double of the FINANCIAL LEVERAGE calculated from the given Report. nil if not a valid value.
+ (NSNumber *)financialLeverageFromReport:(Report *)report
{
    NSNumber *financialLeverageNumber = nil;
    
    NSNumber *assetsNumber = report.balanceSheet.totalAssets;
    NSNumber *equityNumber = report.balanceSheet.totalStockholdersEquity;
    if (assetsNumber && equityNumber) {
        double financialLeverage = [assetsNumber doubleValue] / [equityNumber doubleValue];
        financialLeverageNumber = [NSNumber numberWithDouble:financialLeverage];
    }
    
    return financialLeverageNumber;
}

// Return an NSNumber with the double of the EARNINGS PER SHARE calculated from the given Reports. nil if not a valid value.
+ (NSNumber *)earningsPerShareFromReports:(NSArray *)reports
{
    NSNumber *earningsPerShareNumber = nil;

    if ([reports count] == 4) {
        double annualNetIncome = 0;
        double reportsSharesSum = 0;
        
        for (Report *report in reports) {
            NSNumber *reportNetIncomeNumber = report.incomeStatement.netIncomeApplicableToCommon;
            NSNumber *reportSharesNumber = report.outstandingShares;
            if (reportNetIncomeNumber && reportSharesNumber) {
                annualNetIncome += [reportNetIncomeNumber doubleValue];
                reportsSharesSum += [reportSharesNumber doubleValue];
            } else {
                return nil;
            }
        }
        
        double averageShares = reportsSharesSum / 4;
        
        if (averageShares > 0) {
            double earningsPerShare = annualNetIncome / averageShares;
            earningsPerShareNumber = [NSNumber numberWithDouble:earningsPerShare];
        }
    }
    
    return earningsPerShareNumber;
}


// Return an NSNumber with the double of the SALES PER SHARE calculated from the given Reports. nil if not a valid value.
+ (NSNumber *)salesPerShareFromReports:(NSArray *)reports
{
    NSNumber *salesPerShareNumber = nil;
    
    if ([reports count] == 4) {
        double annualRevenue = 0;
        double reportsSharesSum = 0;
        
        for (Report *report in reports) {
            NSNumber *reportRevenueNumber = report.incomeStatement.totalRevenue;
            NSNumber *reportSharesNumber = report.outstandingShares;
            if (reportRevenueNumber && reportSharesNumber) {
                annualRevenue += [reportRevenueNumber doubleValue];
                reportsSharesSum += [reportSharesNumber doubleValue];
            } else {
                return nil;
            }
        }
        
        double averageShares = reportsSharesSum / 4;
        
        if (averageShares > 0) {
            salesPerShareNumber = @(annualRevenue / averageShares);
        }
    }
    
    return salesPerShareNumber;
}

// Return an NSNumber with the double of the DIVIDENDS PER SHARE calculated from the given Reports. nil if not a valid value.
+ (NSNumber *)dividendsPerShareFromReports:(NSArray *)reports
{
    NSNumber *dividendsPerShareNumber = nil;
    
    if ([reports count] == 4) {
        double annualDividends = 0;
        double reportsSharesSum = 0;
        
        for (Report *report in reports) {
            NSNumber *reportDividendsNumber = report.cashFlow.dividendsPaid;
            NSNumber *reportSharesNumber = report.outstandingShares;
            if (reportSharesNumber) {
                reportsSharesSum += [reportSharesNumber doubleValue];
                if (reportDividendsNumber) annualDividends += [reportDividendsNumber doubleValue];
            } else {
                return nil;
            }
        }
        
        double averageShares = reportsSharesSum / 4;
        
        if (averageShares > 0) {
            dividendsPerShareNumber = @(-annualDividends / averageShares); // Negative because is cash flow
        }
    }
    
    return dividendsPerShareNumber;
}


// Return an NSNumber with the double of the BOOK VALUE PER SHARE calculated from the given Report. nil if not a valid value.
+ (NSNumber *)bookValuePerShareFromReport:(Report *)report
{
    NSNumber *bookValuePerShareNumber = nil;
    
    NSNumber *equityNumber = report.balanceSheet.totalStockholdersEquity;
    NSNumber *sharesNumber = report.outstandingShares;
    
    if (equityNumber && sharesNumber) {
        double equity = [equityNumber doubleValue];
        double shares = [sharesNumber doubleValue];
        if (shares > 0) {
            double bookValuePerShare = equity / shares;
            bookValuePerShareNumber = [NSNumber numberWithDouble:bookValuePerShare];
        }
    }
    
    return bookValuePerShareNumber;
}

#pragma mark - Absolute values from report

/*
 Total Operating Expenses = Cost of Sales + Operating Expenses
 */



+ (NSNumber *)liquidAssetsFromReport:(Report *)report
{
    NSNumber *liquidAssetsNumber = nil;
    
    NSNumber *inventoriesNumber = report.balanceSheet.inventoriesNet;
    NSNumber *currentAssetsNumber = [self currentAssetsFromReport:report];
    
    if (inventoriesNumber && currentAssetsNumber) {
        
        liquidAssetsNumber = @([currentAssetsNumber doubleValue] - [inventoriesNumber doubleValue]);
        
    } else {
        
        NSNumber *cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashCashEquivalentsAndShortTermInvestments;
        if (!cashCashEquivalentAndShortTermInvestmentsNumber) {
            cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashAndCashEquivalents;
        }
        
        NSNumber *accountsReceivableNumber = report.balanceSheet.totalReceivablesNet;
        
        if (cashCashEquivalentAndShortTermInvestmentsNumber || accountsReceivableNumber) {
            
            double liquidAssets = 0;
            if (cashCashEquivalentAndShortTermInvestmentsNumber) liquidAssets += [cashCashEquivalentAndShortTermInvestmentsNumber doubleValue];
            if (accountsReceivableNumber) liquidAssets += [accountsReceivableNumber doubleValue];
            liquidAssetsNumber = @(liquidAssets);
            
        }
    }
    
    return liquidAssetsNumber;
}

+ (NSNumber *)currentAssetsFromReport:(Report *)report
{
    NSNumber *currentAssetsNumber = report.balanceSheet.totalCurrentAssets;
    
    if (!currentAssetsNumber) {
        NSNumber *cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashCashEquivalentsAndShortTermInvestments;
        if (!cashCashEquivalentAndShortTermInvestmentsNumber) {
            cashCashEquivalentAndShortTermInvestmentsNumber = report.balanceSheet.cashAndCashEquivalents;
        }
        NSNumber *totalReceivablesNetNumber = report.balanceSheet.totalReceivablesNet;
        NSNumber *inventoriesNetNumber = report.balanceSheet.inventoriesNet;
        NSNumber *otherCurrentAssets = report.balanceSheet.otherCurrentAssets;
        
        double currentAssets = 0;
        if (cashCashEquivalentAndShortTermInvestmentsNumber) currentAssets += [cashCashEquivalentAndShortTermInvestmentsNumber doubleValue];
        if (totalReceivablesNetNumber) currentAssets += [totalReceivablesNetNumber doubleValue];
        if (inventoriesNetNumber) currentAssets += [inventoriesNetNumber doubleValue];
        if (otherCurrentAssets) currentAssets += [otherCurrentAssets doubleValue];
        
        if (cashCashEquivalentAndShortTermInvestmentsNumber || totalReceivablesNetNumber || inventoriesNetNumber || otherCurrentAssets) {
            currentAssetsNumber = @(currentAssets);
        }
    }
    
    return currentAssetsNumber;
}

+ (NSNumber *)currentLiabilitiesFromReport:(Report *)report
{
    NSNumber *currentLiabilitiesNumber = report.balanceSheet.totalCurrentLiabilities;
    
    if (!currentLiabilitiesNumber) {
        NSNumber *accountsPayableNumber = report.balanceSheet.accountsPayable;
        NSNumber *currentPortionOfLongTermDebtNumber = report.balanceSheet.currentPortionOfLongTermDebt;
        NSNumber *shortTermDebtNumber = report.balanceSheet.totalShortTermDebt;
        NSNumber *otherCurrentLiabilities = report.balanceSheet.otherCurrentLiabilities;
        
        double currentLiabilities = 0;
        if (accountsPayableNumber) currentLiabilities += [accountsPayableNumber doubleValue];
        if (currentPortionOfLongTermDebtNumber) currentLiabilities += [currentPortionOfLongTermDebtNumber doubleValue];
        if (shortTermDebtNumber) currentLiabilities += [shortTermDebtNumber doubleValue];
        if (otherCurrentLiabilities) currentLiabilities += [otherCurrentLiabilities doubleValue];
        
        if (accountsPayableNumber || currentPortionOfLongTermDebtNumber || shortTermDebtNumber || otherCurrentLiabilities) {
            currentLiabilitiesNumber = @(currentLiabilities);
        }
    }
    
    return currentLiabilitiesNumber;
}

+ (NSNumber *)incomeTaxExpenseFromReport:(Report *)report
{
    NSNumber *incomeTaxExpenseNumber = nil;
    
    NSNumber *incomeBeforeTaxNumber = report.incomeStatement.incomeBeforeTaxes;
    
    NSNumber *netIncomeFromContinuingOperationsNumber = report.incomeStatement.netIncomeFromContinuingOperationsApplicableToCommon;
    if (!netIncomeFromContinuingOperationsNumber) {
        // netIncomeFromContinuingOperationsApplicableToCommon is nil. Maybe an error when loading the database. So it needs to be calculated in a different way
        NSNumber *netIncomeApplicableToCommonNumber = report.incomeStatement.netIncomeApplicableToCommon;
        if (netIncomeApplicableToCommonNumber) {
            
            double netIncomeFromContinuingOperations = [netIncomeApplicableToCommonNumber doubleValue];
            
            NSNumber *discontinuedOperationsNumber = report.incomeStatement.discontinuedOperations;
            NSNumber *extraordinaryItemsNumber = report.incomeStatement.extraordinaryItems;
            NSNumber *effectOfAccountingChangesNumber = report.incomeStatement.accountingChange;
            
            if (discontinuedOperationsNumber) netIncomeFromContinuingOperations -= [discontinuedOperationsNumber doubleValue];
            if (extraordinaryItemsNumber) netIncomeFromContinuingOperations -= [extraordinaryItemsNumber doubleValue];
            if (effectOfAccountingChangesNumber) netIncomeFromContinuingOperations -= [effectOfAccountingChangesNumber doubleValue];
            
            netIncomeFromContinuingOperationsNumber = @(netIncomeFromContinuingOperations);
        }
        
    }
    
    if (netIncomeFromContinuingOperationsNumber && incomeBeforeTaxNumber) {
        incomeTaxExpenseNumber = @([incomeBeforeTaxNumber doubleValue] - [netIncomeFromContinuingOperationsNumber doubleValue]);
    }
    
    return incomeTaxExpenseNumber;
}


















@end

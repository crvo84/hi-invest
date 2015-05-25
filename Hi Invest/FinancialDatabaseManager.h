//
//  FinancialDatabaseManager.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Scenario;
@class Price;

@interface FinancialDatabaseManager : NSObject


//------------/
/* FETCHING */
//----------/

+ (NSArray *)arrayOfCompaniesWithTickers:(NSArray *)tickers
                fromManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSArray *)arrayOfPricesWithTickers:(NSArray *)tickers
                               atDate:(NSDate *)date
             fromManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSDictionary *)dictionaryOfPricesWithTickers:(NSArray *)tickers
                                         atDate:(NSDate *)date
                       fromManagedObjectContext:(NSManagedObjectContext *)context;

// Return a NSArray containing all available consecutive Prices from the given Price (NOT including the given price). For a given maximum number of Prices (Previous or subsequent prices depending of given BOOL previousPrices). If ascending, then earlier prices are located in lower indexes, otherwise they are located at higher indexes. Return an empty array if no available prices. Return nil if a fetch error occur.
+ (NSArray *)arrayOfAvailablePricesFromPrice:(Price *)price OfPreviousPrices:(BOOL)previousPrices forAMaximumNumberOfPrices:(NSUInteger)maxNumber inAscendingOrder:(BOOL)ascending;

// Return an array containing all Prices between the new date and the given price date (EXCLUSIVE. NOT including the price from the new date, nor the given Price). Return empty array if not prices available. Return nil if error at fetching. If ascendingOrder is set to YES, the earlier dates are located at lower indexes
+ (NSArray *)arrayOfPricesBetweenDateWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days andDateFromPrice:(Price *)price inAscendingOrder:(BOOL)ascendingOrder;

// Return the Price corresponding to the date with the given time difference. If no price available, it returns the closest Price available after the date with the time difference. If no Price is available return nil
+ (Price *)priceWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days fromPrice:(Price *)price roundingToLaterPrice:(BOOL)roundToLaterPrice;

// Return true if there are Price managed objects available for the given date (false otherwise). Weekends and bank holidays have no available Prices.
+ (BOOL)arePricesAvailableForDate:(NSDate *)date fromScenario:(Scenario *)scenario;

// Return an array containing Dividend objects corresponding from the given initial (including) and final (including) dates. For the given company tickers.
// Sorted by dividend date in ascending order
+ (NSArray *)arrayOfDividendsPaidFromCompaniesWithTickers:(NSArray *)tickers fromDate:(NSDate *)initialDate toDate:(NSDate *)finalDate fromManagedObjectContext:(NSManagedObjectContext *)context;


//--------------------------/
/* FINANCIAL CALCULATIONS */
//------------------------/

// Return a NSDictionary with the ticker as the key, and a NSNumber with a double for the sorting value identifier for each company. Only the companies with valid values are included in the dictionary. (All companies, one identifier)
+ (NSDictionary *)dictionaryOfSortingValuesWithPrices:(NSDictionary *)prices
                                                atDate:(NSDate *)date
                            withSortingValueIdentifier:(NSString *)identifier
                              fromManagedObjectContext:(NSManagedObjectContext *)context;

// Return a NSDictionary with the ratio identifier as the key, and a NSNumber with a double for the ratio value for the given Company. Only the ratios with valid values are included in the dictionary. (One Company, all indentifiers)
+ (NSDictionary *)dictionaryOfRatioValuesForCompanyWithPrice:(Price *)price
                              withRatiosIdentifiers:(NSArray *)identifiers
                           fromManagedObjectContext:(NSManagedObjectContext *)context;


//------------------/
/* HELPER METHODS */
//----------------/

// Return a NSDate corresponding to the given time difference from the given date. (Negative numbers to get previous dates). (Uses a Gregorian calendar)
+ (NSDate *)dateWithTimeDifferenceinYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days hours:(NSInteger)hours fromDate:(NSDate *)date;




@end

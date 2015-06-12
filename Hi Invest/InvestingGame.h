//
//  InvestingGame.h
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/9/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Portfolio.h"
#import "GameInfo.h"

@class Scenario;
@class CompanyDisguiseManager;
@class PortfolioPicture;
@class Price;

@interface InvestingGame : NSObject

@property (strong, nonatomic, readonly) Scenario *scenario;
@property (strong, nonatomic, readonly) GameInfo *gameInfo;
@property (strong, nonatomic, readonly) NSManagedObjectContext *scenarioContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *gameInfoContext;
@property (strong, nonatomic, readonly) Portfolio *portfolio;
@property (strong, nonatomic, readonly) NSArray *tickersOfCompaniesAvailable;
@property (strong, nonatomic, readonly) NSDate *initialDate;
@property (strong, nonatomic, readonly) NSDate *endDate;
@property (strong, nonatomic, readonly) NSDate *currentDate;
@property (strong, nonatomic, readonly) NSDictionary *currentPrices; // @{ticker : Price}
@property (nonatomic, readonly) BOOL disguiseRealNamesAndTickers;
@property (strong, nonatomic, readonly) CompanyDisguiseManager *disguiseManager;
@property (nonatomic) double transactionCommissionRate;
@property (nonatomic, readonly) double initialNetworth;
@property (strong, nonatomic) NSLocale *locale;
@property (nonatomic, readonly) BOOL finishedSuccessfully;

@property (nonatomic) BOOL finalResultsAlreadyRecorded;

// Designated Initializer
- (instancetype)initInvestingGameWithGameInfo:(GameInfo *)gameInfo
                                 withScenario:(Scenario *)scenario;;


// Sets the "current date" as a date with the given time difference from the current "current date"
// If the new date is weekend or bank holiday (no prices available), then the next valid date is set as the new "current date"
// Negative time difference means earlier dates.
// Return YES if the change was made. NO if the change was not made (maybe new date was later than endDate).
- (BOOL)changeCurrentDateToDateWithTimeDifferenceInYears:(NSInteger)years months:(NSInteger)months andDays:(NSInteger)days;

// Set current info (currentDay, currentDate, finished, currentReturn) to GameInfo
- (void)saveInvestingGameCurrentState;

// Return the number of days from the currentDate until the endDate
- (NSInteger)daysLeft;

// Return the current day number. Starting from 1.
- (NSInteger)currentDay;

// Return the day number from the given date
- (NSInteger)dayNumberFromDate:(NSDate *)date;

// Return the current value of portfolio
- (double)currentNetWorth;

- (double)currentPortfolioReturn;
- (double)currentMarketReturn;
- (double)currentPortfolioAnnualizedReturn;
- (double)currentMarketAnnualizedReturn;

// Return the User Interface value for the company of the given ticker. Disguised if neccesary.
- (NSString *)UITickerForTicker:(NSString *)ticker;
- (NSString *)UINameForTicker:(NSString *)ticker;
- (NSUInteger)UIPriceMultiplierForTicker:(NSString *)ticker;

// Return the market price at the given date;
// Return nil if given date is earlier than the initial game date, or later than maximum game date
- (NSNumber *)scenarioMarketPriceAtDate:(NSDate *)date;

// Return an NSDictionary with the ticker as key, and a NSNumber with the double of the weight of that stock in the portfolio (Using current prices) (If array is nil, return info for all companies available from prices)
- (NSDictionary *)weigthInPortfolioOfStocksWithTickers:(NSArray *)tickers;

// Return an NSArray with the ticker of the companies ordered by weight in portfolio with current prices.
- (NSArray *)tickersOfCompaniesInPortfolioOrderedByWeightInDescendingOrder:(BOOL)descendingOrder;

// Return a NSMutableArray of NSDictionary containing Company info: ticker (NSString), price (Price), sortingValue (NSNumber)
// If parameter tickers is nil, return information of all available companies. If parameter sortingValueId is nil, the result wont contain sorting value information. Includes the market average with mkt name as ticker (if apply)
- (NSMutableArray *)informationOfCompanies:(NSArray *)tickers withSortingValueId:(NSString *)sortingValueId;





@end

//
//  GameInfo.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class HistoricalValue, Ticker, Transaction;

@interface GameInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * initialCash;
@property (nonatomic, retain) NSString * scenarioFilename;
@property (nonatomic, retain) NSNumber * disguiseCompanies;
@property (nonatomic, retain) NSDate * currentDate;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSSet *tickers;
@property (nonatomic, retain) NSSet *transactions;
@property (nonatomic, retain) NSSet *historicalValues;
@end

@interface GameInfo (CoreDataGeneratedAccessors)

- (void)addTickersObject:(Ticker *)value;
- (void)removeTickersObject:(Ticker *)value;
- (void)addTickers:(NSSet *)values;
- (void)removeTickers:(NSSet *)values;

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet *)values;
- (void)removeTransactions:(NSSet *)values;

- (void)addHistoricalValuesObject:(HistoricalValue *)value;
- (void)removeHistoricalValuesObject:(HistoricalValue *)value;
- (void)addHistoricalValues:(NSSet *)values;
- (void)removeHistoricalValues:(NSSet *)values;

@end

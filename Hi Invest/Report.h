//
//  Report.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BalanceSheet, CashFlow, Company, IncomeStatement;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSNumber * edgarEntityId;
@property (nonatomic, retain) NSDate * filingDate;
@property (nonatomic, retain) NSNumber * outstandingShares;
@property (nonatomic, retain) NSDate * periodEndDate;
@property (nonatomic, retain) NSString * periodType;
@property (nonatomic, retain) NSNumber * rowNum;
@property (nonatomic, retain) BalanceSheet *balanceSheet;
@property (nonatomic, retain) CashFlow *cashFlow;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) IncomeStatement *incomeStatement;

@end

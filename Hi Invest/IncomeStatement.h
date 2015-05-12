//
//  IncomeStatement.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface IncomeStatement : NSManagedObject

@property (nonatomic, retain) NSNumber * accountingChange;
@property (nonatomic, retain) NSNumber * costOfRevenue;
@property (nonatomic, retain) NSNumber * discontinuedOperations;
@property (nonatomic, retain) NSNumber * ebit;
@property (nonatomic, retain) NSNumber * edgarEntityId;
@property (nonatomic, retain) NSNumber * equityEarnings;
@property (nonatomic, retain) NSNumber * extraordinaryItems;
@property (nonatomic, retain) NSNumber * grossProfit;
@property (nonatomic, retain) NSNumber * incomeBeforeTaxes;
@property (nonatomic, retain) NSNumber * interestExpense;
@property (nonatomic, retain) NSNumber * netIncome;
@property (nonatomic, retain) NSNumber * netIncomeApplicableToCommon;
@property (nonatomic, retain) NSNumber * netIncomeFromContinuingOperationsApplicableToCommon;
@property (nonatomic, retain) NSNumber * noncontrollingInterest;
@property (nonatomic, retain) NSNumber * operatingExpenses;
@property (nonatomic, retain) NSDate * periodEndDate;
@property (nonatomic, retain) NSNumber * researchDevelopmentExpense;
@property (nonatomic, retain) NSNumber * rowNum;
@property (nonatomic, retain) NSNumber * sellingGeneralAdministrativeExpenses;
@property (nonatomic, retain) NSNumber * totalNonoperatingIncomeExpense;
@property (nonatomic, retain) NSNumber * totalOperatingExpenses;
@property (nonatomic, retain) NSNumber * totalRevenue;
@property (nonatomic, retain) Report *report;

@end

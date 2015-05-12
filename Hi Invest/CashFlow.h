//
//  CashFlow.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface CashFlow : NSManagedObject

@property (nonatomic, retain) NSNumber * capitalExpenditures;
@property (nonatomic, retain) NSNumber * cashFromFinancingActivities;
@property (nonatomic, retain) NSNumber * cashFromInvestingActivities;
@property (nonatomic, retain) NSNumber * cashFromOperatingActivities;
@property (nonatomic, retain) NSNumber * cfDepreciationAmortization;
@property (nonatomic, retain) NSNumber * cfNetIncome;
@property (nonatomic, retain) NSNumber * changeInAccountsReceivable;
@property (nonatomic, retain) NSNumber * changeInCurrentAssets;
@property (nonatomic, retain) NSNumber * changeInCurrentLiabilities;
@property (nonatomic, retain) NSNumber * changeInInventories;
@property (nonatomic, retain) NSNumber * dividendsPaid;
@property (nonatomic, retain) NSNumber * edgarEntityId;
@property (nonatomic, retain) NSNumber * effectOfExchangeRateOnCash;
@property (nonatomic, retain) NSNumber * investmentChangesNet;
@property (nonatomic, retain) NSNumber * netChangeInCash;
@property (nonatomic, retain) NSDate * periodEndDate;
@property (nonatomic, retain) NSNumber * rowNum;
@property (nonatomic, retain) NSNumber * totalAdjustments;
@property (nonatomic, retain) Report *report;

@end

//
//  BalanceSheet.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Report;

@interface BalanceSheet : NSManagedObject

@property (nonatomic, retain) NSNumber * accountsPayable;
@property (nonatomic, retain) NSNumber * cashAndCashEquivalents;
@property (nonatomic, retain) NSNumber * cashCashEquivalentsAndShortTermInvestments;
@property (nonatomic, retain) NSNumber * commonStock;
@property (nonatomic, retain) NSNumber * currentPortionOfLongTermDebt;
@property (nonatomic, retain) NSNumber * deferredCharges;
@property (nonatomic, retain) NSNumber * deferredLiabilityCharges;
@property (nonatomic, retain) NSNumber * edgarEntityId;
@property (nonatomic, retain) NSNumber * goodwill;
@property (nonatomic, retain) NSNumber * intangibleAssets;
@property (nonatomic, retain) NSNumber * inventoriesNet;
@property (nonatomic, retain) NSNumber * longTermDebt;
@property (nonatomic, retain) NSNumber * minorityInterest;
@property (nonatomic, retain) NSNumber * otherAssets;
@property (nonatomic, retain) NSNumber * otherCurrentAssets;
@property (nonatomic, retain) NSNumber * otherCurrentLiabilities;
@property (nonatomic, retain) NSNumber * otherEquity;
@property (nonatomic, retain) NSNumber * otherLiabilities;
@property (nonatomic, retain) NSDate * periodEndDate;
@property (nonatomic, retain) NSNumber * preferredStock;
@property (nonatomic, retain) NSNumber * propertyPlantEquipmentNet;
@property (nonatomic, retain) NSNumber * retainedEarnings;
@property (nonatomic, retain) NSNumber * rowNum;
@property (nonatomic, retain) NSNumber * totalAssets;
@property (nonatomic, retain) NSNumber * totalCurrentAssets;
@property (nonatomic, retain) NSNumber * totalCurrentLiabilities;
@property (nonatomic, retain) NSNumber * totalDebt;
@property (nonatomic, retain) NSNumber * totalLiabilities;
@property (nonatomic, retain) NSNumber * totalLongTermAssets;
@property (nonatomic, retain) NSNumber * totalLongTermDebt;
@property (nonatomic, retain) NSNumber * totalLongTermLiabilities;
@property (nonatomic, retain) NSNumber * totalReceivablesNet;
@property (nonatomic, retain) NSNumber * totalShortTermDebt;
@property (nonatomic, retain) NSNumber * totalStockholdersEquity;
@property (nonatomic, retain) NSNumber * treasuryStock;
@property (nonatomic, retain) Report *report;

@end

//
//  Scenario.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Scenario : NSManagedObject

@property (nonatomic, retain) NSString * companyTickersStr;
@property (nonatomic, retain) NSString * descriptionForScenario;
@property (nonatomic, retain) NSDate * endingDataDate;
@property (nonatomic, retain) NSDate * endingScenarioDate;
@property (nonatomic, retain) NSDate * initialDataDate;
@property (nonatomic, retain) NSDate * initialScenarioDate;
@property (nonatomic, retain) NSString * localeStr;
@property (nonatomic, retain) NSString * marketTickersStr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * referenceId;

@end

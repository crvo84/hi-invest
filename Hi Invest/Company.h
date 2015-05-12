//
//  Company.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Price, Report;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSNumber * edgarEntityId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sicCode;
@property (nonatomic, retain) NSString * sicDescription;
@property (nonatomic, retain) NSString * ticker;
@property (nonatomic, retain) NSSet *prices;
@property (nonatomic, retain) NSSet *reports;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addPricesObject:(Price *)value;
- (void)removePricesObject:(Price *)value;
- (void)addPrices:(NSSet *)values;
- (void)removePrices:(NSSet *)values;

- (void)addReportsObject:(Report *)value;
- (void)removeReportsObject:(Report *)value;
- (void)addReports:(NSSet *)values;
- (void)removeReports:(NSSet *)values;

@end

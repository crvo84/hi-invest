//
//  Price.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/6/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Price : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * ticker;
@property (nonatomic, retain) Company *company;

@end

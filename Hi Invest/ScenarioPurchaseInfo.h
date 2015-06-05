//
//  ScenarioPurchaseInfo.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/2/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenarioPurchaseInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSString *descriptionForScenario;
@property (strong, nonatomic) NSDate *initialDate;
@property (strong, nonatomic) NSDate *endingDate;
@property (nonatomic) NSInteger numberOfCompanies;
@property (nonatomic) NSInteger numberOfDays;
@property (nonatomic) BOOL withAdds;
@property (nonatomic) double price;
@property (nonatomic) double sizeInMegas;

@end

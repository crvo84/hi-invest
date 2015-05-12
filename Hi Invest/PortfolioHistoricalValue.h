//
//  PortfolioHistoricalValue.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortfolioHistoricalValue : NSObject

@property (strong, nonatomic) NSDate *date;
@property (nonatomic) double value;

@end

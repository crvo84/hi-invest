//
//  StockInvestment.h
//  Sperto
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockInvestment : NSObject

@property (strong, nonatomic) NSString *ticker;
@property (nonatomic) NSInteger shares;
@property (nonatomic) double averageCost;

@end

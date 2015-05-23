//
//  PortfolioTransaction.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortfolioTransaction : NSObject

typedef NS_OPTIONS(NSUInteger, PortfolioTransactionType) {
    PortfolioTransactionTypePurchase    = (1 << 0), // => 00000001
    PortfolioTransactionTypeSale        = (1 << 1), // => 00000010
    PortfolioTransactionTypeDividends   = (1 << 2), // => 00000100
    PortfolioTransactionTypeFeePaid     = (1 << 3)  // => 00001000
};

@property (nonatomic) PortfolioTransactionType transactionType;
@property (copy, nonatomic) NSString *descriptionInfo;
@property (nonatomic) NSInteger day;
@property (nonatomic) double amount;

@end

//
//  PortfolioTransaction.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortfolioTransaction : NSObject

typedef enum : NSInteger {
    
    PortfolioTransactionTypePurchase = 0,
    PortfolioTransactionTypeSale,
    PortfolioTransactionTypeCommissionPurchase,
    PortfolioTransactionTypeCommissionSale,
    PortfolioTransactionTypeDividends,
    
} PortfolioTransactionType;

@property (nonatomic) PortfolioTransactionType transactionType;
@property (copy, nonatomic) NSString *ticker;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger shares;
@property (nonatomic) double amount; // Normal purchases, sales, dividends and fees are positive values.



@end

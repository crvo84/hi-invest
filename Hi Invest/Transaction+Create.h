//
//  Transaction+Create.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Transaction.h"
#import "GameInfo.h"

@interface Transaction (Create)

// Used to define core data managed object PorfolioTransaction property TransactionType
typedef enum : NSInteger {
    
    PortfolioTransactionTypePurchase = 0,
    PortfolioTransactionTypeSale,
    PortfolioTransactionTypeCommissionPurchase,
    PortfolioTransactionTypeCommissionSale,
    PortfolioTransactionTypeDividends,
    
} PortfolioTransactionType;

+ (Transaction *)transactionWithGameInfo:(GameInfo *)gameInfo
                                    type:(PortfolioTransactionType)portfolioTransactionType
                                     day:(NSInteger)day
                                  amount:(double)amount
                                  shares:(NSInteger)shares
                               andTicker:(NSString *)ticker;


// Return an array with all the transactions from the given GameInfo.
+ (NSArray *)transactionsFromGameInfo:(GameInfo *)gameInfo inAscendingOrder:(BOOL)ascendingOrder;

// Return an array with the transactions from the given GameInfo at the given date
+ (NSArray *)transactionsFromGameInfo:(GameInfo *)gameInfo fromDay:(NSInteger)day;

@end

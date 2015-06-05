//
//  Transaction+Create.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "Transaction+Create.h"

@implementation Transaction (Create)

+ (Transaction *)transactionWithGameInfo:(GameInfo *)gameInfo
                                    type:(PortfolioTransactionType)portfolioTransactionType
                                     day:(NSInteger)day
                                  amount:(double)amount
                                  shares:(NSInteger)shares
                               andTicker:(NSString *)ticker
{
    NSManagedObjectContext *context = gameInfo.managedObjectContext;
    
    Transaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
    
    transaction.gameInfo = gameInfo;
    transaction.scenarioFilename = gameInfo.scenarioFilename;
    transaction.day = @(day);
    transaction.amount = @(amount);
    transaction.type = @(portfolioTransactionType);
    if (shares > 0) {
        transaction.shares = @(shares);
    }
    transaction.ticker = ticker;
    
    // Previous transaction relationship
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Transaction"];
    request.predicate = [NSPredicate predicateWithFormat:@"scenarioFilename = %@", gameInfo.scenarioFilename];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error) {
        NSLog(@"Error fetching Transaction Managed Objects. %@", [error localizedDescription]);
    } else if ([matches count] == 0) {
        transaction.orderingValue = @(0);
    } else {
        Transaction *lastTransaction = [matches lastObject];
        transaction.orderingValue = @([lastTransaction.orderingValue integerValue] + 1);
    }
    
    NSError *saveError;
    if (![gameInfo.managedObjectContext save:&saveError]) {
        NSLog(@"%@", [saveError localizedDescription]);
    }
    
    return transaction;
}

+ (NSArray *)transactionsFromGameInfo:(GameInfo *)gameInfo inAscendingOrder:(BOOL)ascendingOrder
{
    NSArray *transactions = [gameInfo.transactions allObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderingValue"
                                                 ascending:ascendingOrder];
    
    return [transactions sortedArrayUsingDescriptors:@[sortDescriptor]];
}

// Return an array with the transactions from the given GameInfo at the given date
+ (NSArray *)transactionsFromGameInfo:(GameInfo *)gameInfo fromDay:(NSInteger)day
{
    NSArray *filteredArray = [[gameInfo.transactions allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"day == %@", @(day)]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderingValue"
                                                                   ascending:YES];
    
    return [filteredArray sortedArrayUsingDescriptors:@[sortDescriptor]];
}













@end

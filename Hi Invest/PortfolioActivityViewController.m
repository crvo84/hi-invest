//
//  PortfolioActivityViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioActivityViewController.h"
#import "InvestingGame.h"
#import "PortfolioTransaction.h"
#import "TransactionTableViewCell.h"

@interface PortfolioActivityViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noActivityLabel;
@property (strong, nonatomic) NSArray *transactions; // of NSArray of PortfolioTransaction
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation PortfolioActivityViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    self.transactions = nil;
    
    [self.tableView reloadData];
    
    self.tableView.hidden = [self.transactions count] == 0;
    self.noActivityLabel.hidden = [self.transactions count] > 0;
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.transactions count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dayTransactions = self.transactions[section];
    
    return [dayTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionTableViewCell *transactionCell = [self.tableView dequeueReusableCellWithIdentifier:@"Transaction Cell"];
    
    NSArray *dayTransactions = self.transactions[indexPath.section];
    PortfolioTransaction *transaction = dayTransactions[indexPath.row];
    
    NSString *title;
    NSString *description;
    NSString *amount;
    UIColor *amountColor;
    
    switch (transaction.transactionType) {
        case 0:
            title = [NSString stringWithFormat:@"Buy - %@", transaction.ticker];
            
            self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            description = [NSString stringWithFormat:@"%@ shares", [self.numberFormatter stringFromNumber:@(transaction.shares)]];
            
            amountColor = [UIColor darkGrayColor];
            
            break;
            
        case 1:
            title = [NSString stringWithFormat:@"Sell - %@", transaction.ticker];
            
            self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            description = [NSString stringWithFormat:@"%@ shares", [self.numberFormatter stringFromNumber:@(transaction.shares)]];
            
            amountColor = [UIColor darkGrayColor];
            
            break;
            
        case 2:
            
            title = @"Commission & fees";
            
            description = [NSString stringWithFormat:@"Buy - %@", transaction.ticker];
            
            amountColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
            
            break;
            
        case 3:
            
            title = @"Commission & fees";
            
            description = [NSString stringWithFormat:@"Sell - %@", transaction.ticker];
            
            amountColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
            
            break;
            
        case 4:
            
            title = @"Dividends received";
            
            self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            description = [NSString stringWithFormat:@"%@  |  %@ shares", transaction.ticker, [self.numberFormatter stringFromNumber:@(transaction.shares)]];
            
            amountColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
            
            break;
            
        default:
            break;
    }
    
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    amount = [self.numberFormatter stringFromNumber:@(transaction.amount)];
    
    transactionCell.titleLabel.text = title;
    transactionCell.descriptionLabel.text = description;
    transactionCell.amountLabel.text = amount;
    transactionCell.amountLabel.textColor = amountColor;
    
    return transactionCell;
}

#pragma mark - UITableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *dayTransactions = self.transactions[section];
    NSInteger day = ((PortfolioTransaction *)[dayTransactions firstObject]).day;
    
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [NSString stringWithFormat:@"Day %@", [self.numberFormatter stringFromNumber:@(day)]];
}

#pragma mark - Getters

- (NSArray *)transactions
{
    if (!_transactions) {
        NSMutableArray *transactions = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < [self.game currentDay]; i++) {
            
            NSArray *dayTransactions = [self.game.portfolio transactionsFromDay:i + 1];
            if (dayTransactions) [transactions addObject:dayTransactions];
        }
        
        _transactions = transactions;
    }
    
    return _transactions;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 2;
        _numberFormatter.locale = self.game.locale;
    }
    
    return _numberFormatter;
}










@end

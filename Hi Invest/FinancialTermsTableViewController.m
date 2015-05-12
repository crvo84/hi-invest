//
//  FinancialTermsTableViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/3/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "FinancialTermsTableViewController.h"
#import "RatiosKeys.h"
#import "DefinitionViewController.h"
#import "InvestingGame.h"
#import "DefaultColors.h"

@interface FinancialTermsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FinancialTermsTableViewController

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
        Liquidity
        Profitability
        Debt
        Investment Valuation
        Price Statistics
     
        Sections with no ratios available yet:
        // Accounting Terms
        // Cash Flow
        // Operating
     */
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return [FinancialRatioCategoryLiquidityIdentifiersArray count];
    if (section == 1) return [FinancialRatioCategoryProfitabilyIdentifiersArray count];
    if (section == 2) return [FinancialRatioCategoryDebtIdentifiersArray count];
    if (section == 3) return [FinancialRatioCategoryInvestmentValuationIdentifiersArray count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Financial Term Cell"];
    
    NSString *financialTermStr;
    
    if (indexPath.section == 0) financialTermStr = FinancialRatioCategoryLiquidityIdentifiersArray[indexPath.row];
    else if (indexPath.section == 1) financialTermStr = FinancialRatioCategoryProfitabilyIdentifiersArray[indexPath.row];
    else if (indexPath.section == 2) financialTermStr = FinancialRatioCategoryDebtIdentifiersArray[indexPath.row];
    else if (indexPath.section == 3) financialTermStr = FinancialRatioCategoryInvestmentValuationIdentifiersArray[indexPath.row];
    
    cell.textLabel.text = financialTermStr;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Liquidity Ratios";
    if (section == 1) return @"Profitability Ratios";
    if (section == 2) return @"Debt Ratios";
    if (section == 3) return @"Investment Valuation Ratios";
    
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DefinitionViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {

            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            NSString *definitionId;
            
            if (indexPath.section == 0) {
                definitionId = FinancialRatioCategoryLiquidityIdentifiersArray[indexPath.row];
            } else if (indexPath.section == 1) {
                definitionId = FinancialRatioCategoryProfitabilyIdentifiersArray[indexPath.row];
            } else if (indexPath.section == 2) {
                definitionId = FinancialRatioCategoryDebtIdentifiersArray[indexPath.row];
            } else if (indexPath.section == 3) {
                definitionId = FinancialRatioCategoryInvestmentValuationIdentifiersArray[indexPath.row];
            }

            [self prepareDefinitionViewController:segue.destinationViewController withDefinitionId:definitionId];
        }
    }
}

- (void)prepareDefinitionViewController:(DefinitionViewController *)definitionViewController withDefinitionId:(NSString *)definitionId
{
    definitionViewController.definitionId = definitionId;
}












@end

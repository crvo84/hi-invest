//
//  GlossaryViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GlossaryViewController.h"
#import "DefinitionViewController.h"
#import "RatiosKeys.h"
#import "GlossaryKeys.h"

@interface GlossaryViewController () <UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GlossaryViewController


- (void)updateUI
{
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        return 5;
    }
    
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
        return 4;
    }
    
    if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        
        if (section == 0) return [FinancialRatioCategoryLiquidityIdentifiersArray count];
        if (section == 1) return [FinancialRatioCategoryProfitabilyIdentifiersArray count];
        if (section == 2) return [FinancialRatioCategoryDebtIdentifiersArray count];
        if (section == 3) return [FinancialRatioCategoryInvestmentValuationIdentifiersArray count];
        if (section == 4) return [FinancialRatioCategoryCashFlowIdentifiersArray count];
        
    } else if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
        
        if (section == 0) return [FinancialStatementGeneralTermsArray count];
        if (section == 1) return [FinancialStatementBalanceSheetTermsArray count];
        if (section == 2) return [FinancialStatementIncomeStatementTermsArray count];
        if (section == 3) return [FinancialStatementCashFlowTermsArray count];
        
        
    } else if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
        
        return [StockMarketTermDefinitionsDictionary count];
    }

    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Financial Term Cell"];
    
    NSString *financialTermTitle = @"";
    
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        if (indexPath.section == 0) {
            financialTermTitle = FinancialRatioCategoryLiquidityIdentifiersArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            financialTermTitle = FinancialRatioCategoryProfitabilyIdentifiersArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            financialTermTitle = FinancialRatioCategoryDebtIdentifiersArray[indexPath.row];
        }
        if (indexPath.section == 3) {
            financialTermTitle = FinancialRatioCategoryInvestmentValuationIdentifiersArray[indexPath.row];
        }
        if (indexPath.section == 4) {
            financialTermTitle = FinancialRatioCategoryCashFlowIdentifiersArray[indexPath.row];
        }
    }
    
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
        if (indexPath.section == 0) {
            financialTermTitle = FinancialStatementGeneralTermsArray[indexPath.row];
        }
        if (indexPath.section == 1) {
            financialTermTitle = FinancialStatementBalanceSheetTermsArray[indexPath.row];
        }
        if (indexPath.section == 2) {
            financialTermTitle = FinancialStatementIncomeStatementTermsArray[indexPath.row];
        }
        if (indexPath.section == 3) {
            financialTermTitle = FinancialStatementCashFlowTermsArray[indexPath.row];
        }

    }
    
    if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
        NSArray *stockMarketTermIdentifiers = [[StockMarketTermDefinitionsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        financialTermTitle = stockMarketTermIdentifiers[indexPath.row];
    }
    
    cell.textLabel.text = financialTermTitle;
    
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
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        
        [self performSegueWithIdentifier:@"Definition With Formula" sender:selectedCell];
        
    } else {
        
        [self performSegueWithIdentifier:@"Definition" sender:selectedCell];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        
        if (section == 0) return @"Liquidity Ratios";
        if (section == 1) return @"Profitability Ratios";
        if (section == 2) return @"Debt Ratios";
        if (section == 3) return @"Investment Valuation Ratios";
        if (section == 4) return @"Cash Flow Ratios";
        
    } else if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
        
        if (section == 0) return nil;
        if (section == 1) return @"Balance Sheet";
        if (section == 2) return @"Income Statement";
        if (section == 3) return @"Cash Flow";
        
        
    } else if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
        
        return nil;
        
    }
    
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DefinitionViewController class]]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            
            NSString *definitionId = nil;
            NSString *definition = nil;
            NSString *formulaImageFilename = nil;
            
            if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
                if (indexPath.section == 0) {
                    definitionId = FinancialRatioCategoryLiquidityIdentifiersArray[indexPath.row];
                }
                if (indexPath.section == 1) {
                    definitionId = FinancialRatioCategoryProfitabilyIdentifiersArray[indexPath.row];
                }
                if (indexPath.section == 2) {
                    definitionId = FinancialRatioCategoryDebtIdentifiersArray[indexPath.row];
                }
                if (indexPath.section == 3) {
                    definitionId = FinancialRatioCategoryInvestmentValuationIdentifiersArray[indexPath.row];
                }
                if (indexPath.section == 4) {
                    definitionId = FinancialRatioCategoryCashFlowIdentifiersArray[indexPath.row];
                }
                
                definition = FinancialRatiosDefinitionsDictionary[definitionId];
                formulaImageFilename = FinancialRatiosImageFilenamesDictionary[definitionId];
            }
            
            if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
                if (indexPath.section == 0) {
                    definitionId = FinancialStatementGeneralTermsArray[indexPath.row];
                }
                if (indexPath.section == 1) {
                    definitionId = FinancialStatementBalanceSheetTermsArray[indexPath.row];
                }
                if (indexPath.section == 2) {
                    definitionId = FinancialStatementIncomeStatementTermsArray[indexPath.row];
                }
                if (indexPath.section == 3) {
                    definitionId = FinancialStatementCashFlowTermsArray[indexPath.row];
                }
                
                definition = FinancialStatementTermDefinitionsDictionary[definitionId];
            }
            
            if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
                NSArray *stockMarketTermIdentifiers = [[StockMarketTermDefinitionsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                definitionId = stockMarketTermIdentifiers[indexPath.row];
                definition = StockMarketTermDefinitionsDictionary[definitionId];
            }
            
            [self prepareDefinitionViewController:segue.destinationViewController withDefinitionId:definitionId withDefinition:definition withFormulaImageFilename:formulaImageFilename];
        }
    }
}

- (void)prepareDefinitionViewController:(DefinitionViewController *)definitionViewController withDefinitionId:(NSString *)definitionId withDefinition:(NSString *)definition withFormulaImageFilename:(NSString *)formulaImageFilename
{
    definitionViewController.definitionId = definitionId;
    definitionViewController.definition = definition;
    definitionViewController.formulaImageFilename = formulaImageFilename;
}





@end

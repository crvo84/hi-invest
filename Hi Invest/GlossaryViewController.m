//
//  GlossaryViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GlossaryViewController.h"
#import "DefinitionViewController.h"
#import "UserAccount.h"
#import "RatiosKeys.h"
#import "GlossaryKeys.h"

#import <iAd/iAd.h>
#import "Reachability.h"

@interface GlossaryViewController () <UITableViewDataSource, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectedSection;
@property (nonatomic) NSInteger selectedRow;

@end

@implementation GlossaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canDisplayBannerAds = [self.userAccount shouldPresentAds];
}


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
    
    self.selectedSection = indexPath.section;
    self.selectedRow = indexPath.row;
    
    if ([self.userAccount shouldPresentAds] && ![self isInternetAvailable]) {
        
        [self presentAlertViewWithTitle:@"No internet connection" withMessage:@"Remove ads to continue offline." withActionTitle:@"Dismiss"];
        
    } else if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
        
        [self performSegueWithIdentifier:@"Definition With Formula" sender:self];
        
    } else {
        
        [self performSegueWithIdentifier:@"Definition" sender:self];
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
            
        NSInteger section = self.selectedSection;
        NSInteger row = self.selectedRow;
        
        NSString *definitionId = nil;
        NSString *definition = nil;
        NSString *formulaImageFilename = nil;
        NSString *source = nil;
        
        if ([self.glossaryId isEqualToString:GlossaryTypeFinancialRatios]) {
            if (section == 0) {
                definitionId = FinancialRatioCategoryLiquidityIdentifiersArray[row];
            }
            if (section == 1) {
                definitionId = FinancialRatioCategoryProfitabilyIdentifiersArray[row];
            }
            if (section == 2) {
                definitionId = FinancialRatioCategoryDebtIdentifiersArray[row];
            }
            if (section == 3) {
                definitionId = FinancialRatioCategoryInvestmentValuationIdentifiersArray[row];
            }
            if (section == 4) {
                definitionId = FinancialRatioCategoryCashFlowIdentifiersArray[row];
            }
            
            definition = FinancialRatiosDefinitionsDictionary[definitionId];
            formulaImageFilename = FinancialRatiosImageFilenamesDictionary[definitionId];
        }
        
        if ([self.glossaryId isEqualToString:GlossaryTypeFinancialStatementTerms]) {
            if (section == 0) {
                definitionId = FinancialStatementGeneralTermsArray[row];
            }
            if (section == 1) {
                definitionId = FinancialStatementBalanceSheetTermsArray[row];
            }
            if (section == 2) {
                definitionId = FinancialStatementIncomeStatementTermsArray[row];
            }
            if (section == 3) {
                definitionId = FinancialStatementCashFlowTermsArray[row];
            }
            
            definition = FinancialStatementTermDefinitionsDictionary[definitionId];
        }
        
        if ([self.glossaryId isEqualToString:GlossaryTypeStockMarketTerms]) {
            NSArray *stockMarketTermIdentifiers = [[StockMarketTermDefinitionsDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            definitionId = stockMarketTermIdentifiers[row];
            definition = StockMarketTermDefinitionsDictionary[definitionId];
        }
        
        // Source availability
        if ([FinancialDefinitionSourceNASDAQTermsArray containsObject:definition]) {
            source = @"Nasdaq.com";
        } else if ([FinancialDefinitionSourceNYSSCPATermsArray containsObject:definition]) {
            source = @"NY Society of Certified Public Accountants";
        }
        
        [self prepareDefinitionViewController:segue.destinationViewController withDefinitionId:definitionId withDefinition:definition withFormulaImageFilename:formulaImageFilename withSource:source];
    }
}

- (void)prepareDefinitionViewController:(DefinitionViewController *)definitionViewController withDefinitionId:(NSString *)definitionId withDefinition:(NSString *)definition withFormulaImageFilename:(NSString *)formulaImageFilename withSource:(NSString *)source
{
    definitionViewController.definitionId = definitionId;
    definitionViewController.definition = definition;
    definitionViewController.formulaImageFilename = formulaImageFilename;
    definitionViewController.source = source;
}

#pragma mark - Internet Connection

- (BOOL)isInternetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)presentAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end

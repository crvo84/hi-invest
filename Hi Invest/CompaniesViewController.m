//
//  CompaniesViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompaniesViewController.h"
#import "CompanyInfoViewController.h"
#import "SelectOrderingValueViewController.h"
#import "PortfolioStockInfoContainerViewController.h"
#import "CompaniesInfoKeys.h"
#import "PortfolioKeys.h"
#import "RatiosKeys.h"
#import "CompanyTableViewCell.h"
#import "Price.h"

@interface CompaniesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectRatioButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *companies; // of NSDictionary
@property (nonatomic) BOOL descendingOrder; // For future option to sort in ascending order
@property (nonatomic) BOOL showValueAsPercent;

@end

@implementation CompaniesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load CompanyCell NIB file
    UINib *nib = [UINib nibWithNibName:@"CompanyTableViewCell" bundle:nil];
    // Register the cell NIB
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Company Cell"];
    
    self.descendingOrder = YES;
    self.showValueAsPercent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI]; // Updating UI is done here to update when switching tabs
}

#pragma mark - Updating UI and Data

- (void)updateUI
{
    self.companies = nil;
    [self sortCompanies];
    
    NSString *sortingValueText = self.sortingValueId ? self.sortingValueId : @"Select Ratio";
    [self.selectRatioButton setTitle:sortingValueText forState:UIControlStateNormal];
    
    [self.tableView reloadData];
    
}

#pragma mark - Sorting Array

// Sort companies NSMutableArray of NSDictionary. If BOOL self.orderAlphabetically is true, it sort the elements in the array by the tickers in alphabetically order. If not, it sort the array comparing the ordering value (ascending or descending from the BOOL property)
- (void)sortCompanies
{
    [self.companies sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDictionary *dictionary1 = (NSDictionary *)obj1;
        NSDictionary *dictionary2 = (NSDictionary *)obj2;
        
        if (!self.sortingValueId) {
            NSString *ticker1 = (NSString *)dictionary1[companyTicker];
            NSString *ticker2 = (NSString *)dictionary2[companyTicker];
            
            if (!ticker1 || !ticker2) return NSOrderedSame;
            return [ticker1 caseInsensitiveCompare:ticker2];
            
        } else {
            NSNumber *value1 = dictionary1[companyOrderingValueNumber];
            NSNumber *value2 = dictionary2[companyOrderingValueNumber];
            
            // If both values are nil
            if (!value1 && !value2) return NSOrderedSame;
            
            // A nil value is lower to any non-nil value
            if (!value2) return self.descendingOrder ? NSOrderedAscending : NSOrderedDescending;
            if (!value1) return self.descendingOrder ? NSOrderedDescending : NSOrderedAscending;
            
            if ([value1 doubleValue] > [value2 doubleValue]) {
                return self.descendingOrder ? NSOrderedAscending : NSOrderedDescending;
            }
            if ([value1 doubleValue] < [value2 doubleValue]) {
                return self.descendingOrder ? NSOrderedDescending : NSOrderedAscending;
            }
        }
        
        return NSOrderedSame;
    }];
}

#pragma mark - Getters

- (NSMutableArray *)companies
{
    if (!_companies) {
        _companies = [self.game informationOfCompanies:nil withSortingValueId:self.sortingValueId]; // nil to include all companies
    }
    
    return _companies;
}

#pragma mark - Setters

- (void)setSortingValueId:(NSString *)sortingValueId
{
    if (![_sortingValueId isEqualToString:sortingValueId]) {
        _sortingValueId = sortingValueId;
        
        self.showValueAsPercent = [FinancialSortingValuesPercentValuesArray containsObject:sortingValueId] ? YES : NO;
        
        [self updateUI];
    }
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.companies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Company Cell"];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    // Get the corresponding NSDictionary from array with companies information
    NSDictionary *companyInfo = self.companies[indexPath.row];
    NSString *ticker = companyInfo[companyTicker];
    
    // Ticker Label Text
    cell.tickerLabel.text = ticker;
    
    // pieChartButton
    if ([self.game.portfolio hasInvestmentWithTicker:ticker]) {
        cell.pieChartButton.hidden = NO;
        [cell.pieChartButton addTarget:self action:@selector(showPortfolioStockInfoFromSender:) forControlEvents:UIControlEventTouchUpInside];
        cell.pieChartButton.tag = indexPath.row;
    } else {
        cell.pieChartButton.hidden = YES;
    }
    
    
    // Price label text
    NSNumber *priceNumber = companyInfo[companyPriceNumber];
    NSString *priceText;
    if (priceNumber) {
        priceText = [NSString stringWithFormat:@"$%.2f",[priceNumber doubleValue]];
    } else {
        priceText = @"";
    }
    cell.priceLabel.text = priceText;
    
    // Value label text
    NSNumber *valueNumber = companyInfo[companyOrderingValueNumber];
    NSString *valueText;
    if (valueNumber) {
        double value = [valueNumber doubleValue];
        if (self.showValueAsPercent) value *= 100;
        valueText = [NSString stringWithFormat:@"%.2f", value];
        if (self.showValueAsPercent) valueText = [NSString stringWithFormat:@"%@%%", valueText];
    } else {
        valueText = @"";
    }
    cell.valueLabel.text = valueText;
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.companies[indexPath.row][companyPriceNumber]) {
        return 56;
    } else { // if it has no price, then it is the market average
        return 36;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Company Info" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    
    // Deselects the table view cell so it wont be selected when returning from the segued view controller
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}



#pragma mark - Navigation

  //--------------------/
 /* Prepare For Segue */
//--------------------/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Company Info"]) {
        if ([segue.destinationViewController isKindOfClass:[CompanyInfoViewController class]]) {
            NSUInteger row = [self.tableView indexPathForCell:((UITableViewCell *)sender)].row;
            NSString *ticker = self.companies[row][companyTicker];
            CompanyInfoViewController *companyInfoViewController = ((CompanyInfoViewController *)segue.destinationViewController);
            [self prepareCompanyInfoViewController:companyInfoViewController withTicker:ticker andInvestingGame:self.game];
        }
    }
    
    if ([segue.identifier isEqualToString:@"Portfolio Stock Info"]) {
        UIViewController *viewController = segue.destinationViewController;
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            viewController = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
        }
        if ([viewController isKindOfClass:[PortfolioStockInfoContainerViewController class]]) {
            NSUInteger row = ((UIButton *)sender).tag; // the UITableViewCell row is set to the sender UIButton tag
            NSString *ticker = self.companies[row][companyTicker];
            [self preparePortfolioStockInfoContainerViewController:(PortfolioStockInfoContainerViewController *)viewController withTicker:ticker andInvestingGame:self.game];
        }
    }
    
    if ([segue.identifier isEqualToString:@"Select Ordering Value"]) {
        if ([segue.destinationViewController isKindOfClass:[SelectOrderingValueViewController class]]) {
            [self prepareSelectOrderingValueViewController:segue.destinationViewController withInitialIdentifier:self.sortingValueId];
        }
    }
}

  //-------------------------------/
 /* View Controllers Preparation */
//-------------------------------/

- (void)prepareCompanyInfoViewController:(CompanyInfoViewController *)companyInfoViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    companyInfoViewController.game = game;
    companyInfoViewController.ticker = ticker;
    companyInfoViewController.title = ticker;
}

- (void)preparePortfolioStockInfoContainerViewController:(PortfolioStockInfoContainerViewController *)portfolioStockInfoContainerViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    portfolioStockInfoContainerViewController.game = game;
    portfolioStockInfoContainerViewController.ticker = ticker;
}

// initialIdentifier parameter can be nil (when selecting ordering identifier for the first time)
- (void)prepareSelectOrderingValueViewController:(SelectOrderingValueViewController *)orderingValueViewController withInitialIdentifier:(NSString *)initialIdentifier
{
    orderingValueViewController.selectedIdentifier = self.sortingValueId;
}

#pragma mark - Selectors

- (void)showPortfolioStockInfoFromSender:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        [self performSegueWithIdentifier:@"Portfolio Stock Info" sender:sender];
    }
}





















@end

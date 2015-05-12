//
//  PortfolioTableViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioTableViewController.h"
#import "PortfolioPieChartViewController.h"
#import "PortfolioHistoricalValue.h"
#import "BEMSimpleLineGraphView.h"
#import "InvestingGame.h"
#import "UserDefaultsKeys.h"
#import "DefaultColors.h"
#import "PortfolioKeys.h"

@interface PortfolioTableViewController () <UITableViewDataSource, UITableViewDelegate, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *weightOfStocksInPortfolio;
@property (strong, nonatomic) NSArray *tickersOrderedByWeight;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *networthLabel;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation PortfolioTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialGraphSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI]; // UpdatingUI is done here to update when switching tabs
}


#pragma mark - Update UI

- (void)updateUI
{
    self.weightOfStocksInPortfolio = nil;
    self.tickersOrderedByWeight = nil;
    
    [self.tableView reloadData];
    [self.graphView reloadGraph];
    
    [self updateCurrentDayInfoLabels];
}

- (void)updateCurrentDayInfoLabels
{
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.dayLabel.text = [NSString stringWithFormat:@"Current Day: %@", [self.numberFormatter stringFromNumber:@(self.game.currentDay)]];
    
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.networthLabel.text = [self.numberFormatter stringFromNumber:@([self.game currentNetWorth])];
}

- (void)initialGraphSetup
{
    self.graphView.layer.cornerRadius = 8;
    self.graphView.layer.masksToBounds = YES;
    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.graphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.graphView.enableTouchReport = YES;
//    self.graphView.enablePopUpReport = YES;
    self.graphView.enableYAxisLabel = YES;
    self.graphView.autoScaleYAxis = YES;
    self.graphView.alwaysDisplayDots = NO;
    self.graphView.enableReferenceXAxisLines = YES;
    self.graphView.enableReferenceYAxisLines = YES;
    self.graphView.enableReferenceAxisFrame = YES;
    
    // Show the y axis values with this format string
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.graphView.formatStringForValues = @"$%.2fk";
    
    UIColor *color = [DefaultColors graphBackgroundColor];
    self.graphView.colorTop = color;
    self.graphView.colorBottom = color;
    self.graphView.backgroundColor = color;
    self.graphView.colorYaxisLabel = [UIColor whiteColor];
    self.graphView.colorXaxisLabel = [UIColor whiteColor];
}


#pragma mark - Getters

- (NSDictionary *)weightOfStocksInPortfolio
{
    if (!_weightOfStocksInPortfolio) {
        _weightOfStocksInPortfolio = [self.game weigthInPortfolioOfStocksWithTickers:[self.game.portfolio tickersOfStocksInPortfolio]];
    }
    
    return _weightOfStocksInPortfolio;
}

- (NSArray *)tickersOrderedByWeight
{
    if (!_tickersOrderedByWeight) {
        _tickersOrderedByWeight = [self.game tickersOfCompaniesInPortfolioOrderedByWeightInDescendingOrder:YES];
        
    }
    
    return _tickersOrderedByWeight;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = [NSLocale localeWithLocaleIdentifier:Locale];
        _numberFormatter.maximumFractionDigits = 2;
    }
    
    return _numberFormatter;
}

#pragma mark - Setters

  //--------------/
 /* UITableView */
//--------------/

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.tickersOrderedByWeight count] > 0) {
        return 2; // Cash Section and Stocks Sections
    } else {
        return 1; // Cash Section only
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [self.tickersOrderedByWeight count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Portfolio Stock Cell"];
    
    self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = CashTicker;
        double cashWeight = self.game.portfolio.cash / [self.game currentNetWorth];
        cell.detailTextLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:cashWeight]];
    } else {
        NSString *ticker = self.tickersOrderedByWeight[indexPath.row];
        cell.textLabel.text = ticker;
        cell.detailTextLabel.text = [self.numberFormatter stringFromNumber:self.weightOfStocksInPortfolio[ticker]];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Cash and Short-Term Investments";
    if (section == 1) return @"Stocks";
    
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


//-------------------------/
/* BEMSimpleLineGraphView */
//-------------------------/

#pragma mark - BEMSimpleLineGraphView Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph
{
    NSInteger count = [self.game.portfolioHistoricalValues count];
    if (count == 0) {
        return 2; // If no historical values, then display to points to how a horizontal line with current networth
    } else {
        return [self.game.portfolioHistoricalValues count] + 1; // historical values + current net worth
    }
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index
{
    NSInteger count = [self.game.portfolioHistoricalValues count];
    
    if (index < count) {
        PortfolioHistoricalValue *portfolioHistoricalValue = self.game.portfolioHistoricalValues[index];
        return portfolioHistoricalValue.value / 1000; // value in thousands
    }
    
    return [self.game currentNetWorth] / 1000; // value in thousands
}

#pragma mark - BEMSimpleLineGraphView Delegate


- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph
{
    NSInteger count = [self.game.portfolioHistoricalValues count];
    if (count == 0) {
        return 1;
    } else {
        return (count + 1) / 10;
    }
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index
{
//    return [NSString stringWithFormat:@"Day %ld", index + 1];
    return @"";
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index
{
    if ([self.game.portfolioHistoricalValues count] != 0) {
        NSNumber *dayNumber;
        NSNumber *historicalValueNumber;
        if (index < [self.game.portfolioHistoricalValues count]) {
            PortfolioHistoricalValue *portfolioHistoricalValue = self.game.portfolioHistoricalValues[index];
            dayNumber = @([self.game dayNumberFromDate:portfolioHistoricalValue.date]);
            historicalValueNumber = @(portfolioHistoricalValue.value);
        } else {
            dayNumber = @([self.game currentDay]);
            historicalValueNumber = @([self.game currentNetWorth]);
        }
        
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.dayLabel.text = [NSString stringWithFormat:@"Day %@", [self.numberFormatter stringFromNumber:dayNumber]];
        
        self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        self.networthLabel.text = [self.numberFormatter stringFromNumber:historicalValueNumber];
    }
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    
    NSInteger count = [self.game.portfolioHistoricalValues count];
    
    if (count != 0) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.dayLabel.alpha = 0.0;
            self.networthLabel.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [self updateCurrentDayInfoLabels];
            
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.dayLabel.alpha = 1.0;
                self.networthLabel.alpha = 1.0;
            } completion:nil];
        }];
    }
}

//- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
//    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
//    self.labelDates.text = [NSString stringWithFormat:@"between %@ and %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
//}

//- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @" people";
//}

//- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @"$";
//}





#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // Segue called from UITableViewCell
        if ([segue.destinationViewController isKindOfClass:[PortfolioPieChartViewController class]]) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
            NSString *ticker;
            if (indexPath.section == 0 && indexPath.row == 0) {
                ticker = CashTicker;
            } else {
                ticker = self.tickersOrderedByWeight[indexPath.row];
            }
            [self preparePortfolioPieChartViewController:segue.destinationViewController withInvestingGame:self.game withSelectedTicker:ticker];
        }
    }
}

- (void)preparePortfolioPieChartViewController:(PortfolioPieChartViewController *)portfolioPieChartViewController withInvestingGame:(InvestingGame *)game withSelectedTicker:(NSString *)ticker
{
    portfolioPieChartViewController.game = game;
    portfolioPieChartViewController.ticker = ticker;
}


















@end

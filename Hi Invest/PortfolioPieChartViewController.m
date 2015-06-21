//
//  PortfolioPieChartViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/22/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioPieChartViewController.h"
#import "PortfolioStockInfoViewController.h"
#import "FinancialDatabaseManager.h"
#import "XYPieChart.h"
#import "InvestingGame.h"
#import "PortfolioKeys.h"
#import "DefaultColors.h"
#import "Price.h"

@interface PortfolioPieChartViewController () <XYPieChartDataSource, XYPieChartDelegate>

@property (strong, nonatomic) PortfolioStockInfoViewController *portfolioStockInfoViewController;
@property (strong, nonatomic) Price *price;
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) NSDictionary *weightOfStocksInPortfolio;
@property (strong, nonatomic) NSArray *tickersOrderedByWeight;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@end

@implementation PortfolioPieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // XY Pie Chart Initial Configuration
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.showLabel = YES;
    self.pieChart.labelFont = [UIFont fontWithName:@"Helvetica" size:17];
//    self.pieChart.labelColor = [UIColor blackColor];
    self.pieChart.labelColor = [DefaultColors navigationBarWithSegueTitleColor];
    self.pieChart.showPercentage = YES;
    
    // Percent label circle label
    self.percentLabel.layer.cornerRadius = self.percentLabel.frame.size.width / 2;
    self.percentLabel.layer.masksToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateUI]; // Done in viewDidAppear so the pieChart animation can work
}

#pragma mark - Update UI

- (void)updateUI
{
    self.pieChart.pieCenter = CGPointMake(self.pieChart.frame.size.width / 2, self.pieChart.frame.size.height / 2);
    self.pieChart.pieRadius = MIN(self.pieChart.frame.size.width / 2, self.pieChart.frame.size.height / 2);
    
    self.weightOfStocksInPortfolio = nil;
    self.tickersOrderedByWeight = nil;
    self.price = nil;
    
    [self.pieChart reloadData];
    
    // To check if investment is still in portfolio, if not, select cash
    if (![self.ticker isEqualToString:CashTicker] && ![self.game.portfolio hasInvestmentWithTicker:self.ticker]) {
        if (self.game.portfolio.cash > 0) {
            self.ticker = CashTicker;
        } else {
            [self.tickersOrderedByWeight firstObject];
        }
    }
    
    [self preparePortfolioStockInfoViewController:self.portfolioStockInfoViewController withTicker:self.ticker andInvestingGame:self.game];
    [self.portfolioStockInfoViewController updateUI];
    
    // After the pieChart has been updated, we wait some number of seconds (in a non-main thread), and then return to the main thread to select the corresponding slice for the selected ticker
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:0.5f];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Here you returns to main thread.
            NSUInteger index;
            if ([self.ticker isEqualToString:CashTicker]) {
                index = 0;
            } else {
                index = [self.tickersOrderedByWeight indexOfObject:self.ticker] + 1;
            }
            
            if (([self.weightOfStocksInPortfolio count] >= 2) || ([self.weightOfStocksInPortfolio count] == 1 && [self.weightOfStocksInPortfolio[[self.tickersOrderedByWeight firstObject]] doubleValue] < 0.995)) {
                [self.pieChart setSliceSelectedAtIndex:index];
            }
        });
    });
}


  //-----------------------/
 /* Device Auto-Rotation */
//-----------------------/

#pragma mark - Device Rotation

- (void)awakeFromNib
{
    // Adds self as observer for device orientation changes
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    // Removes self as observer from notification center
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientationChanged:(NSNotification *)notification
{
    // Need to update UI after rotation, so the pieChart will redraw itself within the pieChart view bounds
    [self updateUI];
}

  //----------------------/
 /* Getters and Setters */
//----------------------/

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

- (Price *)price
{
    if (!_price) {
        _price = self.game.currentPrices[self.ticker];
    }
    
    return _price;
}

#pragma mark - Setters

- (void)setTicker:(NSString *)ticker
{
    _ticker = ticker;
    
    if ([ticker isEqualToString:CashTicker]) {
        self.title = CashTicker;
        
    } else {
        self.title = [self.game UITickerForTicker:ticker];
    }
    
    [self updateUI];
}


  //---------------/
 /* XY Pie Chart */
//---------------/

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.tickersOrderedByWeight count] + 1; // +1 to show cash weight
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    if (index == 0) { // Cash
        double netWorth = [self.game currentNetWorth];
        double cash = self.game.portfolio.cash;
        return cash / netWorth;
    } else { // Other Assets
        NSString *ticker = self.tickersOrderedByWeight[index - 1];
        return [self.weightOfStocksInPortfolio[ticker] doubleValue];
    }
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return CashTicker;
    } else {
        return self.tickersOrderedByWeight[index - 1];
    }
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    NSInteger numberOfInvestmentsInPortfolio = [self.tickersOrderedByWeight count];
    
    double alphaDifference = ([DefaultColors UIElementsBackgroundAlpha]) / (numberOfInvestmentsInPortfolio + 1);

    double alpha = alphaDifference * (index + 1);
    
    if (numberOfInvestmentsInPortfolio == 0) {
        // If 100% of cash
        alpha *= 0.75;
    }
    
    return [[DefaultColors pieChartMainColor] colorWithAlphaComponent:alpha];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    // When a new slice is selected, deselect the previous selected slice
    NSUInteger currentlySelectedIndex;
    if ([self.ticker isEqualToString:CashTicker]) {
        // Cash slice
        currentlySelectedIndex = 0;
    } else {
        // Other slices
        currentlySelectedIndex = [self.tickersOrderedByWeight indexOfObject:self.ticker] + 1;
    }
    if (currentlySelectedIndex != index) {
        // Only if a new index is selected
        [self.pieChart setSliceDeselectedAtIndex:currentlySelectedIndex];
    }
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    if (index == 0) {
        // Cash slice selected
        self.ticker = CashTicker;
    } else {
        // Other slice selected
        self.ticker = self.tickersOrderedByWeight[index - 1];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embedded PortfolioStockInfoViewController"]) {
        if ([segue.destinationViewController isKindOfClass:[PortfolioStockInfoViewController class]]) {
            // We save a link to the destination view controller in case "Prepare for Segue" is called before price setter.
            self.portfolioStockInfoViewController = segue.destinationViewController;
            if (self.ticker && self.game) {
                [self preparePortfolioStockInfoViewController:self.portfolioStockInfoViewController withTicker:self.ticker andInvestingGame:self.game];
            }
        }
    }
}

- (void)preparePortfolioStockInfoViewController:(PortfolioStockInfoViewController *)portfolioStockInfoViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    portfolioStockInfoViewController.ticker = ticker;
    portfolioStockInfoViewController.game = game;
}



@end

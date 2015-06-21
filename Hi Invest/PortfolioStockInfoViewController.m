//
//  PortfolioStockInfoViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/7/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioStockInfoViewController.h"
#import "BuySellTableViewController.h"
#import "InvestingGame.h"
#import "Price.h"
#import "PortfolioKeys.h"

@interface PortfolioStockInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *tickerButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabelText;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) NSNumber *priceNumber;
@property (nonatomic) NSUInteger priceMultiplier;
@property (nonatomic) double netWorth;

@end

@implementation PortfolioStockInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tickerButton.layer.cornerRadius = 8;
    self.tickerButton.layer.masksToBounds = YES;
    
    // Sets the image to Rendering Template so it takes the color of the view that contains it
    // This way, the image takes the tint color of the uibutton
    UIImage *addButtonNormalStateImage = [self.addButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // Sets the image to show in the button in a control state normal
    [self.addButton setImage:addButtonNormalStateImage forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.ticker && self.game) {
        self.netWorth = [self.game currentNetWorth];
        [self updateUI]; // UpdatingUI is done here to update when switching tabs
    }
}


- (void)updateUI
{
    self.priceNumber = nil;
    
    // Ticker Button Text
    if ([self.ticker isEqualToString:CashTicker]) {
        [self.tickerButton setTitle:CashTicker forState:UIControlStateNormal];
        // Disabled button so Buy Sell segue cannot ve performed when Cash is selected
        self.tickerButton.enabled = NO;
        // Hide addButton
        self.addButton.hidden = YES;
        [self.tickerButton setTitleColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1] forState:UIControlStateDisabled];
    } else {
        [self.tickerButton setTitle:[self.game UITickerForTicker:self.ticker] forState:UIControlStateNormal];
        // Enabled for tickers of companies that can be bought/sold
        self.tickerButton.enabled = YES;
        // Show addButton
        self.addButton.hidden = NO;
    }
    
    // Current Price Label
    if ([self.ticker isEqualToString:CashTicker]) {
        // No need for current Price Label if its Cash
        self.currentPriceLabelText.alpha = 0.0;
        self.currentPriceLabel.text = @"";
    } else {
        self.currentPriceLabelText.alpha = 1.0;
        double currentPriceValue = [self.priceNumber doubleValue];
        self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        self.currentPriceLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:currentPriceValue]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.game && self.ticker) {
        return [self.ticker isEqualToString:CashTicker] ? 2 : 5;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Portfolio Stock Info Cell"];
    
    NSString *titleStr;
    NSString *valueStr;
    
    NSString *ticker = self.ticker;
    double currentPrice = [self.priceNumber doubleValue];
    double shares = [self.game.portfolio sharesInPortfolioOfStockWithTicker:ticker] / self.priceMultiplier; // DISGUISED
    double averageCost = [self.game.portfolio averageCostForCompanyWithTicker:ticker] * self.priceMultiplier; // DISGUISED
    
    if (indexPath.row == 0) { // Average cost cell (Weight in portfolio if cash)
        
        if ([self.ticker isEqualToString:CashTicker]) {
            
            self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
            double weightPercent = self.game.portfolio.cash / self.netWorth;
            valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:weightPercent]];
            titleStr = @"Weight in portfolio";
            
        } else {
            
            self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:averageCost]];
            titleStr = @"Average cost";
            
        }
        
    } else if (indexPath.row == 1) { // // Return cell (Value if cash)
        
        if ([self.ticker isEqualToString:CashTicker]) {
            self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            double totalValue = self.game.portfolio.cash;
            valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalValue]];
            titleStr = @"Value";
        } else {
            
            self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
            double returnPercent = (currentPrice / averageCost - 1);
            valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:returnPercent]];
            titleStr = @"Return";
            
        }
        
    } else if (indexPath.row == 2) { // Shares owned cell
        
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:shares]];
        titleStr = @"Shares owned";
        
    } else if (indexPath.row == 3) { // Value cell
    
        self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        double totalValue = currentPrice * shares;
        valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:totalValue]];
        titleStr = @"Value";
        
    } else if (indexPath.row == 4) { // Weight in portfolio cell
        
        self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
        double weightPercent = (shares * currentPrice) / self.netWorth;
        valueStr = [self.numberFormatter stringFromNumber:[NSNumber numberWithDouble:weightPercent]];
        titleStr = @"Weight in portfolio";
        
    }
    
    cell.textLabel.text = titleStr;
    cell.detailTextLabel.text = valueStr;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double heightPerCell = self.tableView.frame.size.height / 5;
    return heightPerCell < 44 ? 44 : heightPerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Since there is only one section.
    // Return a very small height to avoid initial table view offset for grouped table views
    return 0.1;
}


#pragma mark - Getters

- (NSNumber *)priceNumber
{
    if (!_priceNumber) {
        
        Price *price = self.game.currentPrices[self.ticker];
        
        if (self.game.disguiseRealNamesAndTickers) { // DISGUISED
            _priceNumber = @([price.price doubleValue] * self.priceMultiplier);
        }  else {
            _priceNumber = price.price;
        }
    }
    
    return _priceNumber;
}

- (NSUInteger)priceMultiplier
{
    return [self.game UIPriceMultiplierForTicker:self.ticker];
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = self.game.locale;
        _numberFormatter.maximumFractionDigits = 2;
    }
    
    return _numberFormatter;
}

#pragma mark - Setters

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [((UINavigationController *)viewController).viewControllers firstObject];
    }
    if ([viewController isKindOfClass:[BuySellTableViewController class]]) {
        BuySellTableViewController *buySellTableViewController = (BuySellTableViewController *)viewController;
        [self prepareBuySellTableViewController:buySellTableViewController withTicker:self.ticker andInvestingGame:self.game];
    }
}

- (void)prepareBuySellTableViewController:(BuySellTableViewController *)buySellTableViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    buySellTableViewController.game = game;
    buySellTableViewController.ticker = ticker;
}












@end

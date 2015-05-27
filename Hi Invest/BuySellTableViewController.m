//
//  BuySellTableViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "BuySellTableViewController.h"
#import "InvestingGame.h"
#import "Price.h"
#import "Company.h"
#import "PortfolioStockInfoContainerViewController.h"
#import "CompaniesViewController.h"
#import "CompanyInfoViewController.h"
#import "PortfolioPieChartViewController.h"


@interface BuySellTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSNumber *priceNumber;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

// Portfolio properties
@property (nonatomic) double netWorth;
@property (nonatomic) NSInteger previousShares;
@property (nonatomic) double previousCash;
@property (nonatomic) double previousAverageCost;

/* Navigation Outlets */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *executeOrderButton;

/* Configuration Outlets */
@property (weak, nonatomic) IBOutlet UISegmentedControl *buySellSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sharesOrWeightSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *showMoreInfoButton;

/* Information Outlets */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousCashLabel;
@property (weak, nonatomic) IBOutlet UILabel *sharesOrWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousAverageCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedAverageCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *previousReturnLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedReturnLabel;

/* Helper Properties */
@property (nonatomic, readonly) BOOL isBuyOrder;
@property (nonatomic, readonly) BOOL showNumberOfShares;
@property (nonatomic, readonly) double amount;
@property (nonatomic) BOOL showPortfolioInfo;
@property (nonatomic, readonly) NSInteger sharesSelected;

// Company Disguising Properties
@property (nonatomic) NSUInteger priceMultiplier;

@end

@implementation BuySellTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Initialization of portfolio values properties
    self.netWorth = self.game.currentNetWorth;
    
    self.previousShares = [self.game.portfolio sharesInPortfolioOfStockWithTicker:self.ticker];
    if (self.previousShares != NSNotFound) {
        self.previousShares /= self.priceMultiplier; // DISGUISE
    }
    
    self.previousAverageCost = [self.game.portfolio averageCostForCompanyWithTicker:self.ticker];
    if (self.previousAverageCost != NSNotFound) {
        self.previousAverageCost *= self.priceMultiplier; // DISGUISE
    }
    
    self.previousCash = self.game.portfolio.cash;

    // For keyboard dismissing over tableview
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self initialUIConfiguration];
    
}

// Method called from gesture recognizer added to tableView. 
- (void)hideKeyboard
{
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
}


#pragma mark - UI Configuration

- (void)initialUIConfiguration
{
    // Navigation Bar Title
    self.title = [self.game UITickerForTicker:self.ticker];
    
    // textField configuration
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.returnKeyType = UIReturnKeyDone;
    
    // BUY ORDER IS SET AS DEFAULT ORDER TYPE
    self.buySellSegmentedControl.selectedSegmentIndex = 0;
    [self updateUIForBuyOrSellSelection]; // Updates execute button, amount label. Setup slider.
    
    // NUMBER OF SHARES AS DEFAULT SELECTION TYPE
    self.sharesOrWeightSegmentedControl.selectedSegmentIndex = 0;
    [self updateSharesOrWeightLabel]; // Updates shares or weight label. Note label for textField
    [self updateTextFieldPlaceholder]; // Updates textField placeholder, seen when there is no text
    
    // HIDDEN PORTFOLIO INFO AS DEFAULT
    self.showPortfolioInfo = NO;
    [self updateShowMoreInfoButton]; // UPDATES showMoreInfoButton text
    
    
      //------------------------/
     /* CURRENCY FORMAT CELLS */
    //------------------------/
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.priceLabel.text = [NSString stringWithFormat:@"Price: %@", [self.numberFormatter stringFromNumber:self.priceNumber]];
    self.previousCashLabel.text = [self.numberFormatter stringFromNumber:@(self.previousCash)];
    self.previousAverageCostLabel.text = self.previousAverageCost == NSNotFound ? @"--" : [self.numberFormatter stringFromNumber:@(self.previousAverageCost)];

      //-----------------------/
     /* PERCENT FORMAT CELLS */
    //-----------------------/
    self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    self.previousWeightLabel.text = [self.numberFormatter stringFromNumber:@(self.previousShares * [self.priceNumber doubleValue] / self.netWorth)];
    self.previousReturnLabel.text = self.previousAverageCost == NSNotFound ? @"--" : [self.numberFormatter stringFromNumber:@([self.priceNumber doubleValue] / self.previousAverageCost - 1)];
    
    [self updateUI];
}

- (void)updateUI
{
    // Execute order button disabled if shares selected equals 0
    self.executeOrderButton.enabled = self.sharesSelected == 0 ? NO : YES;
    
    // Updates textField for new shares or weight selected
    [self updateTextField];

    //------------------------/
    /* CURRENCY FORMAT CELLS */
    //------------------------/
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    double newSharesTotal;
    if (self.isBuyOrder) {
        newSharesTotal = self.previousShares + self.sharesSelected;
    } else {
        newSharesTotal = self.previousShares - self.sharesSelected;
    }
    
    double newAverageCost;
    if (self.isBuyOrder) {
        newAverageCost = (self.previousShares / newSharesTotal) * self.previousAverageCost + (self.sharesSelected / newSharesTotal) * [self.priceNumber doubleValue];
    } else {
        newAverageCost = self.previousAverageCost;
    }
    
    self.updatedAverageCostLabel.text = newSharesTotal == 0 ? @"--" : [self.numberFormatter stringFromNumber:@(newAverageCost)];
    
    self.amountLabel.text = [self.numberFormatter stringFromNumber:@(self.amount)];
    
    self.commissionLabel.text = [self.numberFormatter stringFromNumber:@(self.amount * self.game.transactionCommissionRate)];
    
    //-----------------------/
    /* PERCENT FORMAT CELLS */
    //-----------------------/
    self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    
    self.updatedWeightLabel.text = [self.numberFormatter stringFromNumber:@((newSharesTotal) * [self.priceNumber doubleValue] / self.netWorth)];
    self.updatedReturnLabel.text = newSharesTotal == 0 ? @"--" : [self.numberFormatter stringFromNumber:@([self.priceNumber doubleValue] / newAverageCost - 1)];
    
    [self.tableView reloadData];
}

- (IBAction)buySellSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateUIForBuyOrSellSelection];
    
    [self updateTextFieldPlaceholder];
    
    [self updateUI];
}

- (void)updateUIForBuyOrSellSelection
{
    // Update Buy/Sell Execute Order Button
    self.executeOrderButton.title = self.isBuyOrder ? @"BUY" : @"SELL";
    
    self.amountDescriptionLabel.text = [NSString stringWithFormat:@"%@ Amount", self.isBuyOrder ? @"Puchase" : @"Sale"];
    
    [self reloadSlider];
}

- (IBAction)showPortfolioInfoButtonPressed:(UIButton *)sender
{
    self.showPortfolioInfo = !self.showPortfolioInfo;
    [self updateShowMoreInfoButton];
    [self updateUI];
}

- (void)updateShowMoreInfoButton
{
    [self.showMoreInfoButton setTitle:(self.showPortfolioInfo ? @"Less info" : @"More info") forState:UIControlStateNormal];
}


#pragma mark - Shares Selection Setup

- (void)reloadSlider
{
    /*
     Cash Available = $5,000
     Original Price = $100,  Maximum Shares = $5,000 / $100 = 50
     Price multiplier = 3 (MUST ALWAYS BE A POSITIVE INTEGER)
     Disguised Price = $300, Maximum Shares = $5,000 / $300 = 16
     */
    
    NSInteger maxValue;
    
    if (self.isBuyOrder) {
        maxValue = self.previousCash / ([self.priceNumber doubleValue] * (1 + self.game.transactionCommissionRate));
    } else {
        maxValue = self.previousShares;
    }
    
    self.slider.value = 0;
    self.slider.minimumValue = 0;
    self.slider.maximumValue = maxValue;
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    [self updateUI];
}

- (void)updateTextField
{
    if (self.showNumberOfShares) {
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        self.textField.text = [self.numberFormatter stringFromNumber:@(self.sharesSelected)];
    } else {
        self.textField.text = [NSString stringWithFormat:@"%.2f%%", self.amount / self.netWorth * 100];
    }
}

- (void)processTextFieldEnteredText
{
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *enteredNumber = [self.numberFormatter numberFromString:self.textField.text];
    if (enteredNumber) {
        if (self.showNumberOfShares) {
            NSInteger enteredShares = [enteredNumber integerValue];
            if (enteredShares >= 0 && enteredShares <= self.slider.maximumValue) {
                self.slider.value = enteredShares;
            }
        } else {
            double maxPercentValue = self.slider.maximumValue * [self.priceNumber doubleValue] / self.netWorth;
            double enteredPercent = [enteredNumber doubleValue] / 100;
            if (enteredPercent >= 0 && enteredPercent <= maxPercentValue) {
                self.slider.value = (NSInteger)(enteredPercent * self.netWorth / [self.priceNumber doubleValue]);
            }
        }
    }
    
    [self updateTextField];
    [self updateUI];
}

- (IBAction)sharesOrWeightSegmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateSharesOrWeightLabel];
    [self updateTextFieldPlaceholder];
    
    [self updateUI];
}

- (void)updateSharesOrWeightLabel
{
    self.sharesOrWeightLabel.text = self.showNumberOfShares ? @"Number of shares" : @"Weight in portfolio";
}

- (void)updateTextFieldPlaceholder
{
    NSInteger maxShares = self.slider.maximumValue;
    NSString *placeholder;
    if (self.showNumberOfShares) {
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        placeholder = [NSString stringWithFormat:@"0  -  %@", [self.numberFormatter stringFromNumber:@(maxShares)]];
    } else {
        double maxWeightPercent = maxShares * [self.priceNumber doubleValue] / self.netWorth * 100;
        placeholder = [NSString stringWithFormat:@"0.00  -  %.2f", maxWeightPercent];
    }
    
    self.textField.placeholder = placeholder;
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self processTextFieldEnteredText];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text containsString:@"."] && [string containsString:@"."]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return self.showPortfolioInfo ? 2 : 0;
    } else if (section == 3) {
        return self.showPortfolioInfo ? 2 : 0;
    } else if (section == 4) {
        return self.showPortfolioInfo ? 2 : 0;
    }

    return 0;
}

#pragma mark - UITableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.game UINameForTicker:self.ticker];
    } else if (section == 1) {
        return @"Select Order Quantity";
    } else if (section == 2 && self.showPortfolioInfo) {
        return @"Weight in Portfolio";
    } else if (section == 3 && self.showPortfolioInfo) {
        return @"Average Cost in Portfolio";
    } else if (section == 4 && self.showPortfolioInfo) {
        return @"Return in Portfolio";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
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

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = self.game.locale;
        _numberFormatter.maximumFractionDigits = 2;
    }
    
    return _numberFormatter;
}

- (BOOL)isBuyOrder
{
    return self.buySellSegmentedControl.selectedSegmentIndex == 0;
}

- (BOOL)showNumberOfShares
{
    return self.sharesOrWeightSegmentedControl.selectedSegmentIndex == 1;
}

- (double)amount
{
    return [self.priceNumber doubleValue] * self.sharesSelected;
}

- (NSInteger)sharesSelected
{
    return self.slider.value;
}

- (NSUInteger)priceMultiplier
{
    return [self.game UIPriceMultiplierForTicker:self.ticker];
}

#pragma mark - Order Execution

- (IBAction)cancelOrder:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// Executes the order in the game portfolio. Then calls the method to present an alert confirming the execution
- (IBAction)executeOrder:(id)sender
{
    Price *realPrice = self.game.currentPrices[self.ticker];
    double realPriceValue = [realPrice.price doubleValue];
    NSInteger realSharesSelected = self.sharesSelected * self.priceMultiplier;
    double commissionPaid = realPriceValue * realSharesSelected * self.game.transactionCommissionRate;
    
    BOOL success;
    
    if (self.isBuyOrder) {
        success = [self.game.portfolio investInStockWithTicker:self.ticker
                                                         price:realPriceValue
                                                numberOfShares:realSharesSelected
                                                commissionPaid:commissionPaid
                                                         atDay:[self.game currentDay]];
    } else {
        success = [self.game.portfolio deinvestInStockWithTicker:self.ticker
                                                           price:realPriceValue
                                                  numberOfShares:realSharesSelected
                                                  commissionPaid:commissionPaid
                                                           atDay:[self.game currentDay]];
    }
    
    [self presentTransactionAlertWithSuccess:success];
}


// Presents an alert confirming the order execution, with some information about the order.
// After user press Ok button in the alert, the handler calls the unwind method in the presentingViewController
// (Had to ctrl drag from File's Owner to Exit in the interface builder, so the unwind segue would be available programmatically)s
- (void)presentTransactionAlertWithSuccess:(BOOL)success
{
    NSString *alertTitle;
    NSString *alertMessage;
    
    if (success) {
        
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *sharesString = [self.numberFormatter stringFromNumber:@(self.sharesSelected)];
        
        self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        NSString *priceAsString = [self.numberFormatter stringFromNumber:self.priceNumber];
        
        alertTitle = [NSString stringWithFormat:@"%@ - %@ Order Executed", [self.game UITickerForTicker:self.ticker] , self.isBuyOrder ? @"Buy" : @"Sell"];
        alertMessage = [NSString stringWithFormat:@"%@ Shares at Price: %@", sharesString, priceAsString];
        
    } else {
        
        alertTitle = @"Error";
        alertMessage = @"Order NOT Executed.";
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self performSegueWithIdentifier:@"unwindFromBuySellTableViewController" sender:self];
        
    }];
    
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}











@end

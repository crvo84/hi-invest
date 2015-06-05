//
//  CompanyRatioInfoViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 3/26/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompanyRatioInfoViewController.h"
#import "InvestingGame.h"
#import "Price.h"
#import "Company.h"
#import "RatiosKeys.h"
#import "DefaultColors.h"
#import "BuySellTableViewController.h"
#import "DefinitionViewController.h"
#import "FinancialDatabaseManager.h"

@interface CompanyRatioInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *valueNameButton;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *infoLabelBackgroundView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buySellButton;
@property (strong, nonatomic) NSArray *values; // of NSNumber. ratios[0] = current ratio, ratio[1] = last year's...
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation CompanyRatioInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buySellButtonSetup];
    
//    self.infoLabelBackgroundView.backgroundColor = [[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    self.values = nil;
    
    [self.valueNameButton setTitle:self.valueId forState:UIControlStateNormal];
    
    self.companyNameLabel.text = [self.game UINameForTicker:self.ticker];
    
    [self setTextViewWithCorrespondingValueInfo];
    
    [self.tableView reloadData];
}

- (void)buySellButtonSetup
{
    UIColor *buttonColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    [self.buySellButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [self.buySellButton setTitleColor:[DefaultColors UIElementsBackgroundColor] forState:UIControlStateHighlighted];
    [self.buySellButton setBackgroundColor:[[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:0.15]];
    
    self.buySellButton.layer.borderWidth = 0.5;
    self.buySellButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIImage *buySellImage = [[UIImage imageNamed:@"arrows22x22"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.buySellButton setImage:buySellImage forState:UIControlStateNormal];
    [self.buySellButton setTintColor:buttonColor];
    self.buySellButton.imageView.image = buySellImage;
}

- (void)setTextViewWithCorrespondingValueInfo
{
    NSNumberFormatter *numberFormatterForInterpretation = [[NSNumberFormatter alloc] init];
    numberFormatterForInterpretation.locale = self.game.locale;
    numberFormatterForInterpretation.maximumFractionDigits = 2;
    
    NSString *valueAsText;
    NSString *interpretationStr;
    
    if ([FinancialRatioIdentifiersArray containsObject:self.valueId]) {
        
        numberFormatterForInterpretation.numberStyle = NSNumberFormatterCurrencyStyle;
        interpretationStr = FinancialRatiosInterpretationsDictionary[self.valueId];
    }
    
    if (interpretationStr) {
        valueAsText = [numberFormatterForInterpretation stringFromNumber:self.values[0]];
        self.infoLabel.text = [NSString stringWithFormat:interpretationStr, valueAsText];
    }
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.values) return 0;
    
    return [self.values count] < 2 ? [self.values count] : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self.values count] - 1;
    }
     
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Company Value Info Cell"];

    NSString *labelText;
    NSNumber *valueNumber;
    if (indexPath.section == 0) {
        labelText = self.valueId;
        valueNumber = self.values[0];
    } else if (indexPath.section == 1) {
        labelText = [NSString stringWithFormat:@"%ld Year%@ Ago", (long)indexPath.row + 1, indexPath.row == 0 ? @"" : @"s"];
        valueNumber = self.values[indexPath.row + 1];
    }
    
    cell.textLabel.text = [self.numberFormatter stringFromNumber:valueNumber];
    cell.detailTextLabel.text = labelText;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}


#pragma mark - Getters

//NSArray of NSNumber. value[0] = current value, value[1] = last year's value...
- (NSArray *)values
{
    if (!_values) {
        NSMutableArray *availableValues = [[NSMutableArray alloc] init];
 
        NSInteger index = 0;
        
        Price *price = self.game.currentPrices[self.ticker];
        
        NSDictionary *valueInfo;
        BOOL justCurrentValue = NO;
        if ([FinancialRatioIdentifiersArray containsObject:self.valueId]) {
            
            valueInfo = [FinancialDatabaseManager dictionaryOfRatioValuesForCompanyWithPrice:price withRatiosIdentifiers:@[self.valueId] fromManagedObjectContext:self.game.scenarioContext];
            
        }
        
        while (valueInfo && valueInfo[self.valueId]) {
            
            availableValues[index] = valueInfo[self.valueId];
            
            price = [FinancialDatabaseManager priceWithTimeDifferenceInYears:-1 months:0 days:0 fromPrice:price roundingToLaterPrice:NO];
            
            if (justCurrentValue) break;
            
            valueInfo = [FinancialDatabaseManager dictionaryOfRatioValuesForCompanyWithPrice:price withRatiosIdentifiers:@[self.valueId] fromManagedObjectContext:self.game.scenarioContext];
            
            index++;
        }
        
        _values = availableValues;
    }
    
    return _values;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = self.game.locale;
        _numberFormatter.maximumFractionDigits = 2;
        
        if ([FinancialRatioIdentifiersArray containsObject:self.valueId]) {
            if ([FinancialSortingValuesPercentValuesArray containsObject:self.valueId]) {
                self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
            } else {
                self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            }
        }
    }
    
    return _numberFormatter;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // BUY SELL VIEW CONTROLLER SEGUE
    UIViewController *viewController = segue.destinationViewController;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        viewController = [((UINavigationController *)segue.destinationViewController).viewControllers firstObject];
    }
    if ([viewController isKindOfClass:[BuySellTableViewController class]]) {
        BuySellTableViewController *buySellTableViewController = (BuySellTableViewController *)viewController;
        [self prepareBuySellTableViewController:buySellTableViewController
                                     withTicker:self.ticker
                               andInvestingGame:self.game];
    }
    
    // DEFINITION VIEW CONTROLLER SEGUE
    if ([segue.destinationViewController isKindOfClass:[DefinitionViewController class]]) {
        NSString *definition = FinancialRatiosDefinitionsDictionary[self.valueId];
        NSString *formulaImageFilename = FinancialRatiosImageFilenamesDictionary[self.valueId];
        [self prepareDefinitionViewController:segue.destinationViewController withDefinitionId:self.valueId withDefinition:definition withFormulaImageFilename:formulaImageFilename];
    }
}

- (void)prepareBuySellTableViewController:(BuySellTableViewController *)buySellTableViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    buySellTableViewController.game = game;
    buySellTableViewController.ticker = ticker;
}

- (void)prepareDefinitionViewController:(DefinitionViewController *)definitionViewController withDefinitionId:(NSString *)definitionId withDefinition:(NSString *)definition withFormulaImageFilename:(NSString *)formulaImageFilename
{
    definitionViewController.definitionId = definitionId;
    definitionViewController.definition = definition;
    definitionViewController.formulaImageFilename = formulaImageFilename;
}








@end

//
//  CompanyInfoViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/16/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "FinancialDatabaseManager.h"
#import "DefaultColors.h"
#import "RatiosKeys.h"
#import "CompanyRatioInfoViewController.h"
#import "BuySellTableViewController.h"
#import "InvestingGame.h"
#import "Company.h"
#import "Price.h"

@interface CompanyInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buySellButton;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) Price *price;
/* Financial Ratios Data */
@property (strong, nonatomic) NSDictionary *ratioValues;
@property (strong, nonatomic) NSArray *ratioIdentifiers;

@end

@implementation CompanyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buySellButtonSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.ticker) {
        [self updateUI]; // UpdatingUI is done here to update when switching tabs
    }
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

#pragma mark - Updating UI

- (void)updateUI
{
    self.price = nil;
    self.ratioValues = nil;
    self.ratioIdentifiers = nil;
    
    if (self.price) {
        self.companyNameLabel.text = [self.game UINameForTicker:self.ticker];
        self.companyDescriptionLabel.text = self.price.company.sicDescription;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Setters

#pragma mark - Getters

- (Price *)price
{
    if (!_price) {
        _price = self.game.currentPrices[self.ticker];
    }
    
    return _price;
}

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.locale = self.game.locale;
        _numberFormatter.maximumFractionDigits = 2;
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    return _numberFormatter;
}

  //------------------------/
 /* Financial Ratios Data */
//------------------------/

- (NSDictionary *)ratioValues
{
    if (!_ratioValues) {
        _ratioValues = [FinancialDatabaseManager dictionaryOfRatioValuesForCompanyWithPrice:self.price withRatiosIdentifiers:FinancialRatioIdentifiersArray fromManagedObjectContext:self.price.managedObjectContext];
    }
    
    return _ratioValues;
}

- (NSArray *)ratioIdentifiers
{
    if (!_ratioIdentifiers) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        NSArray *validRatiosIds = [self.ratioValues allKeys];
        for (int i = 0; i < [FinancialRatioIdentifiersArray count]; i++) {
            NSString *ratioIdentifier = FinancialRatioIdentifiersArray[i];
            if ([validRatiosIds containsObject:ratioIdentifier]) {
                [result addObject:ratioIdentifier];
            }
        }
        
        _ratioIdentifiers = result;
    }
    
    return _ratioIdentifiers;
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.ratioIdentifiers count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Ratio Cell"];

    if (indexPath.section == 0) {
        NSString *identifier = self.ratioIdentifiers[indexPath.row];
        NSNumber *ratioValue = self.ratioValues[identifier];
        
        cell.textLabel.text = identifier;
        cell.detailTextLabel.text = [self textForValueOfRatioIdentifier:identifier withNumber:ratioValue];
    }
    
    return cell;
}


- (NSString *)textForValueOfRatioIdentifier:(NSString *)identifier withNumber:(NSNumber *)ratioNumber
{
    if ([FinancialSortingValuesPercentValuesArray containsObject:identifier]) {
        self.numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    } else {
        self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    
    return [self.numberFormatter stringFromNumber:ratioNumber];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Financial Ratios";
    
    return nil;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // COMPANY RATIO INFO VIEW CONTROLLER SEGUE
    if ([segue.identifier isEqualToString:@"Company Ratio Info"]) {
        if ([segue.destinationViewController isKindOfClass:[CompanyRatioInfoViewController class]]) {
            if ([sender isKindOfClass:[UITableViewCell class]]) {
                
                NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
                NSString *ratioId = self.ratioIdentifiers[indexPath.row];
                
                if (ratioId) {
                    [self prepareCompanyRatioInfoViewController:segue.destinationViewController withInvestingGame:self.game withTicker:self.ticker andFinancialRatioIdentifier:ratioId];
                }
                
            }
        }
    }
    
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
}

- (void)prepareBuySellTableViewController:(BuySellTableViewController *)buySellTableViewController withTicker:(NSString *)ticker andInvestingGame:(InvestingGame *)game
{
    buySellTableViewController.game = game;
    buySellTableViewController.ticker = ticker;
}

- (void)prepareCompanyRatioInfoViewController:(CompanyRatioInfoViewController *)companyRatioInfoViewController withInvestingGame:(InvestingGame *)game withTicker:(NSString *)ticker andFinancialRatioIdentifier:(NSString *)ratioId
{
    companyRatioInfoViewController.game = game;
    companyRatioInfoViewController.ticker = ticker;
    companyRatioInfoViewController.valueId = ratioId;
}









































@end

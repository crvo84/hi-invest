//
//  InfoPageContentViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "InfoPageContentViewController.h"
#import "FinancialDatabaseManager.h"
#import "DefaultColors.h"
#import "InvestingGame.h"
#import "Price.h"

@interface InfoPageContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation InfoPageContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    self.infoLabel.text = [self currentInfoForIndex:self.pageIndex];
}

// Return a NSString with game information depending on the given index. 0 based index.
- (NSString *)currentInfoForIndex:(NSUInteger)index
{
    NSString *infoStr = nil;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = self.game.locale;
    numberFormatter.maximumFractionDigits = 2;
    
    if (index == 0) {
        
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *currentDayStr = [numberFormatter stringFromNumber:@([self.game currentDay])];
        infoStr = [NSString stringWithFormat:@"Current day: %@", currentDayStr];
        
    } else if (index == 1) {
        
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *daysLeftStr = [numberFormatter stringFromNumber:@([self.game daysLeft])];
        infoStr = [NSString stringWithFormat:@"Days left: %@", daysLeftStr];
        
    } else if (index == 2) {
        
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        NSString *currentNetworthStr = [numberFormatter stringFromNumber:@([self.game currentNetWorth])];
        infoStr = [NSString stringWithFormat:@"Net Worth: %@", currentNetworthStr];
        
    } else if (index == 3) {
        
        numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
        double yearsToDate = [self.game currentDay] / 365.0;
        double annualizedReturn = pow([self.game currentNetWorth] / [self.game initialNetworth], 1 / yearsToDate) - 1;
        NSString *annualizedReturnStr = [numberFormatter stringFromNumber:@(annualizedReturn)];
        infoStr = [NSString stringWithFormat:@"Annual. portfolio return: %@", annualizedReturnStr];
        
    } else if (index == 4) {
        numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
        double yearsToDate = [self.game currentDay] / 365.0;
        NSNumber *currentMarketPriceNumber = [self.game scenarioMarketPriceAtDate:self.game.currentDate];
        NSNumber *initialMarketPriceNumber = [self.game scenarioMarketPriceAtDate:self.game.initialDate];
        NSString *annualizedMarketReturnStr = @"N/A";
        if (currentMarketPriceNumber && initialMarketPriceNumber) {
            double annualizedMarketReturn = pow([currentMarketPriceNumber doubleValue] / [initialMarketPriceNumber doubleValue], 1 / yearsToDate) - 1;
            annualizedMarketReturnStr = [numberFormatter stringFromNumber:@(annualizedMarketReturn)];
        }
        infoStr = [NSString stringWithFormat:@"Annual. market return: %@", annualizedMarketReturnStr];
    }
    
    return infoStr;
}

@end

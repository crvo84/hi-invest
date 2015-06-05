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

@property (weak, nonatomic) IBOutlet UIView *daySubview;
@property (weak, nonatomic) IBOutlet UIView *returnSubview;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


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
    if (self.pageIndex == 0) {

        self.returnSubview.hidden = YES;
        self.daySubview.hidden = NO;
        self.dayLabel.attributedText = [self dayLabelAttributedString];
        
    } else {
        
        self.daySubview.hidden = YES;
        self.returnSubview.hidden = NO;
        
        BOOL annualized = [self.game currentDay] > 365;

        NSString *titleStr;
        double returnValue;
        
        if (self.pageIndex == 1) { // Portfolio info
            
            titleStr = @"Your portfolio";
            returnValue = annualized ? [self.game currentPortfolioAnnualizedReturn] : [self.game currentPortfolioReturn];
            
        } else { // Market info
            
            titleStr = @"Benchmark";
            returnValue = annualized ? [self.game currentMarketAnnualizedReturn] : [self.game currentMarketReturn];
        }
        
        NSString *initialStr = annualized ? @"Annualized Return: " : @"Return: ";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:initialStr];

        [attrStr appendAttributedString:[DefaultColors attributedStringForReturn:returnValue forDarkBackground:YES]];
        
        self.titleLabel.text = titleStr;
        self.returnLabel.attributedText = attrStr;
    }
    
}

- (NSAttributedString *)dayLabelAttributedString
{
    NSMutableAttributedString *attributedStr = nil;
    
    if (self.game.finishedSuccessfully) {
        
        attributedStr = [[NSMutableAttributedString alloc] initWithString:@"FINISHED"];
        
    } else {
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = self.game.locale;
        numberFormatter.maximumFractionDigits = 2;
        
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *currentDayStr = [numberFormatter stringFromNumber:@([self.game currentDay])];
        attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Day %@", currentDayStr]];
    }
    
    return attributedStr;
}






@end

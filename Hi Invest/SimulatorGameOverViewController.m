//
//  SimulatorGameOverViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/28/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SimulatorGameOverViewController.h"
#import "DefaultColors.h"
#import "InvestingGame.h"
#import "Scenario.h"

@interface SimulatorGameOverViewController ()

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UIView *infoSubsubview;
@property (weak, nonatomic) IBOutlet UILabel *scenarioNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *portfolioReturnLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketReturnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userMedalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *marketMedalImageView;

@end

@implementation SimulatorGameOverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    self.subview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    self.infoSubsubview.backgroundColor = [DefaultColors speechBubbleBorderColor];
    self.infoSubsubview.layer.cornerRadius = 8;
    self.infoSubsubview.layer.borderWidth = 1;
    self.infoSubsubview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // Medal image views setup
    UIImage *medalImage = [[UIImage imageNamed:@"medal22x22"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIColor *medalColor = [UIColor colorWithRed:204.0/255.0 green:152.0/255.0 blue:0.0 alpha:1.0];
    [self.userMedalImageView setImage:medalImage];
    [self.marketMedalImageView setImage:medalImage];
    [self.userMedalImageView setTintColor:medalColor];
    [self.marketMedalImageView setTintColor:medalColor];
    
    [self updateUI];
}

- (void)updateUI
{
    NSInteger days = [self.game currentDay];
    
    BOOL annualized = days > 365;
    
    double portfolioReturn;
    double marketReturn;
    
    if (annualized) {
        
        portfolioReturn = [self.game currentPortfolioAnnualizedReturn];
        marketReturn = [self.game currentMarketAnnualizedReturn];
        
    } else {
        
        portfolioReturn = [self.game currentPortfolioReturn];
        marketReturn = [self.game currentMarketReturn];
    }
    
    // SCENARIO LABEL
    self.scenarioNameLabel.text = [self.game.scenarioInfo.name uppercaseString];
    
    // DAYS LABEL
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = self.game.locale;
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *daysStr = [numberFormatter stringFromNumber:@(days)];
    NSString *annualStr = annualized ? @"Ann. Return" : @"Return";
    
    self.daysLabel.text = [NSString stringWithFormat:@"%@ (%@ days)", annualStr, daysStr];
    
    // PORTFOLIO RETURN LABEL
    self.portfolioReturnLabel.attributedText = [DefaultColors attributedStringForReturn:portfolioReturn forDarkBackground:YES];
    
    // MARKET RETURN LABEL
    self.marketReturnLabel.attributedText = [DefaultColors attributedStringForReturn:marketReturn forDarkBackground:YES];
    
    // MEDALS IMAGE VIEWS
    self.userMedalImageView.hidden = portfolioReturn <= marketReturn;
    self.marketMedalImageView.hidden = portfolioReturn > marketReturn;
}


#pragma mark - Dismissing View Controller

// Call cancel method when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)resetInvestingGame:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToSideMenuRootViewController Reset Game" sender:self];
}





@end

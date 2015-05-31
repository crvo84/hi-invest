//
//  SettingsTableViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "UserAccount.h"
#import "InvestingGame.h"

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *initialCashLabel;
@property (weak, nonatomic) IBOutlet UIStepper *initialCashStepper;
@property (weak, nonatomic) IBOutlet UISwitch *disguiseCompaniesSwitch;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (weak, nonatomic) IBOutlet UIButton *resetSimulatorButton;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialCashStepper.stepValue = 50000;
    self.initialCashStepper.minimumValue = 50000;
    self.initialCashStepper.maximumValue = 1000000000;
    
    [self updateUI];
}


- (void)updateUI
{
    // Initial cash
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.initialCashLabel.text = [self.numberFormatter stringFromNumber:@(self.userAccount.simulatorInitialCash)];
    self.initialCashStepper.value = self.userAccount.simulatorInitialCash;
    
    // Disguise companies
    [self.disguiseCompaniesSwitch setOn:self.userAccount.disguiseCompanies animated:NO];
    
    // Reset simulator button
    self.resetSimulatorButton.enabled = self.userAccount.currentInvestingGame != nil;
}

- (IBAction)initialCashStepperValueChanged:(UIStepper *)sender
{
    if (self.userAccount.currentInvestingGame) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Simulator needs to be reset."
                                                                       message:@"Do you want to continue?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.userAccount exitInvestingGame];
            self.userAccount.simulatorInitialCash = self.initialCashStepper.value;
            [self updateUI];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:continueAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        self.userAccount.simulatorInitialCash = self.initialCashStepper.value;
        [self updateUI];

    }

}

- (IBAction)disguiseCompaniesSwitchValueChanged:(UISwitch *)sender
{
    if (self.userAccount.currentInvestingGame) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Simulator needs to be reset."
                                                                       message:@"Do you want to continue?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.userAccount exitInvestingGame];
            self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.on;
            [self updateUI];

        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self updateUI];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:continueAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.on;
    }


}

- (IBAction)resetSimulatorButtonPressed:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset simulator?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.userAccount exitInvestingGame];
        self.resetSimulatorButton.enabled = NO;
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Getters

- (NSNumberFormatter *)numberFormatter
{
    if (!_numberFormatter) {
        
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.maximumFractionDigits = 0;
        
        if (self.userAccount.currentInvestingGame) {
            _numberFormatter.locale = self.userAccount.currentInvestingGame.locale;
        } else {
            _numberFormatter.locale = self.userAccount.localeDefault;
        }
    }
    
    return _numberFormatter;
}

















@end

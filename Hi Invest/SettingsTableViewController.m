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

#import <Parse/Parse.h>

@interface SettingsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *initialCashLabel;
@property (weak, nonatomic) IBOutlet UIStepper *initialCashStepper;
@property (weak, nonatomic) IBOutlet UISwitch *disguiseCompaniesSwitch;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (nonatomic) BOOL onlyForNewGamesAlertPresented;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialCashStepper.stepValue = 50000;
    self.initialCashStepper.minimumValue = 50000;
    self.initialCashStepper.maximumValue = 1000000000;
    self.initialCashStepper.value = self.userAccount.simulatorInitialCash;
    
    self.disguiseCompaniesSwitch.on = self.userAccount.disguiseCompanies;

    self.onlyForNewGamesAlertPresented = NO;

    
    [self updateUI];
}


- (void)updateUI
{
    // Initial cash
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.initialCashLabel.text = [self.numberFormatter stringFromNumber:@(self.initialCashStepper.value)];

    // TODO: add log in with facebook to link guest user with facebook account
}


- (IBAction)initialCashStepperValueChanged:(UIStepper *)sender
{
    if (!self.onlyForNewGamesAlertPresented) {
        [self presentOnlyForNewGamesAlert];
        self.onlyForNewGamesAlertPresented = YES;
    }
    
    self.userAccount.simulatorInitialCash = self.initialCashStepper.value;

    [self updateUI];
}


- (IBAction)disguiseCompaniesSwitchValueChanged:(UISwitch *)sender
{
    if (!self.onlyForNewGamesAlertPresented) {
        [self presentOnlyForNewGamesAlert];
        self.onlyForNewGamesAlertPresented = YES;
    }
    
    self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.isOn;
    
    [self updateUI];
}

- (void)presentOnlyForNewGamesAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Changes will apply for new games only."
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)logout:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [PFUser logOut];
        [self performSegueWithIdentifier:@"logout" sender:self];
        
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

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
#import "UserDefaultsKeys.h"
#import "ParseUserKeys.h"
#import "ScenariosKeys.h"
#import "GameInfo+Create.h"
#import "ManagedObjectContextCreator.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "SideMenuRootViewController.h"

#import <StoreKit/StoreKit.h>
#import <iAd/iAd.h>


@interface SettingsTableViewController () <SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UILabel *initialCashLabel;
@property (weak, nonatomic) IBOutlet UIStepper *initialCashStepper;
@property (weak, nonatomic) IBOutlet UISwitch *disguiseCompaniesSwitch;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL isAnonymousUser;

@property (weak, nonatomic) IBOutlet UIButton *removeAdsPurchaseButton;

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

    self.isAnonymousUser = [PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]];
    
    SKProduct *removeAdsProduct = self.userAccount.products[RemoveAdsInAppPurchase];
    if (removeAdsProduct) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
        numberFormatter.maximumFractionDigits = 2;
        numberFormatter.locale = removeAdsProduct.priceLocale;
        NSString *priceStr = [numberFormatter stringFromNumber:removeAdsProduct.price];
        [self.removeAdsPurchaseButton setTitle:priceStr forState:UIControlStateNormal];
    }
    
    [self updateUI];
}

- (void)updateUI
{
    // Initial cash
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.initialCashLabel.text = [self.numberFormatter stringFromNumber:@(self.initialCashStepper.value)];
    
    [self.tableView reloadData];
}


- (IBAction)initialCashStepperValueChanged:(UIStepper *)sender
{
    self.userAccount.simulatorInitialCash = self.initialCashStepper.value;

    [self updateUI];
}


- (IBAction)disguiseCompaniesSwitchValueChanged:(UISwitch *)sender
{
    if (!sender.isOn) {
        [self presentAlertViewWithTitle:@"Disguise disabled" withMessage:@"Simulator results will not be recorded." withActionTitle:@"Dismiss"];
    }
    
    self.userAccount.disguiseCompanies = self.disguiseCompaniesSwitch.isOn;
    
    [self updateUI];
}


#pragma mark - User Login/Logout

- (IBAction)logout:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self pauseUI];
    
        [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
            
            [self unpauseUI];
            
            if (!error) {
                
                [self performSegueWithIdentifier:@"logout" sender:self];
                
            } else {

                [self presentAlertViewWithTitle:@"Could not Log Out" withMessage:[error localizedDescription] withActionTitle:@"Dismiss"];
            }
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)connectToFacebook:(id)sender
{
    [self pauseUI];
    
    PFUser *user = [PFUser currentUser];

    if (!user.objectId) {
        
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                // The object has been saved.
                [self.userAccount migrateUserInfoToParseUser];
                
                [self linkParseUserWithFacebookAccount];
                
            }  else {

                NSString *message = error ? [error localizedDescription] : @"Please try again";
                [self presentAlertViewWithTitle:@"Could not connect to Facebook" withMessage:message withActionTitle:@"Dismiss"];
            }
            
            [self unpauseUI];
        }];
        
    } else { // Parse user already in the cloud
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultsInfoSavedInParseUser]) {
            [self.userAccount migrateUserInfoToParseUser];
        }
        
        [self linkParseUserWithFacebookAccount];
    }
}

- (void)linkParseUserWithFacebookAccount
{
    PFUser *user = [PFUser currentUser];
    
    NSArray *permissions = @[@"public_profile", @"email", @"user_friends"];
    
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:permissions block:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                
                self.isAnonymousUser = NO;
                
                SideMenuRootViewController *sideMenuRootViewController = (SideMenuRootViewController *)self.sideMenuViewController;
                [sideMenuRootViewController loadFacebookUserInfo];
                
            }
            
            [self updateUI];
            
            [self unpauseUI];
            
            NSString *title = succeeded ? @"Facebook connection successful!" : @"Could not connect to Facebook";
            NSString *message = succeeded ? nil : [error localizedDescription];
            [self presentAlertViewWithTitle:title withMessage:message withActionTitle:@"Dismiss"];
            
        }];
        
    } else {
        [self unpauseUI];
    }
}

- (void)presentAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pauseUI
{
    if (![self.activityIndicator isAnimating]) {
        [self.activityIndicator startAnimating];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if (![app isIgnoringInteractionEvents]) {
        [app beginIgnoringInteractionEvents];
    }
}

- (void)unpauseUI
{
    if ([self.activityIndicator isAnimating]) {
        [self.activityIndicator stopAnimating];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app isIgnoringInteractionEvents]) {
        [app endIgnoringInteractionEvents];
    }
}

#pragma mark - In-App Purchases

- (IBAction)removeAdsPurchaseButtonPressed
{
    SKProduct *removeAdsProduct = self.userAccount.products[RemoveAdsInAppPurchase];
    
    if (removeAdsProduct) {
        [self purchase:removeAdsProduct];
    }
}

- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)restorePurchasesButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Restore previous purchases?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Restore" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self restorePurchases];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)restorePurchases
{
    // Need to add self as observer for the delegate to be called. Must be removed in dealloc.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //this is called when the user restores purchases
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *transaction in transactions) {
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                //you can add your code for what you want to happen when the user buys the purchase here.
                //                [self.userAccount setAccessOpenToScenarioWithFilename:transaction.payment.productIdentifier];
                if ([transaction.payment.productIdentifier isEqualToString:RemoveAdsInAppPurchase]) {
                    [self.userAccount removeAds];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                //                [self.userAccount setAccessOpenToScenarioWithFilename:transaction.payment.productIdentifier];
                if ([transaction.payment.productIdentifier isEqualToString:RemoveAdsInAppPurchase]) {
                    [self.userAccount removeAds];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled) {
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
    
    self.canDisplayBannerAds = [self.userAccount shouldPresentAds];
    [self updateUI];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // Do not need to do anything here, just alert the user that the purchases have been restored
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
    
    [self presentAlertViewWithTitle:@"Purchases restored" withMessage:@"Your previously purchased products have been restored." withActionTitle:@"Dismiss"];
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isAnonymousUser) {
        return 5;
    } else {
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && ![self.userAccount shouldPresentAds]) {
        return 0;
    }
    
    return 1;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && ![self.userAccount shouldPresentAds]) {
        return 0.1;
    }
    
    return 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0 && [self.userAccount shouldPresentAds]) {
        return @"Remove Ads (One-Time Payment)";
        
    } else if (section == 1) {
        return @"Initial Cash";
        
    } else if (section == 2) {
        return @"Companies";
        
    } else if (section == 3) {
        return @"User Account";
    }
    
    return nil;
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

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activityIndicator.center = self.view.center;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_activityIndicator];
    }
    
    return _activityIndicator;
}









@end

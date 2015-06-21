//
//  UserAccountViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccountViewController.h"
#import "ManagedObjectContextCreator.h"
#import "UserAccount.h"
#import "GameInfo+Create.h"
#import "DefaultColors.h"
#import "ScenarioTableViewCell.h"
#import "ScenarioPurchaseInfo.h"
#import "ScenarioInfoViewController.h"
#import "UserDefaultsKeys.h"
#import "ScenariosKeys.h"
#import "UserInfoViewController.h"
#import "PurchaseScenarioViewController.h"

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#import <StoreKit/StoreKit.h>

@interface UserAccountViewController () <UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (weak, nonatomic) IBOutlet UIView *backgroundUserView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *friendsBarButtonItem;

@property (strong, nonatomic) SKProduct *productSelected;

@end

@implementation UserAccountViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Background User View Setup
    self.backgroundUserView.layer.cornerRadius = 8;
    self.backgroundUserView.layer.masksToBounds = YES;
    self.backgroundUserView.backgroundColor = [DefaultColors userLevelColorForLevel:[self.userAccount userLevel]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    // Background User View and User Image View Setup
    NSData *pictureData = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsProfilePictureKey];
    if (pictureData) {
        
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:self.backgroundUserView.bounds];
        pictureImageView.image = [UIImage imageWithData:pictureData];
        pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.backgroundUserView addSubview:pictureImageView];
        
        self.userImageView.hidden = YES;
        self.backgroundUserView.layer.borderWidth = 0.0;
        
    } else {
        
        if ([self.userAccount userLevel] == 0) {
            
            self.backgroundUserView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundUserView.layer.borderWidth = 1;
        }
        
        self.userImageView.hidden = NO;
    }
    
    // Name Label Setup
    self.userNameLabel.text = [self.userAccount userName];
    
    [self.tableView reloadData];
}


#pragma mark - UITableView Data Source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return [self.userAccount.availableScenarios count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ScenarioTableViewCell *scenarioCell = [self.tableView dequeueReusableCellWithIdentifier:@"Scenario Cell"];
    
    ScenarioPurchaseInfo *scenarioPurchaseInfo = self.userAccount.availableScenarios[indexPath.row];
    
    // Name Label
    [scenarioCell.nameButton setTitle:scenarioPurchaseInfo.name forState:UIControlStateNormal];
    
    // Purchase Button
    NSString *priceStr;
    
    if ([self.userAccount isAccessOpenToScenarioWithFilename:scenarioPurchaseInfo.filename]) {
        priceStr = @"Select";
        
    } else {
        priceStr = [NSString stringWithFormat:@"Buy"];
    }
    [scenarioCell.purchaseButton setTitle:priceStr forState:UIControlStateNormal];
    
    
    // Scenario Selection
    if ([self.userAccount.selectedScenarioFilename isEqualToString:scenarioPurchaseInfo.filename]) {
        scenarioCell.purchaseButton.hidden = YES;
        scenarioCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        scenarioCell.purchaseButton.hidden = NO;
        scenarioCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Saved game info
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = self.userAccount.localeDefault;
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    GameInfo *gameInfo = [GameInfo existingGameInfoWithScenarioFilename:scenarioPurchaseInfo.filename withUserId:[self.userAccount userId] intoManagedObjectContext:self.userAccount.gameInfoContext];
    
    BOOL gameExistsAlready = gameInfo != nil;
    
    if (gameExistsAlready) { // existing game for scenario
        
        NSString *initialStr = [NSString stringWithFormat:@"Day %@ | ", [numberFormatter stringFromNumber:gameInfo.currentDay]];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:initialStr];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor darkGrayColor]
                              range:NSMakeRange(0, attributedStr.length)];
        
        [attributedStr appendAttributedString:[DefaultColors attributedStringForReturn:[gameInfo.currentReturn doubleValue] forDarkBackground:NO]];
        
        scenarioCell.titleLabel.attributedText = attributedStr;
        
    } else {
        
        // No saved game
        scenarioCell.titleLabel.text = @"No saved game";
        scenarioCell.titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    scenarioCell.deleteButton.hidden = !gameExistsAlready;
    
    scenarioCell.nameButton.tag = indexPath.row;
    scenarioCell.purchaseButton.tag = indexPath.row;
    scenarioCell.deleteButton.tag = indexPath.row;
    
    return scenarioCell;
}

#pragma mark - UITableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Simulator Scenarios";
        
    } 
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"More coming soon...";
    }
    
    return nil;
}

#pragma mark - Scenario Cell

- (IBAction)deleteGameButtonPressed:(UIButton *)sender
{
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    NSString *scenarioName = scenarioInfo.name;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Game?"
                                                                   message:scenarioName
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [GameInfo removeExistingGameInfoWithScenarioFilename:scenarioInfo.filename withUserId:[self.userAccount userId]  intoManagedObjectContext:self.userAccount.gameInfoContext];
        
        if (self.userAccount.currentInvestingGame) {
            if ([self.userAccount.selectedScenarioFilename isEqualToString:scenarioInfo.filename]) {
                [self.userAccount exitCurrentInvestingGame];
            }
        }
        
        [self updateUI];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - In-App Purchases

// Called from ScenarioTableViewCell Button. Select scenario or purchase it.
- (IBAction)purchaseButtonPressed:(UIButton *)sender
{
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    NSString *scenarioFilename = scenarioInfo.filename;
    
    if ([self.userAccount isAccessOpenToScenarioWithFilename:scenarioFilename]) {
        self.userAccount.selectedScenarioFilename = scenarioFilename;
        [self.userAccount exitCurrentInvestingGame];
        
    } else {
        [self purchaseRequestWithProductId:scenarioFilename];
    }
    
    [self updateUI];
}

// Scenario filename is the same as the product Id in iTunes Connect
- (void)purchaseRequestWithProductId:(NSString *)productId
{
    if([SKPaymentQueue canMakePayments]) {
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else {
        //this is called the user cannot make payments, most likely due to parental controls
        [self presentAlertViewWithTitle:@"In-App Purchases Disabled" withMessage:nil withActionTitle:@"Dismiss"];
    }
}

- (IBAction)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// To be called from SideMenuRootViewController when unwinding from PurchaseScenarioViewController
- (void)purchaseSelectedProduct
{
    if (self.productSelected) {
        [self purchase:self.productSelected];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    NSInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");

        self.productSelected = validProduct;
        [self performSegueWithIdentifier:@"Purchase Scenario" sender:self];
        
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
        [self presentAlertViewWithTitle:@"No Product Information" withMessage:@"Please try again." withActionTitle:@"Dismiss"];
    }
}

#pragma mark - Restoring Purchases

- (void)restore
{
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
                [self.userAccount setAccessOpenToScenarioWithFilename:transaction.payment.productIdentifier];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [self.userAccount setAccessOpenToScenarioWithFilename:transaction.payment.productIdentifier];
                
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ScenarioInfoViewController class]]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSInteger tag = ((UIButton *)sender).tag;
            ScenarioPurchaseInfo *scenarioPurchaseInfo = self.userAccount.availableScenarios[tag];
            BOOL isFileAtBundle = [ManagedObjectContextCreator databaseExistsAtBundleWithFilename:scenarioPurchaseInfo.filename];
            [self prepareScenarioInfoViewController:segue.destinationViewController withUserAccount:self.userAccount scenarioPurchaseInfo:scenarioPurchaseInfo locale:self.userAccount.localeDefault isFileInBundle:isFileAtBundle];
        }
    }
    
    if ([segue.destinationViewController isKindOfClass:[UserInfoViewController class]]) {
        [self prepareUserInfoViewController:segue.destinationViewController withUserAccount:self.userAccount];
    }
    
    if ([segue.destinationViewController isKindOfClass:[PurchaseScenarioViewController class]]) {
        ((PurchaseScenarioViewController *)segue.destinationViewController).product = self.productSelected;
    }
}

- (void)prepareScenarioInfoViewController:(ScenarioInfoViewController *)scenarioInfoViewController withUserAccount:(UserAccount *)userAccount scenarioPurchaseInfo:(ScenarioPurchaseInfo *)scenarioPurchaseInfo locale:(NSLocale *)locale isFileInBundle:(BOOL)isFileInBundle
{
    scenarioInfoViewController.userAccount = userAccount;
    scenarioInfoViewController.scenarioPurchaseInfo = scenarioPurchaseInfo;
    scenarioInfoViewController.locale = locale;
    scenarioInfoViewController.isFileInBundle = isFileInBundle;
}

- (void)prepareUserInfoViewController:(UserInfoViewController *)userInfoViewController withUserAccount:(UserAccount *)userAccount
{
    userInfoViewController.userAccount = userAccount;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Friends"]) {
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            return YES;
        } else {
            [self presentAlertViewWithTitle:@"No Information Available" withMessage:@"Please log in with Facebook and try again." withActionTitle:@"Dismiss"];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Helper Methods

- (void)presentAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withActionTitle:(NSString *)actionTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:continueAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end

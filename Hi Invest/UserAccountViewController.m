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

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface UserAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundUserView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *userLevelProgressView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserAccountViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Background User View Setup
    self.backgroundUserView.layer.cornerRadius = 8;
    self.backgroundUserView.layer.masksToBounds = YES;
    self.backgroundUserView.backgroundColor = [DefaultColors userLevelColorForLevel:[self.userAccount userLevel]];
    
    // Progress view
    [self.userLevelProgressView setProgress:([self.userAccount progressForNextUserLevel])];

    // Background User View and User Image View Setup
    NSData *pictureData = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsProfilePictureKey];
    if (pictureData) {
        
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:self.backgroundUserView.bounds];
        pictureImageView.image = [UIImage imageWithData:pictureData];
        [self.backgroundUserView addSubview:pictureImageView];
        
        self.userImageView.alpha = 0.0;
        
    } else {
        
        if ([self.userAccount userLevel] == 0) {
            
            self.backgroundUserView.layer.borderColor = [UIColor grayColor].CGColor;
            self.backgroundUserView.layer.borderWidth = 1;
        }
        
        self.userImageView.alpha = 1.0;
    }
    
    // Name Label Setup
    self.userNameLabel.text = [self.userAccount userName];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
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
    if (scenarioPurchaseInfo.price == 0) {
        priceStr = scenarioPurchaseInfo.withAdds ? @"Ads" : @"Free";
        
    } else {
        priceStr = [NSString stringWithFormat:@"$%.2f", scenarioPurchaseInfo.price];
        
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
    
    GameInfo *gameInfo = [GameInfo existingGameInfoWithScenarioFilename:scenarioPurchaseInfo.filename withUserId:self.userAccount.userId intoManagedObjectContext:self.userAccount.gameInfoContext];
    
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
    
//    scenarioCell.titleLabel.hidden = !gameExistsAlready;
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

#pragma mark - Scenario Cell

- (IBAction)purchaseButtonPressed:(UIButton *)sender
{
    // TODO: Connect with appstore to check if already purchased
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    self.userAccount.selectedScenarioFilename = scenarioInfo.filename;
    
    [self.userAccount exitCurrentInvestingGame];

    [self updateUI];
}

- (IBAction)deleteGameButtonPressed:(UIButton *)sender
{
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    NSString *scenarioName = scenarioInfo.name;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Game?"
                                                                   message:scenarioName
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [GameInfo removeExistingGameInfoWithScenarioFilename:scenarioInfo.filename withUserId:self.userAccount.userId  intoManagedObjectContext:self.userAccount.gameInfoContext];
        
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ScenarioInfoViewController class]]) {
        if ([sender isKindOfClass:[UIButton class]]) {
            NSInteger tag = ((UIButton *)sender).tag;
            ScenarioPurchaseInfo *scenarioPurchaseInfo = self.userAccount.availableScenarios[tag];
            BOOL isFileAtBundle = [ManagedObjectContextCreator databaseExistsAtBundleWithFilename:scenarioPurchaseInfo.filename];
            [self prepareScenarioInfoViewController:segue.destinationViewController withScenarioPurchaseInfo:scenarioPurchaseInfo locale:self.userAccount.localeDefault isFileInBundle:isFileAtBundle];
        }
    }
}

- (void)prepareScenarioInfoViewController:(ScenarioInfoViewController *)scenarioInfoViewController withScenarioPurchaseInfo:(ScenarioPurchaseInfo *)scenarioPurchaseInfo locale:(NSLocale *)locale isFileInBundle:(BOOL)isFileInBundle
{
    scenarioInfoViewController.scenarioPurchaseInfo = scenarioPurchaseInfo;
    scenarioInfoViewController.locale = locale;
    scenarioInfoViewController.isFileInBundle = isFileInBundle;
}




@end

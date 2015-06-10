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
#import "DefaultColors.h"
#import "ScenarioTableViewCell.h"
#import "ScenarioPurchaseInfo.h"
#import "ScenarioInfoViewController.h"
#import "SavedGamesViewController.h"

@interface UserAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundUserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *userLevelProgressView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserAccountViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Background user image view setup
    self.backgroundUserImageView.layer.cornerRadius = 8;
    self.backgroundUserImageView.layer.masksToBounds = YES;
    if ([self.userAccount userLevel] == 0) {
        self.backgroundUserImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundUserImageView.layer.borderWidth = 1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    NSInteger currentUserLevel = [self.userAccount userLevel];
    
    // Background user image view
    self.backgroundUserImageView.backgroundColor = [DefaultColors userLevelColorForLevel:currentUserLevel];
    if (currentUserLevel == 0) {
        self.backgroundUserImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundUserImageView.layer.borderWidth = 1;
    }

    // Current user level + 1 only for UI purposes. Internally is all 0 based.
    self.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level %ld", (long)currentUserLevel + 1];;
    
    [self.userLevelProgressView setProgress:([self.userAccount progressForNextUserLevel])];
    
    [self.tableView reloadData];
}


#pragma mark - UITableView Data Source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.userAccount.availableScenarios count];
        
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    
    if (indexPath.section == 0) {
        
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
        
        scenarioCell.nameButton.tag = indexPath.row;
        scenarioCell.purchaseButton.tag = indexPath.row;
        
        cell = scenarioCell;
        
    } else if (indexPath.section == 1) {
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Load Game Cell"];
        
        cell.textLabel.text = @"Saved games";
        
    }

    return cell;
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
    if (indexPath.section == 0) {
        return 57;
        
    } else if (indexPath.section == 1) {
        return 48;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 34;
        
    } else {
        return 20;
    }
}

#pragma mark - Scenario Cell

- (IBAction)purchaseButtonPressed:(UIButton *)sender
{
    // TODO: Connect with appstore to check if already purchased
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    self.userAccount.selectedScenarioFilename = scenarioInfo.filename;
    [self.tableView reloadData];
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
    
    if ([segue.destinationViewController isKindOfClass:[SavedGamesViewController class]]) {
        [self prepareSavedGamesViewController:segue.destinationViewController withUserAccount:self.userAccount];
    }
    
}

- (void)prepareScenarioInfoViewController:(ScenarioInfoViewController *)scenarioInfoViewController withScenarioPurchaseInfo:(ScenarioPurchaseInfo *)scenarioPurchaseInfo locale:(NSLocale *)locale isFileInBundle:(BOOL)isFileInBundle
{
    scenarioInfoViewController.scenarioPurchaseInfo = scenarioPurchaseInfo;
    scenarioInfoViewController.locale = locale;
    scenarioInfoViewController.isFileInBundle = isFileInBundle;
}

- (void)prepareSavedGamesViewController:(SavedGamesViewController *)savedGamesViewController withUserAccount:(UserAccount *)userAccount
{
    savedGamesViewController.userAccount = userAccount;
}


@end

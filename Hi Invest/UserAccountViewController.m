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

@interface UserAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backgroundUserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *userLevelProgressView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userLevelButton;
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
    [self.userLevelButton setTitle:[NSString stringWithFormat:@"Ninja Level %ld", (long)currentUserLevel + 1] forState:UIControlStateNormal];
    
    [self.userLevelProgressView setProgress:([self.userAccount progressForNextUserLevel])];
}


#pragma mark - UITableView Data Source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userAccount.availableScenarios count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScenarioTableViewCell *scenarioCell = [self.tableView dequeueReusableCellWithIdentifier:@"Scenario Cell"];
    
    scenarioCell.purchaseDetailLabel.hidden = YES; // No ads implemented yet
    
    ScenarioPurchaseInfo *scenarioPurchaseInfo = self.userAccount.availableScenarios[indexPath.row];
    
    // Name Label
    [scenarioCell.nameButton setTitle:scenarioPurchaseInfo.name forState:UIControlStateNormal];
    
    NSDateComponents *initialDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:scenarioPurchaseInfo.initialDate];
    NSDateComponents *endingDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:scenarioPurchaseInfo.endingDate];
    
    NSString *yearPeriodStr;
    if ([initialDateComponents year] == [endingDateComponents year]) {
        yearPeriodStr = [NSString stringWithFormat:@"%ld", [initialDateComponents year]];
    } else {
        yearPeriodStr = [NSString stringWithFormat:@"%ld - %ld", [initialDateComponents year], [endingDateComponents year]];
    }
    
    // Detail Info Label
    scenarioCell.infoLabel.text = [NSString stringWithFormat:@"%03ld companies | %@", (long)scenarioPurchaseInfo.numberOfCompanies, yearPeriodStr];
    
    // Purchase Button
    NSString *priceStr;
    if (scenarioPurchaseInfo.price == 0) {
        priceStr = @"Free";
        
    } else {
        priceStr = [NSString stringWithFormat:@"$%.2f", scenarioPurchaseInfo.price];
    }
    [scenarioCell.purchaseButton setTitle:priceStr forState:UIControlStateNormal];
    
    // Scenario Selection
    if ([self.userAccount.selectedScenearioFilename isEqualToString:scenarioPurchaseInfo.filename]) {
        scenarioCell.purchaseButton.hidden = YES;
        scenarioCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        scenarioCell.purchaseButton.hidden = NO;
        scenarioCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    scenarioCell.nameButton.tag = indexPath.row;
    scenarioCell.purchaseButton.tag = indexPath.row;
    
    return scenarioCell;
}

#pragma mark - UITableView Delegate

- (IBAction)purchaseButtonPressed:(UIButton *)sender
{
    ScenarioPurchaseInfo *scenarioInfo = self.userAccount.availableScenarios[sender.tag];
    self.userAccount.selectedScenearioFilename = scenarioInfo.filename;
    [self.tableView reloadData];
}

- (IBAction)scenarioNameButtonPressed:(UIButton *)sender {
}











@end

//
//  LeftMenuViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "SimulatorTabBarController.h"
#import "UserAccountViewController.h"
#import "GlossarySelectionViewController.h"
#import "QuizSelectionViewController.h"
#import "SettingsTableViewController.h"
#import "UserAccount.h"
#import "InvestingGame.h"
#import "DefaultColors.h"
#import "Scenario.h"

@interface LeftMenuViewController () <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (nonatomic) NSInteger selectedRowIndex;
@property (strong, nonatomic) UIView *selectedCellSubview;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedRowIndex = -1;
}

- (void)updateUI
{
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 4;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId;
    if (indexPath.row == 0) {
        cellId = @"Menu Cell Subtitle";
    } else {
        cellId = @"Menu Cell";
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.backgroundColor = [UIColor clearColor]; // To override [UITableViewCell appearance] set in AppDelegate

    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Simulator";
        cell.detailTextLabel.text = [self.userAccount currentInvestingGame].scenarioInfo.name;
        cell.imageView.image = [[UIImage imageNamed:@"controller25x25"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"Quizzes";
        cell.imageView.image = [[UIImage imageNamed:@"pencilAnswer25x25"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else if (indexPath.row == 2) {
        
        cell.textLabel.text = @"Glossary";
        cell.imageView.image = [[UIImage imageNamed:@"books25x25"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    } else if (indexPath.row == 3) {
        
        cell.textLabel.text = @"Settings";
        cell.imageView.image = [[UIImage imageNamed:@"settings25x25"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
    }
    
    if (indexPath.row == self.selectedRowIndex) {
        cell.textLabel.textColor = [DefaultColors menuSelectedOptionColor];
        cell.detailTextLabel.textColor = [DefaultColors menuSelectedOptionColor];
        cell.imageView.tintColor = [DefaultColors menuSelectedOptionColor];
        
        // Add a rectangle to the left of the tableviewcell to show it is selected
        [self.selectedCellSubview removeFromSuperview];
        CGRect subviewFrame = CGRectMake(0, [self.tableView rowHeight] * 0.1, 4, [self.tableView rowHeight] * 0.8);
        self.selectedCellSubview = [[UIView alloc] initWithFrame:subviewFrame];
        self.selectedCellSubview.backgroundColor = [DefaultColors menuSelectedOptionColor];
        [UIView transitionWithView:cell.contentView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^ { [cell.contentView addSubview:self.selectedCellSubview]; } completion:nil];
    
    } else {
        if (self.selectedRowIndex < 0) {
            [self.selectedCellSubview removeFromSuperview];
        }
        cell.textLabel.textColor = [DefaultColors menuUnselectedOptionColor];
        cell.detailTextLabel.textColor = [DefaultColors menuUnselectedOptionColor];
        cell.imageView.tintColor = [DefaultColors menuUnselectedOptionColor];
    }

    cell.textLabel.highlightedTextColor = [DefaultColors menuSelectedOptionColor];
    cell.selectedBackgroundView = [[UIView alloc] init]; // To remove colored selectedBackgroundView
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *currentContentViewController = self.sideMenuViewController.contentViewController;
    if ([currentContentViewController isKindOfClass:[UINavigationController class]]) {
        currentContentViewController = [((UINavigationController *)currentContentViewController).viewControllers firstObject];
    }
    
    switch (indexPath.row) {
        case 0:
            
            if (![currentContentViewController isKindOfClass:[UITabBarController class]]) {
                SimulatorTabBarController *simulatorTabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"SimulatorTabBarController"];
                simulatorTabBarController.userAccount = self.userAccount;
                [self.sideMenuViewController setContentViewController:simulatorTabBarController animated:YES];
                if (self.userAccount.currentInvestingGame.finishedSuccessfully) {
                    [self.sideMenuViewController performSegueWithIdentifier:@"Simulator Game Over" sender:self];
                } else {
                    [self.sideMenuViewController performSegueWithIdentifier:@"Simulator Info" sender:self];
                }
            }
            break;
            
        case 1:
            
            if (![currentContentViewController isKindOfClass:[QuizSelectionViewController class]]) {
                UINavigationController *quizNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Quiz UINavigationController"];
                QuizSelectionViewController *quizSelectionViewController = [quizNavigationController.viewControllers firstObject];
                quizSelectionViewController.userAccount = self.userAccount;
                [self.sideMenuViewController setContentViewController:quizNavigationController animated:YES];
            }
            break;
            
        case 2:
            
            if (![currentContentViewController isKindOfClass:[GlossarySelectionViewController class]]) {
                UINavigationController *glossaryNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Glossary UINavigationController"];
                GlossarySelectionViewController *glossarySelectionViewController = [glossaryNavigationController.viewControllers firstObject];
                glossarySelectionViewController.userAccount = self.userAccount;
                [self.sideMenuViewController setContentViewController:glossaryNavigationController animated:YES];
            }
            break;
            
        case 3:
            if (![currentContentViewController isKindOfClass:[SettingsTableViewController class]]) {
                UINavigationController *settingsNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings UINavigationController"];
                SettingsTableViewController *settingsSelectionViewController = [settingsNavigationController.viewControllers firstObject];
                settingsSelectionViewController.userAccount = self.userAccount;
                [self.sideMenuViewController setContentViewController:settingsNavigationController animated:YES];
            }
            break;

        default:
            break;
    }

    self.selectedRowIndex = indexPath.row;
    [self updateUI];
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - Navigation
- (IBAction)userButtonPressed
{
    [self presentUserAccountViewController];
    [self.sideMenuViewController hideMenuViewController];
}

- (void)presentUserAccountViewController
{
    self.selectedRowIndex = -1;
    
    if (![self.sideMenuViewController.contentViewController isKindOfClass:[UserAccountViewController class]]) {
        UINavigationController *userAccountNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"User Account UINavigationController"];
        UserAccountViewController *userAccountViewController = [userAccountNavigationController.viewControllers firstObject];
        userAccountViewController.userAccount = self.userAccount;
        [self.sideMenuViewController setContentViewController:userAccountNavigationController animated:YES];
    }
    
    [self updateUI];
}


@end

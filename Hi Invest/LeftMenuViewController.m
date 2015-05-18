//
//  LeftMenuViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/25/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "SideMenuRootViewController.h"
#import "GlossarySelectionViewController.h"
#import "QuizSelectionViewController.h"
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

//    self.selectedRowIndex = -1;
    self.selectedRowIndex = 0;
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
        cell.detailTextLabel.text = self.game.scenarioInfo.name;
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
    
    switch (indexPath.row) {
        case 0:
            if (![currentContentViewController isKindOfClass:[UITabBarController class]]) {
                if ([self.sideMenuViewController isKindOfClass:[SideMenuRootViewController class]]) {
                    SideMenuRootViewController *sideMenuRootViewController = (SideMenuRootViewController *)self.sideMenuViewController;
                    // Use the method from SideMenuRootViewController to set all tabs from the tab bar controller with the given game
                    [self.sideMenuViewController setContentViewController:[sideMenuRootViewController getInvestTabBarViewControllerWithGame:self.game] animated:YES];
                }
                [self.sideMenuViewController performSegueWithIdentifier:@"Simulator Info" sender:self];
            }
            break;
            
        case 1:
            if (![currentContentViewController isKindOfClass:[QuizSelectionViewController class]]) {
                [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Quiz UINavigationController"] animated:YES];
            }
            break;
            
        case 2:
            if (![currentContentViewController isKindOfClass:[GlossarySelectionViewController class]]) {
                [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Glossary UINavigationController"] animated:YES];
            }
            break;
            
        case 3:
            break;

        default:
            break;
    }

    self.selectedRowIndex = indexPath.row;
    [self updateUI];
    
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - Navigation
- (IBAction)userButtonPressed {
    self.selectedRowIndex = -1;
    [self updateUI];
//    [self presentQuitGameRequest];
}

- (void)presentQuitGameRequest
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                   message:@"Are you sure you want to log out?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *quitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self performSegueWithIdentifier:@"unwindToInitialViewController" sender:self];
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:quitAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController = segue.destinationViewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [((UINavigationController *)viewController).viewControllers firstObject];
    }
    
}


- (IBAction)closeMenuButtonPressed:(UIButton *)sender {
    [self.sideMenuViewController hideMenuViewController];
}



@end

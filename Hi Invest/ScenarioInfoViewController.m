//
//  ScenarioInfoViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ScenarioInfoViewController.h"
#import "ScenarioPurchaseInfo.h"
#import "DefaultColors.h"
#import "ParseUserKeys.h"
#import <Parse/Parse.h>
#import "UserAccount.h"

@interface ScenarioInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *scenarioNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenarioDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;
@property (strong, nonatomic) NSArray *yourInfoNumbers; // @[Finished games, avg return, highest, lowest]

@end

@implementation ScenarioInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Subview setup
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
    
    // Segmented control setup
    self.segmentedControl.selectedSegmentIndex = 0; // Scenario info segment selected
    
    // Scenario name and description
    self.scenarioNameLabel.text = self.scenarioPurchaseInfo.name;
    self.scenarioDescriptionLabel.text = self.scenarioPurchaseInfo.descriptionForScenario;
    
    [self updateUI];
}

- (void)updateUI
{
    [self.tableView reloadData];
    
    BOOL noInfo = [self.tableView numberOfRowsInSection:0] == 0;
    
    self.noInfoLabel.hidden = !noInfo;
    self.tableView.hidden = noInfo;
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender
{
    [self updateUI];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return self.isFileInBundle ? 3 : 4;
        
    } else {
        return 4;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Scenario Info Cell"];
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = self.locale;
        dateFormatter.dateFormat = @"MMM yyyy"; // only show month and year
        //            dateFormatter.dateStyle = NSDateFormatterMediumStyle; // shows day, month and year
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Period";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:self.scenarioPurchaseInfo.initialDate], [dateFormatter stringFromDate:self.scenarioPurchaseInfo.endingDate]];
                break;
                
            case 1:
                cell.textLabel.text = @"Days";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.scenarioPurchaseInfo.numberOfDays];
                break;
                
            case 2:
                cell.textLabel.text = @"Companies";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.scenarioPurchaseInfo.numberOfCompanies];
                break;
                
            case 3:
                cell.textLabel.text = @"File size";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f MB", self.scenarioPurchaseInfo.sizeInMegas];
                break;
                
            default:
                break;
        }
    } else {
        
        NSString *filename = self.scenarioPurchaseInfo.filename;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.locale = self.userAccount.localeDefault;
        numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
        numberFormatter.maximumFractionDigits = 2;
        
        if (indexPath.row == 0) {
            
            NSNumber *gamesNumber = self.userAccount.finishedScenariosCount[filename];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            cell.textLabel.text = @"Games finished";
            cell.detailTextLabel.text = gamesNumber ? [numberFormatter stringFromNumber:gamesNumber] : @"0";
            
        } else if (indexPath.row == 1) {
            
            NSNumber *avgReturnNumber = self.userAccount.averageReturns[filename];
            cell.textLabel.text = @"Average";
            
            if (avgReturnNumber) {
                cell.detailTextLabel.attributedText = [DefaultColors attributedStringForReturn:[avgReturnNumber doubleValue]
                                                                             forDarkBackground:NO];
            } else {
                cell.detailTextLabel.text = @"--";
            }
            
            
        } else if (indexPath.row == 2) {
            
            NSNumber *highestReturnNumber = self.userAccount.highestReturns[filename];
            cell.textLabel.text = @"Highest";
            
            if (highestReturnNumber) {
                cell.detailTextLabel.attributedText = [DefaultColors attributedStringForReturn:[highestReturnNumber doubleValue]
                                                                             forDarkBackground:NO];
            } else {
                cell.detailTextLabel.text = @"--";
            }
            
        } else if (indexPath.row == 3) {
            
            NSNumber *lowestReturnNumber = self.userAccount.lowestReturns[filename];
            cell.textLabel.text = @"Lowest";
            
            if (lowestReturnNumber) {
                cell.detailTextLabel.attributedText = [DefaultColors attributedStringForReturn:[lowestReturnNumber doubleValue]
                                                                             forDarkBackground:NO];
            } else {
                cell.detailTextLabel.text = @"--";
            }
        }
    }

    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - Dismissing

// Exit View Controller when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}








@end

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

@interface ScenarioInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *scenarioNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenarioDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noInfoLabel;

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
        return 0;
        
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
        
        
        
        
        
    }
    

    
    return cell;
}

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

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
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ScenarioInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
    
    [self updateUI];
}

- (void)updateUI
{
    self.scenarioNameLabel.text = self.scenarioPurchaseInfo.name;
    self.scenarioDescriptionLabel.text = self.scenarioPurchaseInfo.descriptionForScenario;
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Scenario Info Cell"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = self.locale;
    dateFormatter.dateFormat = @"MMM yyyy"; // only show month and year
    //            dateFormatter.dateStyle = NSDateFormatterMediumStyle; // shows day, month and year
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Starting date";
            cell.detailTextLabel.text = [dateFormatter stringFromDate:self.scenarioPurchaseInfo.initialDate];
            break;
            
        case 1:
            cell.textLabel.text = @"Ending date";
            cell.detailTextLabel.text = [dateFormatter stringFromDate:self.scenarioPurchaseInfo.endingDate];
            break;
            
        case 2:
            cell.textLabel.text = @"Number of days";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.scenarioPurchaseInfo.numberOfDays];
            break;
            
        case 3:
            cell.textLabel.text = @"Number of companies";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.scenarioPurchaseInfo.numberOfCompanies];
            break;
            
        case 4:
            cell.textLabel.text = @"File size";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f MB", self.scenarioPurchaseInfo.sizeInMegas];
            break;
            
        default:
            break;
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

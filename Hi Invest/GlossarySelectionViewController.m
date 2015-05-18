//
//  GlossarySelectionViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/17/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "GlossarySelectionViewController.h"
#import "GlossaryViewController.h"
#import "DefaultColors.h"
#import "RatiosKeys.h"
#import "GlossaryKeys.h"

@interface GlossarySelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GlossarySelectionViewController

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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Glossary Cell"];
    
    NSString *glossaryType = GlossaryTypesArray[indexPath.row];
    NSString *imageFilename = nil;
    
    cell.textLabel.text = glossaryType;
    
    if ([glossaryType isEqualToString:GlossaryTypeFinancialRatios]) {
        imageFilename = @"ratio25x25";
    } else if ([glossaryType isEqualToString:GlossaryTypeFinancialStatementTerms]) {
        imageFilename = @"news25x25";
    } else if ([glossaryType isEqualToString:GlossaryTypeStockMarketTerms]) {
        imageFilename = @"graph25x25";
    }
    
    if (imageFilename) {
        UIImage *image = [[UIImage imageNamed:imageFilename] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imageView setTintColor:[[DefaultColors UIElementsBackgroundColor] colorWithAlphaComponent:[DefaultColors UIElementsBackgroundAlpha]]];
        cell.imageView.image = image;
    }
    
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *senderIndexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *senderCell = (UITableViewCell *)sender;
        senderIndexPath = [self.tableView indexPathForCell:senderCell];
    }
    
    if ([segue.destinationViewController isKindOfClass:[GlossaryViewController class]]) {
        if (senderIndexPath) {
            [self prepareGlossaryViewController:segue.destinationViewController withGlossaryId:GlossaryTypesArray[senderIndexPath.row]];
        }
    }
}

- (void)prepareGlossaryViewController:(GlossaryViewController *)glossaryViewController withGlossaryId:(NSString *)glossaryId
{
    glossaryViewController.glossaryId = glossaryId;
    glossaryViewController.title = glossaryId;
}























@end

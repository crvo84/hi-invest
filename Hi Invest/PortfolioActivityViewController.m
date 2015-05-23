//
//  PortfolioActivityViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PortfolioActivityViewController.h"

@interface PortfolioActivityViewController () //<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PortfolioActivityViewController

- (void)updateUI
{
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source




#pragma mark - UITableView Delegate

@end

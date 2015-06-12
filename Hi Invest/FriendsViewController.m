//
//  FriendsViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendTableViewCell.h"
#import "DefaultColors.h"

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noFriendsLabel;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

- (void)updateUI
{
    self.noFriendsLabel.hidden = YES; // TODO: If no friends, unhide label
    
    // Maybe not reloading table view each time, to avoid to many internet calls
}

#pragma mark - UITableView Data Source

#define FriendsProvisionalNamesArray @[@"Carlos Rogelio", @"Malala", @"Lucas Villanueva", @"Flash Guerrero Brizuela", @"crvo84", @"Tyrion Lannister", @"Eddard Stark", @"Daenerys Targaryen"]

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FriendsProvisionalNamesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Friend Cell"];
    
    cell.userLevelBackgroundView.backgroundColor = [DefaultColors userLevelColorForLevel:indexPath.row];
    cell.userNameLabel.text = FriendsProvisionalNamesArray[indexPath.row];
    cell.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level %ld", (long)indexPath.row + 1];
    
    return cell;
}


#pragma mark - UITableView Delegate










@end

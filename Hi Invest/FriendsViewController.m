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
#import "ParseUserKeys.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noFriendsLabel;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)getFriends
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/{friend-list-id}"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        // Handle the result
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:ParseUserFacebookId containedIn:friendIds];
    
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            NSArray *friendUsers = [friendQuery findObjects];
            
        }
    }];
}


//// Issue a Facebook Graph API request to get your user's friend list
//[FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//    if (!error) {
//        // result will contain an array with your user's friends in the "data" key
//        NSArray *friendObjects = [result objectForKey:@"data"];
//        NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
//        // Create a list of friends' Facebook IDs
//        for (NSDictionary *friendObject in friendObjects) {
//            [friendIds addObject:[friendObject objectForKey:@"id"]];
//        }
//        
//        // Construct a PFUser query that will find friends whose facebook ids
//        // are contained in the current user's friend list.
//        PFQuery *friendQuery = [PFUser query];
//        [friendQuery whereKey:@"fbId" containedIn:friendIds];
//        
//        // findObjects will return a list of PFUsers that are friends
//        // with the current user
//        NSArray *friendUsers = [friendQuery findObjects];
//    }
//}];

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

#define FriendsProvisionalNamesArray @[@"Carlos Rogelio", @"Malala", @"Lucas", @"Flash", @"crvo84", @"Tyrion Lannister", @"Eddard Stark", @"Daenerys Targaryen"]

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

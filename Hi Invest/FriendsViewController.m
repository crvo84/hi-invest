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
#import "UserAccount.h"
#import "ParseUserKeys.h"
#import "UserDefaultsKeys.h"
#import "Friend.h"
#import "FriendStore.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noFriendsLabel;
@property (strong, nonatomic) NSArray *friends;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self refreshFriendsInfo];
}

- (void)updateUI
{
    self.friends = nil;

    NSInteger numberOfFriends = [self.friends count];
    self.noFriendsLabel.hidden = numberOfFriends > 0;
    self.tableView.hidden = numberOfFriends == 0;
    
    [self.tableView reloadData];
}

#pragma mark - Fetching Friends Info

- (void)refreshFriendsInfo
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil];
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
            
            [[NSUserDefaults standardUserDefaults] setObject:friendIds forKey:UserDefaultsFriendsFacebookIds];
            
            [self fetchFriendsParseUsers];
            
        } else {
            NSLog(@"Facebook Graph Friends Request. Error: %@", [error localizedDescription]);
            [self updateUI];
        }
        
    }];
}

- (void)fetchFriendsParseUsers
{
    NSArray *friendsFacebookIds = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsFriendsFacebookIds];
    
    if (!friendsFacebookIds) {
        [self updateUI];
        return;
    }
    
    // Construct a PFUser query that will find friends whose facebook ids
    // are contained in the current user's friend list.
    PFQuery *friendQuery = [PFUser query];
    [friendQuery whereKey:ParseUserFacebookId containedIn:friendsFacebookIds];
    
    // findObjects will return a list of PFUsers that are friends
    // with the current user
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            [[FriendStore sharedStore] updateFriendsWithParseUsers:objects];
        } else {
            NSLog(@"Friends parse users fetch. Error: %@", [error localizedDescription]);
        }
        
        [self updateUI];
    }];
}


#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Friend Cell"];
    
    Friend *friend = self.friends[indexPath.row];
    NSInteger level = friend.level;
    
    cell.userLevelBackgroundView.backgroundColor = [DefaultColors userLevelColorForLevel:level];
    cell.userNameLabel.text = friend.name;
    cell.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level %ld", (long)level + 1];
    
    // Profile picture
    NSData *pictureData = friend.picture;
    if (pictureData) {
        cell.userProfileImageView.image = [UIImage imageWithData:pictureData];
    } else {
        cell.userProfileImageView.image = nil;
        
        // Downloading facebook profile picture (in jpg)
        // type must be one of the following values: small (50x50 2kb), normal (100x100 4kb), album (50x50 2kb), large (200x200 10kb), square (50x50 2kb)
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal&return_ssl_res", friend.facebookId]];
    
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    
        // Run network request asynchronously
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
             if (connectionError == nil && data != nil) {
                 [[FriendStore sharedStore] setPicture:data forFriendWithFacebookId:friend.facebookId];
                 [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
             }
         }];
    }
    
    return cell;
}


#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - Getters

- (NSArray *)friends
{
    if (!_friends) {
        _friends = [[FriendStore sharedStore] friendsOrderedByLevel];
    }
    
    return _friends;
}



@end

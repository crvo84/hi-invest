//
//  UserAccountViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccountViewController.h"
#import "UserAccount.h"

@interface UserAccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *userLevelProgressView;

@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self updateUI];
}

- (void)updateUI
{
    // Current user level + 1 only for UI purposes. Internally is all 0 based.
    self.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level: %ld", (long)[self.userAccount currentUserLevel] + 1];
    
    [self.userLevelProgressView setProgress:([self.userAccount progressForNextUserLevel])];
}

@end

//
//  UserAccountViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserAccountViewController.h"
#import "UserAccount.h"
#import "DefaultColors.h"

@interface UserAccountViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *friendsButton;
@property (weak, nonatomic) IBOutlet UIProgressView *userLevelProgressView;

@end

@implementation UserAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Background user image view setup
    self.backgroundUserImageView.layer.cornerRadius = 8;
    self.backgroundUserImageView.layer.masksToBounds = YES;
    if ([self.userAccount userLevel] == 0) {
        self.backgroundUserImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundUserImageView.layer.borderWidth = 1;
    }
    
    // friends Button setup (to get button tint color on image)
    UIImage *friendsImage = [[UIImage imageNamed:@"friends30x30"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.friendsButton setImage:friendsImage forState:UIControlStateNormal];
    [self.friendsButton.imageView setTintColor:[DefaultColors buttonDefaultColor]];
    
    [self updateUI];
}

- (void)updateUI
{
    NSInteger currentUserLevel = [self.userAccount userLevel];
    
    // Background user image view
    self.backgroundUserImageView.backgroundColor = [DefaultColors userLevelColorForLevel:currentUserLevel];
    if (currentUserLevel == 0) {
        self.backgroundUserImageView.layer.borderColor = [UIColor grayColor].CGColor;
        self.backgroundUserImageView.layer.borderWidth = 1;
    }

    // Current user level + 1 only for UI purposes. Internally is all 0 based.
    self.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level: %ld", (long)currentUserLevel + 1];
    
    [self.userLevelProgressView setProgress:([self.userAccount progressForNextUserLevel])];
}

@end

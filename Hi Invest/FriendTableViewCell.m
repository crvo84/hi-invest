//
//  FriendTableViewCell.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/5/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.userProfileImageView.layer.cornerRadius = 3;
    self.userProfileImageView.layer.masksToBounds = YES;
    
    self.userLevelBackgroundView.layer.cornerRadius = 5;
    self.userLevelBackgroundView.layer.masksToBounds = YES;
    
    self.userProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

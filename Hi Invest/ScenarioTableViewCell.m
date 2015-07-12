//
//  ScenarioTableViewCell.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/2/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ScenarioTableViewCell.h"

@implementation ScenarioTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    // Purchase Button Setup
//    self.purchaseButton.layer.borderWidth = 1;
//    self.purchaseButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
//    self.purchaseButton.layer.cornerRadius = 5;
//    self.purchaseButton.layer.masksToBounds = YES;
//    self.purchaseButton.titleLabel.minimumScaleFactor = 0.7;
    
    // Delete Button Setup
    UIImage *deleteImage = [[UIImage imageNamed:@"delete16x16"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
    self.deleteButton.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

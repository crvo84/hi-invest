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
    
    // Purchase Button Setup
    self.purchaseButton.layer.borderWidth = 1;
    self.purchaseButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    self.purchaseButton.layer.cornerRadius = 5;
    self.purchaseButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

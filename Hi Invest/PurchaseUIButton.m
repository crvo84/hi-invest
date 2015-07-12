//
//  PurchaseUIButton.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 7/12/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PurchaseUIButton.h"

@implementation PurchaseUIButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    // Purchase Button Setup
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.titleLabel.minimumScaleFactor = 0.7;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}



@end

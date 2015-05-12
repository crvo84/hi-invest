//
//  CompanyTableViewCell.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "CompanyTableViewCell.h"

@implementation CompanyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    // Sets the image to Rendering Template so it takes the color of the view that contains it
    // This way, the image takes the tint color of the uibutton
    UIImage *pieChartNormalStateImage = [self.pieChartButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    // Sets the image to show in the button in a control state normal
    [self.pieChartButton setImage:pieChartNormalStateImage forState:UIControlStateNormal];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


@end

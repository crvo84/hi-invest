//
//  CompanyTableViewCell.h
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 1/31/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tickerLabel;
@property (weak, nonatomic) IBOutlet UIButton *pieChartButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

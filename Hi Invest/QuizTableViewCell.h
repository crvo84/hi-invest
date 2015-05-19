//
//  QuizTableViewCell.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 5/19/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfQuestionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mistakesAllowedLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsPerQuestionLabel;

@end

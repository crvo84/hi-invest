//
//  LevelUpViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/18/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "LevelUpViewController.h"
#import "DefaultColors.h"

@interface LevelUpViewController ()

@property (weak, nonatomic) IBOutlet UIView *subview; // for white background color
@property (weak, nonatomic) IBOutlet UIView *subsubview;
@property (weak, nonatomic) IBOutlet UIView *userBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;


@end

@implementation LevelUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Subview setup
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
    
    // Subsubview setup
    self.subsubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // User Background View Setup
    self.userBackgroundView.layer.cornerRadius = 8;
    self.userBackgroundView.layer.masksToBounds = YES;
    self.userBackgroundView.backgroundColor = [DefaultColors userLevelColorForLevel:self.newLevel];
    if (self.newLevel == 7) {
        self.userBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.userBackgroundView.layer.borderWidth = 1;
    }

    // User Level Label
    // User Level + 1 because it is zero based
    self.userLevelLabel.text = [NSString stringWithFormat:@"Ninja Level %ld", (long)self.newLevel + 1];
}

#pragma mark - Dismissing

// Exit View Controller when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

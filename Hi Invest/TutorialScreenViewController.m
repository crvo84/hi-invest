//
//  TutorialScreenViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/21/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "TutorialScreenViewController.h"
#import "DefaultColors.h"

@interface TutorialScreenViewController ()

// Message
@property (weak, nonatomic) IBOutlet UIView *backgroundSubview;
@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
// Ninja Images
@property (weak, nonatomic) IBOutlet UIImageView *lowerImageView;
@property (weak, nonatomic) IBOutlet UIView *lowerBackgroundView;

@end

@implementation TutorialScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View Setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Background Subview Setup
    self.backgroundSubview.layer.cornerRadius = 8;
    self.backgroundSubview.layer.masksToBounds = YES;
    
    // Subview Setup
    self.subview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // Message Label Setup
    self.messageLabel.text = self.message;
    
    // Ninja Images Setup
    UIImage *ninjaImage = [UIImage imageNamed:self.imageFilename];
    [self.lowerImageView setImage:ninjaImage];

}

#pragma mark - Navigation

// Exit View Controller when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view || viewTouched == self.lowerBackgroundView || viewTouched == self.lowerImageView) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

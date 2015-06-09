//
//  UserInfoViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/8/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "UserInfoViewController.h"
#import "DefaultColors.h"

@interface UserInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *subview;

@end

@implementation UserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Subview setup
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
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

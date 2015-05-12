//
//  ContainerViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/23/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the background color to the color set in the interface builder, buy then add the color again with a alpha component
    UIColor *viewColor = self.view.backgroundColor;
    self.view.backgroundColor = [viewColor colorWithAlphaComponent:0.7];
    
    // Set rounded corners for pickerView
    self.container.layer.cornerRadius = 8; // Magic number
    self.container.layer.masksToBounds = YES;
}

// Call cancel method when the user touches the screen outside the subview
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self.view];
    UIView *viewTouched = [self.view hitTest:locationInView withEvent:event];
    if (viewTouched == self.view) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

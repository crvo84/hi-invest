//
//  PurchaseScenarioViewController.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 6/19/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "PurchaseScenarioViewController.h"
#import "DefaultColors.h"
#import "UserAccount.h"

#import <StoreKit/StoreKit.h>

@interface PurchaseScenarioViewController ()

@property (weak, nonatomic) IBOutlet UIView *subview;
@property (weak, nonatomic) IBOutlet UILabel *scenarioNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scenarioDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;

@end

@implementation PurchaseScenarioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // View setup
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Subview setup
    self.subview.layer.cornerRadius = 8;
    self.subview.layer.masksToBounds = YES;
    
    // Scenario name and description
    self.scenarioNameLabel.text = self.product.localizedTitle;
    self.scenarioDescriptionLabel.text = self.product.localizedDescription;
    
    // Purchase Button Setup
    self.purchaseButton.layer.borderWidth = 1;
    self.purchaseButton.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    self.purchaseButton.layer.cornerRadius = 5;
    self.purchaseButton.layer.masksToBounds = YES;
}

- (IBAction)purchase:(id)sender
{
    [self performSegueWithIdentifier:@"Purchase" sender:self];
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

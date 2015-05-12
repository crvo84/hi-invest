//
//  DefinitionViewController.m
//  Villou Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 2/19/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "DefinitionViewController.h"
#import "RatiosKeys.h"
#import "DefaultColors.h"

@interface DefinitionViewController ()

@property (weak, nonatomic) IBOutlet UIView *subview; // For the standard app bubble color
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DefinitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Title label
    self.titleLabel.textColor = [DefaultColors navigationBarWithSegueTitleColor];
    
    // Subview
    self.subview.layer.cornerRadius = 8; // Magic number
    self.subview.layer.masksToBounds = YES;
    self.subview.layer.borderWidth = [DefaultColors speechBubbleBorderWidth];
    self.subview.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.subview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];

    // Text View
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)]; // To avoid initial offset
    
    // Image View
    NSArray *imageSufixes = @[@"B", @"C", @"F"];
    NSInteger randomIndex = arc4random() % [imageSufixes count];
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ninja%@", imageSufixes[randomIndex]]];
    
    [self updateUI];
}


#pragma mark - Updating UI

- (void)updateUI
{
    if (self.definitionId) {

        self.titleLabel.text = self.definitionId;
        
        UIFont *font = [UIFont systemFontOfSize:[DefaultColors definitionTextViewFontSize]];
        UIColor *textColor = [DefaultColors definitionTextViewTextColor];
        NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : textColor};
        
        NSString *definition = [self definitionForIdentifier:self.definitionId];
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:definition attributes:attributes];
        self.textView.textAlignment = NSTextAlignmentCenter;
        [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
        
    }
}

- (NSString *)definitionForIdentifier:(NSString *)definitionId
{
    if ([[FinancialRatiosDefinitionsDictionary allKeys] containsObject:definitionId]) {
        return FinancialRatiosDefinitionsDictionary[definitionId];
    }
    
    return nil;
}

#pragma mark - Dismissing

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

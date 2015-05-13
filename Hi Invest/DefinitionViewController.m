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

@property (weak, nonatomic) IBOutlet UIView *definitionSubview; // For the standard app bubble color
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *formulaImageView;
@property (weak, nonatomic) IBOutlet UIView *formulaSubview;
@property (weak, nonatomic) IBOutlet UIImageView *cartoonImageView;

@end

@implementation DefinitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [DefaultColors translucentLightBackgroundColor];
    
    // Title label
    self.titleLabel.textColor = [DefaultColors navigationBarWithSegueTitleColor];
    
    // Definition Subview
    self.definitionSubview.layer.cornerRadius = 8; // Magic number
    self.definitionSubview.layer.masksToBounds = YES;
    self.definitionSubview.layer.borderWidth = [DefaultColors speechBubbleBorderWidth];
    self.definitionSubview.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.definitionSubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];

    // Text View
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)]; // To avoid initial offset
    
    // Formula Subview
    self.formulaSubview.layer.cornerRadius = 8; // Magic number
    self.formulaSubview.layer.masksToBounds = YES;
    self.formulaSubview.layer.borderWidth = [DefaultColors speechBubbleBorderWidth];
    self.formulaSubview.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.formulaSubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // Formula Image View
    NSString *formulaImageFilename = FinancialRatioImageFilenamesDictionary[self.definitionId];
    UIImage *formulaImage = [UIImage imageNamed:formulaImageFilename];
    if (formulaImage) {
        [self.formulaImageView setImage:formulaImage];
    }
    
    // Cartoon Image View
    NSArray *imageSufixes = @[@"B", @"C", @"F"];
    NSInteger randomIndex = arc4random() % [imageSufixes count];
    self.cartoonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ninja%@", imageSufixes[randomIndex]]];
    
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

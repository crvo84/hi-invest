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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *definitionSubview; // For background white color
@property (weak, nonatomic) IBOutlet UIView *definitionSubsubview; // For the standard app bubble color
@property (weak, nonatomic) IBOutlet UIView *formulaSubview; // For background white color
@property (weak, nonatomic) IBOutlet UIView *formulaSubsubview; // For the standard app bubble color
@property (weak, nonatomic) IBOutlet UIImageView *formulaImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

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
    
    // Definition Subsubview
    self.definitionSubsubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // Formula Subview
    self.formulaSubview.layer.cornerRadius = 8; // Magic number
    self.formulaSubview.layer.masksToBounds = YES;
    
    // Formula Subsubview
    self.formulaSubsubview.backgroundColor = [[DefaultColors speechBubbleBackgroundColor] colorWithAlphaComponent:[DefaultColors speechBubbleBackgroundAlpha]];
    
    // Text View
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)]; // To avoid initial offset
    
    // Source Label and Button
    self.sourceButton.hidden = self.source == nil;
    self.sourceLabel.hidden = YES;
    
    [self updateUI];
}


#pragma mark - Updating UI

- (void)updateUI
{
    // Formula Image View
    if (self.formulaImageFilename) {
        UIImage *formulaImage = [UIImage imageNamed:self.formulaImageFilename];
        if (formulaImage) {
            [self.formulaImageView setImage:formulaImage];
        }
    }
    
    if (self.definitionId && self.definition) {

        self.titleLabel.text = self.definitionId;
        
        UIFont *font = [UIFont systemFontOfSize:[DefaultColors definitionTextViewFontSize]];
        UIColor *textColor = [DefaultColors definitionTextViewTextColor];
        NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : textColor};
        
        NSString *definition = self.definition;
        self.textView.attributedText = [[NSAttributedString alloc] initWithString:definition attributes:attributes];
        self.textView.textAlignment = NSTextAlignmentCenter;
        [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
        
    }
    
    // Source Label
    self.sourceLabel.text = self.source;
    
}
- (IBAction)sourceButtonPressed:(UIButton *)sender
{
    self.sourceLabel.hidden = !self.sourceLabel.isHidden;
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

//
//  DefaultColors.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/24/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "DefaultColors.h"

@implementation DefaultColors

+ (UIColor *)windowBackgroundColor
{
    return [UIColor colorWithRed:0.0 green:45.0/255.0 blue:96.0/255.0 alpha:1.0];
}

+ (UIColor *)navigationBarColor
{
    return [self windowBackgroundColor];
}

+ (UIColor *)UIElementsBackgroundColor
{
    return [self windowBackgroundColor];
}

+ (CGFloat)UIElementsBackgroundAlpha
{
    return 0.85;
}

+ (UIColor *)infoViewColor
{
//    return [[self windowBackgroundColor] colorWithAlphaComponent:0.5];
    return [self tableViewCellBackgroundColor];
}

+ (UIColor *)infoViewBorderColor
{
//    return [[self windowBackgroundColor] colorWithAlphaComponent:0.55];
    return [UIColor clearColor];
}

+ (UIColor *)infoViewControllerBackgroundColor
{
//    return [[self windowBackgroundColor] colorWithAlphaComponent:0.85];
    return [UIColor clearColor];
}

+ (UIColor *)pieChartMainColor
{
    return [UIColor colorWithRed:0.0 green:0.1775 blue:0.375 alpha:1.0];
}

+ (UIColor *)translucentDarkBackgroundColor
{
    return [UIColor colorWithRed:0.0 green:32.0/255.0 blue:64.0/255.0 alpha:0.95];
}

+ (UIColor *)translucentLightBackgroundColor
{
    return [[self windowBackgroundColor] colorWithAlphaComponent:0.70];
}

+ (UIColor *)navigationBarTitleColor
{
    return [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

+ (UIColor *)navigationBarWithSegueTitleColor
{
    return [UIColor colorWithRed:175.0/255.0 green:225.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)navigationBarButtonColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)buySellButtonSuperviewBackgroundColor
{
    return [UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:128.0/255.0 alpha:1.0];
}

+ (UIColor *)buySellButtonBackgroundColor
{
    return [[UIColor whiteColor] colorWithAlphaComponent:[self UIElementsBackgroundAlpha]];
}

+ (UIColor *)buySellButtonTintColor
{
    return [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
}

+ (UIColor *)tableViewCellBackgroundColor
{
    return [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

+ (UIColor *)menuSelectedOptionColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)menuUnselectedOptionColor
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.65];
}

+ (UIColor *)graphBackgroundColor
{
    return [[self UIElementsBackgroundColor] colorWithAlphaComponent:[self UIElementsBackgroundAlpha]];
}

+ (UIColor *)speechBubbleBackgroundColor
{
//    return [self windowBackgroundColor];
    return [UIColor blackColor];
}

+ (CGFloat)speechBubbleBackgroundAlpha
{
//    return [self UIElementsBackgroundAlpha];
    return 0.85;
}

+ (CGFloat)speechBubbleBorderWidth
{
    return 1.0;
}

+ (UIColor *)speechBubbleBorderColor
{
    return [[self windowBackgroundColor] colorWithAlphaComponent:0.55];
}

+ (UIColor *)speechBubbleTextViewTextColor
{
    return [UIColor whiteColor];
}

+ (CGFloat)speechBubbleTextViewFontSize
{
    return 18.0;
}

+ (CGFloat)definitionTextViewFontSize
{
    return 20.0;
}

+ (UIColor *)definitionTextViewTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)scenarioButtonBackgroundColor
{
    return [[self windowBackgroundColor] colorWithAlphaComponent:0.05];
}

+ (UIColor *)buttonDefaultColor
{
    return [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
}

+ (NSAttributedString *)attributedStringForReturn:(double)returnValue forDarkBackground:(BOOL)darkBackground
{
    UIColor *color = darkBackground ? [UIColor lightGrayColor] : [UIColor darkGrayColor];
    if (returnValue > 0) {
        color = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
    } else if (returnValue < 0) {
        color = [UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    }
    
    NSString *signStr = returnValue > 0 ? @"+" : @"";
    
    NSString *returnStr = [NSString stringWithFormat:@"%@%.2f%%", signStr, (returnValue * 100)];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:returnStr];
    
    NSRange range = NSMakeRange(0, attributedStr.length);
    
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return attributedStr;
}

// First user level = 0
+ (UIColor *)userLevelColorForLevel:(NSInteger)userLevel;
{
//    userLevel = 1;
    UIColor *color;
    switch (userLevel) {
        case 0:
            color = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
            break;
        case 1:
            color = [UIColor colorWithRed:255.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 2:
            color = [UIColor colorWithRed:255.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 3:
            color = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 4:
            color = [UIColor colorWithRed:0.0/255.0 green:72.0/255.0 blue:128.0/255.0 alpha:1.0];
            break;
        case 5:
            color = [UIColor colorWithRed:120.0/255.0 green:64.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 6:
            color = [UIColor colorWithRed:225.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 7:
            color = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
            break;
        default:
            color = nil;
            break;
    }
    
    return color;
}
             

@end

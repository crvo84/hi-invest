//
//  DefaultColors.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/24/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DefaultColors : NSObject

+ (UIColor *)windowBackgroundColor;

+ (UIColor *)navigationBarColor;

+ (UIColor *)UIElementsBackgroundColor;

+ (CGFloat)UIElementsBackgroundAlpha;

+ (UIColor *)infoViewColor;

+ (UIColor *)infoViewBorderColor;

+ (UIColor *)infoViewControllerBackgroundColor;

+ (UIColor *)pieChartMainColor;

+ (UIColor *)translucentDarkBackgroundColor;

+ (UIColor *)translucentLightBackgroundColor;

+ (UIColor *)navigationBarButtonColor;

+ (UIColor *)navigationBarTitleColor;

+ (UIColor *)navigationBarWithSegueTitleColor;

+ (UIColor *)buySellButtonBackgroundColor;

+ (UIColor *)buySellButtonTintColor;

+ (UIColor *)tableViewCellBackgroundColor;

+ (UIColor *)menuSelectedOptionColor;

+ (UIColor *)menuUnselectedOptionColor;

+ (UIColor *)graphBackgroundColor;

+ (UIColor *)speechBubbleBackgroundColor;

+ (CGFloat)speechBubbleBackgroundAlpha;

+ (UIColor *)speechBubbleBorderColor;

+ (CGFloat)speechBubbleBorderWidth;

+ (UIColor *)speechBubbleTextViewTextColor;

+ (CGFloat)speechBubbleTextViewFontSize;

+ (UIColor *)definitionTextViewTextColor;

+ (CGFloat)definitionTextViewFontSize;

+ (UIColor *)scenarioButtonBackgroundColor;

+ (UIColor *)buttonDefaultColor;

+ (NSAttributedString *)attributedStringForReturn:(double)returnValue forDarkBackground:(BOOL)darkBackground;

// First user level = 0
+ (UIColor *)userLevelColorForLevel:(NSInteger)userLevel;



@end

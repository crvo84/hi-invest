//
//  SpeechBubbleView.h
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeechBubbleView : UIView

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (nonatomic) CGFloat backgroundAlpha;
@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic) CGFloat borderRadius;
@property (nonatomic) CGFloat triangleWidth;
@property (nonatomic) CGFloat triangleHeight;
@property (nonatomic) BOOL isTrianglePointingDown;

@end

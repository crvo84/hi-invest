//
//  SpeechBubbleView.m
//  Hi Invest
//
//  Created by Carlos Rogelio Villanueva Ousset on 4/27/15.
//  Copyright (c) 2015 Villou. All rights reserved.
//

#import "SpeechBubbleView.h"

@implementation SpeechBubbleView

// Draw a speech bubble view. With a triangle pointing downwards
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGRect currentFrame = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.isTrianglePointingDown) {
        // To point the triangle downwards
        CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0f, -1.0f);
    }
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, self.strokeWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    
    // Draw and fill the bubble
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.borderRadius + self.strokeWidth + 0.5f, self.strokeWidth + self.triangleHeight + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f - self.triangleWidth / 2.0f) + 0.5f, self.triangleHeight + self.strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f) + 0.5f, self.strokeWidth + 0.5f);
    CGContextAddLineToPoint(context, round(currentFrame.size.width / 2.0f + self.triangleWidth / 2.0f) + 0.5f, self.triangleHeight + self.strokeWidth + 0.5f);
    CGContextAddArcToPoint(context, currentFrame.size.width - self.strokeWidth - 0.5f, self.strokeWidth + self.triangleHeight + 0.5f, currentFrame.size.width - self.strokeWidth - 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.borderRadius - self.strokeWidth);
    CGContextAddArcToPoint(context, currentFrame.size.width - self.strokeWidth - 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, round(currentFrame.size.width / 2.0f + self.triangleWidth / 2.0f) - self.strokeWidth + 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.borderRadius - self.strokeWidth);
    CGContextAddArcToPoint(context, self.strokeWidth + 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.strokeWidth + 0.5f, self.triangleHeight + self.strokeWidth + 0.5f, self.borderRadius - self.strokeWidth);
    
    CGContextAddArcToPoint(context, self.strokeWidth + 0.5f, self.strokeWidth + self.triangleHeight + 0.5f, currentFrame.size.width - self.strokeWidth - 0.5f, self.triangleHeight + self.strokeWidth + 0.5f, self.borderRadius - self.strokeWidth);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
//    /* The clipping path at the end can be left out if you're not going to use a gradient or some other more fill that's more complex than a simple color. */
//    // Draw a clipping path for the fill
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, self.borderRadius + self.strokeWidth + 0.5f, round((currentFrame.size.height + self.triangleHeight) * 0.50f) + 0.5f);
//    CGContextAddArcToPoint(context, currentFrame.size.width - self.strokeWidth - 0.5f, round((currentFrame.size.height + self.triangleHeight) * 0.50f) + 0.5f, currentFrame.size.width - self.strokeWidth - 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.borderRadius - self.strokeWidth);
//    CGContextAddArcToPoint(context, currentFrame.size.width - self.strokeWidth - 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, round(currentFrame.size.width / 2.0f + self.triangleWidth / 2.0f) - self.strokeWidth + 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.borderRadius - self.strokeWidth);
//    CGContextAddArcToPoint(context, self.strokeWidth + 0.5f, currentFrame.size.height - self.strokeWidth - 0.5f, self.strokeWidth + 0.5f, self.triangleHeight + self.strokeWidth + 0.5f, self.borderRadius - self.strokeWidth);
//    CGContextAddArcToPoint(context, self.strokeWidth + 0.5f, round((currentFrame.size.height + self.triangleHeight) * 0.50f) + 0.5f, currentFrame.size.width - self.strokeWidth - 0.5f, round((currentFrame.size.height + self.triangleHeight) * 0.50f) + 0.5f, self.borderRadius - self.strokeWidth);
//    CGContextClosePath(context);
//    CGContextClip(context);
    
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
//    _backgroundAlpha = backgroundAlpha;
    self.alpha = backgroundAlpha;
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth
{
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    _borderRadius = borderRadius;
    [self setNeedsDisplay];
}

- (void)setTriangleWidth:(CGFloat)triangleWidth
{
    _triangleWidth = triangleWidth;
    [self setNeedsDisplay];
}

- (void)setTriangleHeight:(CGFloat)triangleHeight
{
    _triangleHeight = triangleHeight;
    [self setNeedsDisplay];
}

- (void)setIsTrianglePointingDown:(BOOL)isTrianglePointingDown
{
    _isTrianglePointingDown = isTrianglePointingDown;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

- (void)setup
{
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    self.backgroundColor = [UIColor blackColor];
    self.borderColor = [UIColor lightGrayColor];
    self.backgroundAlpha = 0.75;
    self.strokeWidth = 3.0;
    self.borderRadius = 8;
    self.triangleWidth = 40;
    self.triangleHeight = 20;
    self.isTrianglePointingDown = YES;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}


@end

//
//  SSSegmentedControl.m
//
//  Copyright (c) 2014 StyleShare (https://stylesha.re)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <UIImage+Additions/UIImage+Additions.h>

#import "SSSegmentedControl.h"


static const CGFloat SSSegmentedControlDefaultBorderWidth = 1;
static const CGFloat SSSegmentedControlDefaultCornerRadius = 2;


@interface SSSegmentedControl ()

@property (nonatomic, strong) NSMutableDictionary *backgroundColorForState;
@property (nonatomic, strong) NSMutableDictionary *borderColorForState;
@property (nonatomic, readonly) NSArray *segments;

@end


@implementation SSSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColorForState = [NSMutableDictionary dictionary];
        self.borderColorForState = [NSMutableDictionary dictionary];
        
        _borderWidth = SSSegmentedControlDefaultBorderWidth;
        _cornerRadius = SSSegmentedControlDefaultCornerRadius;
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                            forState:UIControlStateSelected];
    }
    return self;
}


#pragma mark - Background Color

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    NSAssert(color != nil, @"Background color cannot be nil.");
    self.backgroundColorForState[@(state)] = color;
    [self _updateBackgroundImageForState:state];
}

- (UIColor *)backgroundColorForState:(UIControlState)state
{
    UIColor *backgroundColor = self.backgroundColorForState[@(state)];
    if (backgroundColor) {
        return backgroundColor;
    }
    
    switch (state) {
        case UIControlStateNormal:
            return [UIColor whiteColor];
            
        case UIControlStateHighlighted:
            return [self.tintColor colorWithAlphaComponent:0.2];
            
        case UIControlStateSelected:
            return self.tintColor;
            
        default:
            return self.tintColor;
    }
}


#pragma mark - Border Color

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
    NSAssert(color != nil, @"Border color cannot be nil.");
    self.borderColorForState[@(state)] = color;
    [self _updateBackgroundImageForState:state];
    [self _updateDividerImageForState:state];
}

- (UIColor *)borderColorForState:(UIControlState)state
{
    UIColor *borderColor = self.borderColorForState[@(state)];
    if (borderColor) {
        return borderColor;
    }
    return self.tintColor;
}


#pragma mark - Background Image

- (void)_updateBackgroundImagesForAllStates
{
    [self _updateBackgroundImageForState:UIControlStateNormal];
    [self _updateBackgroundImageForState:UIControlStateHighlighted];
    [self _updateBackgroundImageForState:UIControlStateSelected];
}

- (void)_updateBackgroundImageForState:(UIControlState)state
{
    UIColor *backgroundColor = [self backgroundColorForState:state];
    UIColor *borderColor = [self borderColorForState:state];
    NSDictionary *borderAttributes = @{NSStrokeColorAttributeName: borderColor,
                                       NSStrokeWidthAttributeName: @(self.borderWidth)};
    UIImage *backgroundImage = [UIImage resizableImageWithColor:backgroundColor
                                               borderAttributes:borderAttributes
                                                   cornerRadius:self.cornerRadius];
    [self setBackgroundImage:backgroundImage forState:state barMetrics:UIBarMetricsDefault];
}


#pragma mark - Divider Images

- (void)_updateDivierImagesForAllStates
{
    [self _updateDividerImageForState:UIControlStateNormal];
    [self _updateDividerImageForState:UIControlStateHighlighted];
    [self _updateDividerImageForState:UIControlStateSelected];
}

- (void)_updateDividerImageForState:(UIControlState)state
{
    UIColor *color = [self borderColorForState:state];
    UIImage *image = [self _createDividerImageWithColor:color];
    
    void (^setDividerImage)(UIControlState, UIControlState) = ^(UIControlState left, UIControlState right) {
        [self setDividerImage:image forLeftSegmentState:left rightSegmentState:right barMetrics:UIBarMetricsDefault];
    };
    
    switch (state) {
        case UIControlStateNormal:
            setDividerImage(UIControlStateNormal, UIControlStateNormal);
            break;
            
        case UIControlStateHighlighted:
            setDividerImage(UIControlStateHighlighted, UIControlStateNormal);
            setDividerImage(UIControlStateNormal, UIControlStateHighlighted);
            break;
            
        case UIControlStateSelected:
            setDividerImage(UIControlStateSelected, UIControlStateNormal);
            setDividerImage(UIControlStateNormal, UIControlStateSelected);
            setDividerImage(UIControlStateSelected, UIControlStateHighlighted);
            setDividerImage(UIControlStateHighlighted, UIControlStateSelected);
            break;
            
        default:
            break;
    }
}

- (UIImage *)_createDividerImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.borderWidth, 2);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextBeginPath(context);
    CGContextAddRect(context, rect);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *dividerImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    return dividerImage;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UIView *highlightedSegment = nil;
    for (UIView *segment in self.segments) {
        UIControlState state = [self segmentStateForSegment:segment];
        if (state == UIControlStateHighlighted) {
            highlightedSegment = segment;
            break;
        }
    }
    
    BOOL isSelected = [[highlightedSegment valueForKeyPath:@"isSelected"] boolValue];
    if (isSelected) {
        [super touchesEnded:touches withEvent:event];
    }
}


#pragma mark - Private APIs

- (NSArray *)segments
{
    return [self valueForKeyPath:@"_segments"];
}

- (UIControlState)segmentStateForSegment:(UIView *)segment
{
    NSAssert([segment isKindOfClass:NSClassFromString(@"UISegment")], @"Segment must be an instance of UISegment.");
    return [[segment valueForKeyPath:@"_segmentState"] integerValue];
}

@end

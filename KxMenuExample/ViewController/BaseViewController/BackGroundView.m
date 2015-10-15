//
//  BackGroundView.m
//  mm
//
//  Created by xuming on 15/7/7.
//  Copyright (c) 2015年 xuming. All rights reserved.
//

#import "BackGroundView.h"

@implementation BackGroundView

- (id)initWithView:(UIView *)view {
    // Let's check if the view is nil (this is a common error when using the windw initializer above)
    if (!view) {
        [NSException raise:@"MBProgressHUDViewIsNillException"
                    format:@"The view used in the MBProgressHUD initializer is nil."];
    }
    id me = [self initWithFrame:view.bounds];
    // We need to take care of rotation ourselfs if we're adding the HUD to a window
    if ([view isKindOfClass:[UIWindow class]]) {
       // [self setTransformForCurrentOrientation:NO];
    }

    
    return me;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.dimBackground) {
        //Gradient colours
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0.5f,0.5f,0.5f,0.0f,0.0f,0.5f,0.5f,0.75f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace);
        
        //Gradient center
        CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //Gradient radius
        float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
        //Gradient draw
        CGContextDrawRadialGradient (context, gradient, gradCenter,
                                     0, gradCenter, gradRadius,
                                     kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
    
//    // Center HUD
//    CGRect allRect = self.bounds;
//    // Draw rounded HUD bacgroud rect
//    CGRect boxRect = CGRectMake(roundf((allRect.size.width - self.width) / 2) + self.xOffset,
//                                roundf((allRect.size.height - self.height) / 2) + self.yOffset, self.width, self.height);
//    // Corner radius
//    float radius = 10.0f;
//    
//    CGContextBeginPath(context);
//    CGContextSetGrayFillColor(context, 0.0f, self.opacity);
//    CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
//    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
//    CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
//    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
//    CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
}


@end

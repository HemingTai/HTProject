//
//  UIView+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

- (UIImage *)capture {
    UIGraphicsBeginImageContext (self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addParallaxEffectWithDepth:(double)depth {
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.maximumRelativeValue = @(depth);
    horizontalEffect.minimumRelativeValue = @(-depth);
    [self addMotionEffect:horizontalEffect];
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    verticalEffect.maximumRelativeValue = @(depth);
    verticalEffect.minimumRelativeValue = @(-depth);
    [self addMotionEffect:verticalEffect];
}

@end

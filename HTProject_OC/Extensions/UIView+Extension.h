//
//  UIView+Extension.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extension)

- (UIImage *)capture;

//! 添加视差效果
- (void)addParallaxEffectWithDepth:(double)depth;

@end

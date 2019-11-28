//
//  UIBezierPath+Extension.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/27.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//  绘制圆角

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, HTRectCorner) {
    HTRectCornerTopLeft     = 1 << 0,
    HTRectCornerTopRight    = 1 << 1,
    HTRectCornerBottomLeft  = 1 << 2,
    HTRectCornerBottomRight = 1 << 3,
    HTRectCornerAllCorners  = ~0UL
};

@interface UIBezierPath (Extension)

+ (instancetype)ht_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(HTRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END

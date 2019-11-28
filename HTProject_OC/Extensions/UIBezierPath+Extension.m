//
//  UIBezierPath+Extension.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/27.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "UIBezierPath+Extension.h"

@implementation UIBezierPath (Extension)

+ (instancetype)ht_bezierPathWithRoundedRect:(CGRect)rect byRoundingCorners:(HTRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat maxCorner = MIN(rect.size.width, rect.size.height) / 2;
    
    CGFloat topLeftRadius = MIN(maxCorner, (corners & HTRectCornerTopLeft) ? cornerRadius : 0);
    CGFloat topRightRadius = MIN(maxCorner, (corners & HTRectCornerTopRight) ? cornerRadius : 0);
    CGFloat bottomLeftRadius = MIN(maxCorner, (corners & HTRectCornerBottomLeft) ? cornerRadius : 0);
    CGFloat bottomRightRadius = MIN(maxCorner, (corners & HTRectCornerBottomRight) ? cornerRadius : 0);
    
    CGPoint topLeft = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
    CGPoint topRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint bottomRight = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    
    [path moveToPoint:CGPointMake((rect.origin.x + rect.size.width * (CGFloat)0.5), rect.origin.y+rect.size.height)];
//    [path appendBezierPathWithArcFromPoint:topLeft toPoint:bottomLeft radius:topLeftRadius];
//    [path appendBezierPathWithArcFromPoint:bottomLeft toPoint:bottomRight radius:bottomLeftRadius];
//    [path appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight radius:bottomRightRadius];
//    [path appendBezierPathWithArcFromPoint:topRight toPoint:topLeft radius:topRightRadius];
    [path closePath];
    
    return path;
}

@end

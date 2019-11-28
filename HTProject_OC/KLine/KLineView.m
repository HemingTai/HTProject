//
//  KLineView.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/13.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "KLineView.h"

@implementation KLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSInteger i = 2;
    while (i>0) {
        [self drawCandle];
        i--;
    }
}

- (void)drawCandle {
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSInteger i = 10;
    while (i>0) {
        //设置画笔颜色
        UIColor *strokeColor = arc4random()%2?UIColor.redColor:UIColor.greenColor;
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        
        //画粗线
        CGPoint startPoint = CGPointMake(arc4random()%375, arc4random()%600+98);
        CGPoint endPoint = CGPointMake(startPoint.x, arc4random()%(100)+startPoint.y);
        CGContextSetLineWidth(context, 8);
        const CGPoint solidPoints[] = {startPoint, endPoint};
        CGContextStrokeLineSegments(context, solidPoints, 2);
        
        //画细线
        CGPoint highPoint = CGPointMake(startPoint.x, startPoint.y-10);
        CGPoint lowPoint = CGPointMake(endPoint.x, endPoint.y+10);
        CGContextSetLineWidth(context, 1);
        const CGPoint shadowPoints[] = {highPoint , lowPoint};
        CGContextStrokeLineSegments(context, shadowPoints, 2);
        i--;
    }
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, UIColor.yellowColor.CGColor);
    CGPoint linePoints[] = {CGPointMake(10, 120),CGPointMake(30, 140),CGPointMake(60, 80),CGPointMake(100, 160),CGPointMake(190, 210),CGPointMake(330, 180)};
    CGContextAddLines(context, linePoints, 6);
    CGContextStrokePath(context);
}

@end

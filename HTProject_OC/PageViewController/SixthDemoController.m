//
//  CAShapeLayerDemo.m
//  Demo
//
//  Created by Mr.Tai on 16/7/11.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

#import "SixthDemoController.h"

/*!
 @abstract 角度(0-360°)转换成PI(0-2pi)的方式
 */
#define DEGREETORADIUS(X) (M_PI*(X)/180.0)

@interface SixthDemoController()

@property (nonatomic, strong)UIView *circleView;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *redView;
@property (nonatomic, strong)UIView *rectangleView;

@end

@implementation SixthDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.circleView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self.view addSubview:self.circleView];
    [self drawCircle];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(120, 10, 100, 100)];
    [self.view addSubview:self.bgView];
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    self.redView.center = CGPointMake(144.9, 103.3);
    self.redView.layer.cornerRadius = 4;
    self.redView.clipsToBounds = YES;
    self.redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.redView];
    [self createCircleProgressView];
    
    self.rectangleView = [[UIView alloc]initWithFrame:CGRectMake(260, 20, 90, 90)];
    [self.view addSubview:self.rectangleView];
    [self drawRectangle];
}

- (void)drawCircle {
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc]init];
    circleLayer.frame = self.circleView.bounds;
    circleLayer.lineWidth = 2.0f;
    circleLayer.fillColor = nil;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    [self.circleView.layer addSublayer:circleLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                                        radius:50
                                                    startAngle:DEGREETORADIUS(270)
                                                      endAngle:DEGREETORADIUS(270-0.0001)
                                                     clockwise:YES];
    circleLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [circleLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    [self performSelector:@selector(drawCheck) withObject:nil afterDelay:1.0f];
}

- (void)drawCheck {
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.strokeColor = [UIColor redColor].CGColor;
    checkLayer.fillColor = nil;
    checkLayer.lineWidth = 2.0f;
    checkLayer.strokeEnd = 1;
    [self.circleView.layer addSublayer:checkLayer];
    
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(20, 40)];
    [checkPath addLineToPoint:CGPointMake(38, 68)];
    [checkPath addLineToPoint:CGPointMake(85, 35)];
    checkLayer.path = checkPath.CGPath;
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.duration = 0.5f;
    [checkLayer addAnimation:checkAnimation forKey:nil];
}

- (void)createCircleProgressView {
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bgView.bounds;
    bgLayer.fillColor = nil;
    bgLayer.strokeColor = [UIColor yellowColor].CGColor;
    bgLayer.lineWidth = 8.0f;
    bgLayer.lineCap = kCALineCapRound;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                                        radius:50
                                                    startAngle:DEGREETORADIUS(120)
                                                      endAngle:DEGREETORADIUS(60)
                                                     clockwise:YES];
    bgLayer.path = path.CGPath;
    [self.bgView.layer addSublayer:bgLayer];
    [self performSelector:@selector(setProgress) withObject:nil afterDelay:0.5];
}

- (void)setProgress {
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bgView.bounds;
    progressLayer.fillColor = nil;
    progressLayer.strokeColor = [UIColor greenColor].CGColor;
    progressLayer.lineWidth = 8.0f;
    progressLayer.lineCap = kCALineCapRound;
    //参数分别指定:圆弧的中心,半径,开始角度,结束角度,是否顺时针方向。
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                                                radius:50
                                                            startAngle:DEGREETORADIUS(120)
                                                              endAngle:DEGREETORADIUS(20)
                                                             clockwise:YES];
    progressLayer.path = progressPath.CGPath;
    [self.bgView.layer addSublayer:progressLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [progressLayer addAnimation:animation forKey:@"ProgressAnimation"];
    
    CAKeyframeAnimation *redAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    redAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    redAnimation.fillMode = kCAFillModeForwards;
    redAnimation.removedOnCompletion = NO;
    redAnimation.duration = 2.0f;
    //设置动画路径
    CGMutablePathRef redPath = CGPathCreateMutable();
    //参数分别指定:动画路径,transform,圆心点,半径,起始角度,结束角度,是否顺时针方向(注意:这里方向为反向)。
    CGPathAddArc(redPath, NULL, 170, 60, 50, DEGREETORADIUS(120), DEGREETORADIUS(20), 0);
    redAnimation.path = redPath;
    CGPathRelease(redPath);
    [self.redView.layer addAnimation:redAnimation forKey:@"RedAnimation"];
}

- (void)drawRectangle {
    CAShapeLayer *RectangleLayer = [CAShapeLayer layer];
    RectangleLayer.frame = self.rectangleView.bounds;
    RectangleLayer.fillColor = nil;
    RectangleLayer.strokeColor = [UIColor blueColor].CGColor;
    RectangleLayer.lineWidth = 2.0f;
    RectangleLayer.strokeEnd = 1;
    [self.rectangleView.layer addSublayer:RectangleLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.rectangleView.bounds cornerRadius:5];
    RectangleLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1.0;
    [RectangleLayer addAnimation:animation forKey:nil];
}

@end

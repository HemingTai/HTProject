//
//  WaveView.m
//  Demo
//
//  Created by Mr.Tai on 16/5/20.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

#import "WaveView.h"

@interface WaveView()

@property (nonatomic, assign) CGFloat waveAmplitude;//振幅
@property (nonatomic, assign) CGFloat waveFrequency;//频率
@property (nonatomic, assign) CGFloat wavePercentage;//百分比
@property (nonatomic, assign) BOOL enableResetWave;//重置
@property (nonatomic, strong) NSTimer *timer;//定时器

@end

@implementation WaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame])
    {
        self.backgroundColor = [UIColor getColorFromHexString:@"e8e8e8"];
        self.wavePercentage = 0.28f;
        [self createWaves];
    }
    return self;
}

- (void)createWaves {
    self.waveAmplitude = 10.0f;
    self.waveFrequency = 0;
    self.enableResetWave = YES;
    //timeInterval控制波浪快慢
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.07f
                                                  target:self
                                                selector:@selector(animateWave:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)animateWave:(NSTimer *)sender {
    const CGFloat amplitudeStep = .1f;
    const CGFloat frequencyStep = .5f;
    
    if (self.enableResetWave) {
        self.waveAmplitude += amplitudeStep;
    }
    else {
        self.waveAmplitude -= amplitudeStep;
    }
    if (self.waveAmplitude <= 1.0f) {
        self.enableResetWave = YES;
    }
    if (self.waveAmplitude >= 15.0f) {
        self.enableResetWave = NO;
    }
    self.waveFrequency += frequencyStep;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, TRUE);//抗锯齿显示
    CGContextSetAllowsAntialiasing(context, TRUE);//抗锯齿显示
    
    //绘制波浪
    if (self.wavePercentage <= 0.0 || self.wavePercentage >= 1.0) {
        return ;
    }
    CGContextSaveGState(context);
    
    CGFloat topY = CGRectGetHeight(rect)*self.wavePercentage;
    CGFloat bottomY = CGRectGetHeight(rect);
    CGFloat leftX = 0;
    CGFloat rightX = CGRectGetWidth(rect);
    
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    [wavePath moveToPoint:CGPointMake(rightX, topY)];
    [wavePath addLineToPoint:CGPointMake(rightX, bottomY)];
    [wavePath addLineToPoint:CGPointMake(leftX, bottomY)];
    [wavePath addLineToPoint:CGPointMake(leftX, topY)];
    
    for (float x=leftX; x<=rightX; ++x) {
        CGFloat y = self.waveAmplitude*sinf(x/180*M_PI + self.waveFrequency/M_PI) + topY;//水面效果
        [wavePath addLineToPoint:CGPointMake(x, y)];
    }
    [wavePath closePath];
    CGContextSetFillColorWithColor(context, [UIColor getColorFromHexString:@"96ca20"].CGColor);
    CGContextAddPath(context, wavePath.CGPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    // another wave
    CGContextSaveGState(context);
    UIBezierPath *anotherWavePath = [UIBezierPath bezierPath];
    [anotherWavePath moveToPoint:CGPointMake(rightX, topY)];
    [anotherWavePath addLineToPoint:CGPointMake(rightX, bottomY)];
    [anotherWavePath addLineToPoint:CGPointMake(leftX, bottomY)];
    [anotherWavePath addLineToPoint:CGPointMake(leftX, topY)];
    
    for (float x = leftX; x <= rightX; ++x) {
        CGFloat y = self.waveAmplitude*sinf(x/180*M_PI + self.waveFrequency/M_PI + M_PI_2) + topY;
        [anotherWavePath addLineToPoint:CGPointMake(x, y)];
    }
    [anotherWavePath closePath];
    CGContextSetFillColorWithColor(context, [UIColor getColorFromHexString:@"0e83c8"].CGColor);
    CGContextAddPath(context, anotherWavePath.CGPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

- (void)dealloc {
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

//
//  ReverseProgressView.m
//  ecmc
//
//  Created by Mr.Tai on 16/6/6.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

#import "ReverseProgressView.h"

@interface ReverseProgressView()

@property (nonatomic, strong) UILabel *bgView;
@property (nonatomic, strong) UILabel *progressView;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) CGFloat targetProgress;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation ReverseProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgView.layer.cornerRadius = frame.size.height/2;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        _progressView = [[UILabel alloc]initWithFrame:_bgView.frame];
        _progressView.layer.cornerRadius = frame.size.height/2;
        _progressView.clipsToBounds = YES;
        [self addSubview:_progressView];
        
        _currentProgress = 0.0;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor {
    _progressView.backgroundColor = progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor {
    _bgView.backgroundColor = trackTintColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setIsReverse:(BOOL)isReverse {
    _isReverse = isReverse;
}

//! 设置进度
- (void)setTargetProgress:(CGFloat)progress animateWithDuration:(NSTimeInterval)duration {
    if (progress <= 0) {
        _targetProgress = 0;
    }
    else if (progress >= 1) {
        _targetProgress = 1;
    }
    else {
        _targetProgress = progress;
    }
    _duration = duration;
    [self moveProgress];
}

//! 移动进度条
- (void)moveProgress {
    if(self.isReverse) {
        CGFloat originalX = self.frame.size.width*self.targetProgress;
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = self.progressView.frame;
            frame.origin.x = originalX;
            self.progressView.frame = frame;
        }];
    }
    else {
        CGRect frame = self.progressView.frame;
        frame.size.width = 0;
        self.progressView.frame = frame;
        CGFloat width = self.frame.size.width*self.targetProgress;
        [UIView animateWithDuration:self.duration animations:^{
            CGRect frame = self.progressView.frame;
            frame.size.width = width;
            self.progressView.frame = frame;
        }];
    }
}

@end

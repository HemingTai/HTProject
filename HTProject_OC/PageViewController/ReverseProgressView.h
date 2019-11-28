//
//  ReverseProgressView.h
//
//
//  Created by Mr.Tai on 16/6/6.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  逆向进度条

#import <UIKit/UIKit.h>

@interface ReverseProgressView : UIView

//! 进度条颜色
@property (nonatomic, strong) UIColor *progressTintColor;
//! 进度条背景颜色
@property (nonatomic, strong) UIColor *trackTintColor;
//! 进度条边线颜色
@property (nonatomic, strong) UIColor *borderColor;
//! 是否逆向
@property (nonatomic, assign) BOOL     isReverse;

//! 设置进度、动画时间
- (void)setTargetProgress:(CGFloat)progress animateWithDuration:(NSTimeInterval)duration;

@end

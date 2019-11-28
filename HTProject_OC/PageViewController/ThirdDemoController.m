//
//  ThirdDemoController.m
//  Demo
//
//  Created by Mr.Tai on 16/5/20.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  水波纹，进度条

#import "ThirdDemoController.h"
#import "WaveView.h"
#import "ReverseProgressView.h"

@implementation ThirdDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ReverseProgressView *reverseProgressView = [[ReverseProgressView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-10*2, 9.0f)];
    reverseProgressView.progressTintColor = [UIColor getColorFromHexString:@"589AF0"];
    reverseProgressView.trackTintColor = [UIColor getColorFromHexString:@"FFFFFF"];
    reverseProgressView.borderColor = [UIColor getColorFromHexString:@"e3e3e3"];
    reverseProgressView.layer.borderWidth = 0.5;
    reverseProgressView.layer.cornerRadius = 4.5f;
    reverseProgressView.isReverse = YES;
    [reverseProgressView setTargetProgress:0.25 animateWithDuration:1];
    [self.view addSubview:reverseProgressView];
    
    ReverseProgressView *progressView = [[ReverseProgressView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-10*2, 9.0f)];
    progressView.progressTintColor = [UIColor getColorFromHexString:@"589AF0"];
    progressView.trackTintColor = [UIColor getColorFromHexString:@"FFFFFF"];
    progressView.borderColor = [UIColor getColorFromHexString:@"e3e3e3"];
    progressView.layer.borderWidth = 0.5;
    progressView.layer.cornerRadius = 4.5f;
    [progressView setTargetProgress:0.25 animateWithDuration:1];
    [self.view addSubview:progressView];
    
    WaveView *wave = [[WaveView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    [self.view addSubview:wave];
}

@end

//
//  HTHeaderView.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/12.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "HTHeaderView.h"

@interface HTHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HTHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    NSLog(@"--initWithFrame被调用");
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.text = @"Hem1ngT4i";
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    /************************* layoutSubviews *************************
     * 当一个视图“认为”应该重新布局自己的子控件时，它便会自动调用自己的layoutSubviews方法，在该方法中“刷新”子控件的布局；
     * 注意：自定义view仅仅被初始化完成，未添加至父视图中时，该view的layoutSubviews方法是不会被调用的，即以下情况不会被调用：
     *      self.titleLabel = [[UILabel alloc] init];
     *      self.titleLabel = [[UILabel alloc] initWithFrame:frame];
     * 自定义view的layoutSubviews方法调用时机：
     * 1）当被添加至父视图中时会被调用：[self addSubview:self.titleLabel];
     *
     *
     *
     *
     */
    NSLog(@"--layoutSubviews被调用");
}

@end

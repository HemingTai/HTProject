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
    self = [super initWithFrame:frame];
    if (self) {
//        [self addTitleLabel];
    }
    return self;
}

//MARK: ------ override ------

- (void)layoutSubviews {
    [super layoutSubviews];
    /************************* layoutSubviews *************************
     * 当一个视图“认为”应该重新布局自己的子控件时，它便会自动调用自己的layoutSubviews方法，在该方法中“刷新”子控件的布局；
     * 注意：自定义view仅仅被初始化完成，未添加至父视图中时，该view的layoutSubviews方法是不会被调用的，即以下情况不会被调用：
     *    self.titleLabel = [[UILabel alloc] init];
     *    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
     * 自定义view的layoutSubviews方法调用时机：
     * 1）当被添加至父视图中时会被调用：[XXX addSubview:self];
     * 2）自身大小发生变化时会被调用：self.frame = CGRectMake(0, 0, 300, 30);
     * 3）添加子视图时会被调用：[self addSubview:self.titleLabel];
     * 4）子视图大小发生变化时会被调用：self.titleLabel.frame = CGRectMake(0, 0, 200, 30);
     * 5）当滚动一个UIScrollView时会被调用
     * 6）当旋转屏幕时会被调用
     */
    NSLog(@"--layoutSubviews被调用");
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    /**如果需要，立即布局： 默认情况下，当有相关触发事件时，layoutSubviews方法会被调用，但这种调用机制是延迟的，而layoutIfNeeded可以保证立即调用。*/
}

//MARK: ------ functions ------

- (void)addTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.titleLabel.text = @"Hem1ngT4i";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)updateTitleLabel {
    self.titleLabel.frame = self.bounds;
}

@end

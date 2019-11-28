//
//  GJRefreshGifHeader.m
//  GJMetalNet
//
//  Created by Miller on 2019/1/15.
//  Copyright © 2019 GP. All rights reserved.
//

#import "GJRefreshGifHeader.h"
#import <Masonry.h>

@implementation GJRefreshGifHeader

- (void)prepare {
    [super prepare];
    NSArray *nameArray = @[@"ic_global_loading_01",@"ic_global_loading_02",@"ic_global_loading_03",@"ic_global_loading_04",@"ic_global_loading_05",@"ic_global_loading_06",@"ic_global_loading_07"];
    NSMutableArray *refreshingImages  = [NSMutableArray array];
    for (NSString *name in nameArray) {
        [refreshingImages addObject:[UIImage imageNamed:name]];
    }
    [self setImages:@[[UIImage imageNamed:@"ic_global_loading_01"]] forState:MJRefreshStateIdle];
    [self setImages:@[[UIImage imageNamed:@"ic_global_loading_01"]] forState:MJRefreshStatePulling];
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES ;
    self.stateLabel.textColor = UIColor.blackColor;
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"正在刷新" forState:MJRefreshStateRefreshing];
    
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lastUpdatedTimeLabel);
        make.centerY.equalTo(self.lastUpdatedTimeLabel).offset(20);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gifView);
        make.bottom.equalTo(self.gifView).offset(20);
    }];
}

@end

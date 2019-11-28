//
//  ViewModel.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "ViewModel.h"
#import "HTModel.h"

@implementation ViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        [RACObserve(self, contentKey) subscribeNext:^(NSString * _Nullable x) {
            NSArray *array = @[@"微信", @"QQ", @"支付宝", @"今日头条", @"淘宝", @"京东", @"闲鱼", @"简书"];
            NSMutableArray *modelArray = [[NSMutableArray alloc] init];
            for (NSString *obj in array)
            {
                HTModel *model = [[HTModel alloc] init];
                model.title = obj;
                if (![obj isEqualToString:x])
                {
                    [modelArray addObject:model];
                }
            }
            if (self.successBlock)
            {
                self.successBlock([modelArray copy]);
            }
        }];
    }
    return self;
}

- (void)initWithSuccess:(Success)successBlock failure:(Failure)failureBlock
{
    [super initWithSuccess:successBlock failure:failureBlock];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        NSArray *array = @[@"微信", @"QQ", @"支付宝", @"今日头条", @"淘宝", @"京东", @"闲鱼", @"简书"];
        for (NSString *obj in array)
        {
            HTModel *model = [[HTModel alloc] init];
            model.title = obj;
            [modelArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock)
            {
                successBlock([modelArray copy]);
            }
        });
    });
}

@end

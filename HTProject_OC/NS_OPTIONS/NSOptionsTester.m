//
//  NSOptionsTester.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/3.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSOptionsTester.h"

/**********************************************************************************************
 * NS_OPTIONS是一个枚举，与NS_ENUM唯一的区别就在于命名不一样
 * 通常会在枚举值后面加上移位运算，如 1 << 3，表示该枚举值对应的是2^3所对应的二进制数：00001000
 * 这样做的好处是可以一次性传递多个枚举值，以 | 符号 连接，如 HTUserActionTypeOne | HTUserActionTypeTwo
 **********************************************************************************************/
typedef NS_OPTIONS(NSUInteger, HTUserActionType) {
    HTUserActionTypeOne   = 1 << 0,
    HTUserActionTypeTwo   = 1 << 1,
    HTUserActionTypeThree = 1 << 2,
    HTUserActionTypeFour  = 1 << 3,
    HTUserActionTypeFive  = 1 << 4,
    HTUserActionTypeSix   = 1 << 5,
    HTUserActionTypeSeven = 1 << 6,
    HTUserActionTypeEight = 1 << 7,
    HTUserActionTypeNine  = 1 << 8,
    HTUserActionTypeTen   = 1 << 9,
};

@implementation NSOptionsTester

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /****************************************************************************************
     *    计算前对应的二进制数             0000000010 | 0000100000 | 1000000000
     *    或运算                         ————————————————————————————————————
     *    运算后结果                                    1000100010
     ***************************************************************************************/
    [self handleActionWithType: HTUserActionTypeTwo|HTUserActionTypeSix|HTUserActionTypeTen];
}

- (void)handleActionWithType:(HTUserActionType)type {
    /****************************************************************************************
     *    参数是运算后的二进制数           1000100010    1000100010    1000100010
     *    条件                          0000000010    0000100000    1000000000
     *    与运算                        ———————————   ———————————   ———————————
     *    运算结果不为0说明符合条件        0000000010    0000100000    1000000000
     ***************************************************************************************/
    if (type & HTUserActionTypeOne) {
        NSLog(@"HTUserActionTypeOne");
    }
    if (type & HTUserActionTypeTwo) {
        NSLog(@"HTUserActionTypeTwo");
    }
    if (type & HTUserActionTypeThree) {
        NSLog(@"HTUserActionTypeThree");
    }
    if (type & HTUserActionTypeFour) {
        NSLog(@"HTUserActionTypeFour");
    }
    if (type & HTUserActionTypeFive) {
        NSLog(@"HTUserActionTypeFive");
    }
    if (type & HTUserActionTypeSix) {
        NSLog(@"HTUserActionTypeSix");
    }
    if (type & HTUserActionTypeSeven) {
        NSLog(@"HTUserActionTypeSeven");
    }
    if (type & HTUserActionTypeEight) {
        NSLog(@"HTUserActionTypeEight");
    }
    if (type & HTUserActionTypeNine) {
        NSLog(@"HTUserActionTypeNine");
    }
    if (type & HTUserActionTypeTen) {
        NSLog(@"HTUserActionTypeTen");
    }
}


@end

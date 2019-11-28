//
//  NSObject+Calculate.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/29.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import "NSObject+Calculate.h"
#import "CalculatorMaker.h"

@implementation NSObject (Calculate)

+ (int)makeCalculators:(void (^)(CalculatorMaker * _Nonnull))mybolck
{
    CalculatorMaker *maker = [[CalculatorMaker alloc] init];
    mybolck(maker);
    return (maker.result);
}

@end

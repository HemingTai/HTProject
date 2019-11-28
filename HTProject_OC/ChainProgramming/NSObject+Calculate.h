//
//  NSObject+Calculate.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/29.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CalculatorMaker;

@interface NSObject (Calculate)

+ (int) makeCalculators:(void (^)(CalculatorMaker *make))mybolck;

@end

NS_ASSUME_NONNULL_END

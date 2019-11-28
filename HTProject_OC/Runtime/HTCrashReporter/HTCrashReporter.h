//
//  HTCrashReporter.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/24.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTCrashConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTCrashReporter : NSObject

/**
 根据崩溃类型拦截崩溃

 @param type 崩溃类型
 */
+ (void)ht_interceptCrashWithType:(HTCrashType)type;


/**
 交换实例方法
 
 @param cls 类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)ht_swizzleInstanceMethodForClass:(Class)cls
                        originalSelector:(SEL)originalSel
                       swizzlingSelector:(SEL)swizzlingSel;

/**
 交换类方法
 
 @param cls 元类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)ht_swizzleClassMethodForClass:(Class)cls
                     originalSelector:(SEL)originalSel
                    swizzlingSelector:(SEL)swizzlingSel;

/**
 捕获异常和异常类型

 @param exception 异常
 @param type 异常类型
 */
+ (void)ht_catchException:(NSException *)exception
            withCrashType:(HTCrashType)type;

@end

NS_ASSUME_NONNULL_END

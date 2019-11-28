//
//  NSObject+Swizzling.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/23.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

//! 拦截对象所有崩溃
+ (void)ht_interceptObjectAllCrash;

//! 拦截由于KVC引起的崩溃
+ (void)ht_interceptObjectCrashCausedByKVC;

//! 拦截由于未找到方法引起的崩溃
+ (void)ht_interceptObjectCrashCausedByUnrecognizedSelectorSentToInstance;

//! （❗️❗️❗️: 请勿调用该方法）拦截由于对象未释放引起的崩溃
+ (void)ht_interceptObjectCrashCausedByUnreleasedWithDeallocBlock:(void(^)(void))deallocBlock DEPRECATED_MSG_ATTRIBUTE("⚠️：该方法未启用！");

@end

NS_ASSUME_NONNULL_END

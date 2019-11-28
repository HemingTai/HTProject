//
//  NSArray+Swizzling.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/24.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Swizzling)

//! 拦截数组所有崩溃（包含可变数组）
+ (void)ht_interceptArrayAllCrash;

//! 拦截可变数组特有崩溃
+ (void)ht_interceptMutableArrayCrash;

//! 拦截数组由于越界引起的崩溃（包含可变数组）
+ (void)ht_interceptArrayCrashCausedByIndexBeyondBounds;

//! 拦截数组由于插入nil引起的崩溃（包含可变数组）
+ (void)ht_interceptArrayCrashCausedByAttemptToInsertNilObject;

@end

NS_ASSUME_NONNULL_END

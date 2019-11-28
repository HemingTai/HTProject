//
//  NSTimer+Swizzling.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Swizzling)

//! 拦截定时器所有崩溃
+ (void)ht_interceptTimerAllCrash;

@end

NS_ASSUME_NONNULL_END

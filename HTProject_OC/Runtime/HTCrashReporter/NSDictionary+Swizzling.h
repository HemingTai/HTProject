//
//  NSDictionary+Swizzling.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/2.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Swizzling)

//! 拦截字典所有崩溃
+ (void)ht_interceptDictionaryAllCrash;

@end

NS_ASSUME_NONNULL_END

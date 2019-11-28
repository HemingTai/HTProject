//
//  RuntimeViewController+Swizzling.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/4/1.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "RuntimeViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface RuntimeViewController (Swizzling)

+ (void)swizzlingInstanceMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)swizzlingClassMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END

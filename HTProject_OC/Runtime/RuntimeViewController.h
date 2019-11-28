//
//  RuntimeViewController.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/19.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuntimeTester : UIViewController

- (void)htMethod;

- (void)ht_testMethod;

- (void)ht_testMethodText:(NSString *)text;

@end

@interface RuntimeBaseViewController : UIViewController

- (void)htOriginalInstanceMethod;

@end

@interface RuntimeViewController : RuntimeBaseViewController

- (void)htMethod;

- (void)htInstanceMethod;

+ (void)htClassMethod;

//- (void)htOriginalInstanceMethod;

+ (void)htOriginalClassMethod;

- (void)htSwizzledInstanceMethod;

+ (void)htSwizzledClassMethod;

@end


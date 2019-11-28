//
//  TestViewController+MyTestVC.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "TestViewController+MyTestVC.h"
#import <objc/runtime.h>

static NSString *ageKey = @"AgeKey";

@implementation TestViewController (MyTestVC)

- (void)myTestFunction2
{
    NSLog(@"222222");
}

- (void)setAge:(NSString *)age
{
    objc_setAssociatedObject(self, &ageKey, age, OBJC_ASSOCIATION_COPY);
}

- (NSString *)age
{
    return objc_getAssociatedObject(self, &ageKey);
}

@end

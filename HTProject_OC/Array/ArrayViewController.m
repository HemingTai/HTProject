//
//  ArrayViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/22.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "ArrayViewController.h"

@implementation ArrayViewController

//MARK: ---------- LifeCycle ----------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self myTestFunction1];
    [self myTestFunction2];
}

- (void)myTestFunction1 {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", nil];
    for(NSInteger i=0; i < array.count; i++) {
        //可变数组每一次删除后都会改变，所以最后结果为2
        [array removeObjectAtIndex:i];
    }
    NSLog(@"array --- %@", array);
}

- (void)myTestFunction2 {
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@1,@2,@3,@4,nil];
    
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (idx == 2) {
//            //设置stop=YES,并不会停止输出，结果仍会全部输出：1，2，3，4
////            stop = YES;
//            //设置*stop=YES,当idx==2时会打破循环，但此次循环会执行完，所以结果会输出：1，2，3
//            *stop = YES;
//        }
//        NSLog(@"---%@",obj);
//    }];
    
    //可变数组遍历时删除元素，如果是快速枚举for..in必定会崩溃，如果是迭代器则可能会崩溃
    //所以如果必须要删除元素且不使用新的数组情况下，使用逆序遍历最安全
//    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"--%ld",idx);
//        [array removeObjectAtIndex:idx];
//        NSLog(@"---%@",array);
//    }];
    
//    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"--%ld",idx);
//        [array removeObjectAtIndex:idx];
//        NSLog(@"---%@",array);
//    }];
//
//    for (NSNumber *num in array) {
//        //直接删除会导致崩溃，原因是遍历的同时不能改变该数组，可以先copy一份再遍历，或者迭代器，或者逆向迭代
//        [array removeObject:num];
//    }
//
//    for (NSNumber *num in array.reverseObjectEnumerator) {
//        [array removeObject:num];
//    }
    
    NSLog(@"---%@",array);
}


@end

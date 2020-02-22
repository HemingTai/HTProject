//
//  TestViewController+MyTestVC.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

/***************************** 分类 *******************************
 * 分类可以在不修改原类的基础上，给原类添加方法
 * 分类中不可以添加成员变量
 * 分类中可以声明属性，但是在get，set方法中找不到_age变量，所以如果调用self.age会报错
 * 分类中想要使用声明的属性，可以通过runtime的关联对象，来实现添加并使用属性
 * runtime只是手动实现set，get方法，但是不能使用成员变量_age,否则依然报错
 * 分类中声明的方法如果没有实现也会报警告
 *****************************************************************/

#import "TestViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController (MyTestVC)
//{
//    NSString *_age;//分类中不可以添加成员变量，否则直接报错；原因是经过编译的类在程序启动后就被runtime加载，没有机会调用addIvar。程序在运行时动态构建的类需要在调用objc_registerClassPair之后才可以被使用，同样没有机会再添加成员变量。
//}

@property(nonatomic, copy) NSString *age;//分类中可以声明属性，但是在get，set方法中找不到_age变量，所以如果调用self.age会报错

- (void)myTestFunction2;

- (void)myTestFunction3;

@end

NS_ASSUME_NONNULL_END

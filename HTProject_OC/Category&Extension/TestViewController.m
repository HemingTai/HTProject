//
//  TestViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "TestViewController.h"
#import "TestViewController+MyTestVC.h"

/*************************************** 匿名分类/类扩展 *****************************************************************
 *可以添加成员变量
 *可以声明属性和方法
 *默认属性和方法是private类型
 *类扩展中声明的方法如果没有实现会报警告
 *category被附加到类上面是在map_images的时候发生的，在new-ABI的标准下，_objc_init里面的调用的map_images最终会调用objc-runtime-new.mm里面的_read_images方法
 **********************************************************************************************************************/
@interface TestViewController ()

@property(nonatomic, copy) NSString *height;

- (void)myTestFunction3;

@end

@implementation TestViewController

/********************************************** 总结 *******************************************************************
 类别与类扩展的区别：
 
 ①类别中原则上只能增加方法（能添加属性的的原因只是通过runtime解决setter/getter找不到对应变量的问题而已）；
 ②类扩展不仅可以增加方法，还可以增加实例变量（或者属性），只是该实例变量默认是@private类型的（使用范围只能在自身类，而不是子类或其他地方）；
 ③类扩展中声明的方法没被实现，编译器会报警，但是类别中的方法没被实现编译器是不会有任何警告的。这是因为类扩展是在编译阶段被添加到类中，而类别是在运行时添加到类中。
 ④类扩展不能像类别那样拥有独立的实现部分（@implementation部分），也就是说，类扩展所声明的方法必须依托对应类的实现部分来实现。
 ⑤定义在 .m 文件中的类扩展方法为私有的，定义在 .h 文件（头文件）中的类扩展方法为公有的。类扩展是在 .m 文件中声明私有方法的非常好的方式。
 ***********************************************************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self myTestFunction1];
    [self myTestFunction2];
    //在不使用runtime的关联对象方法前提下，直接调用会报错，有setAge方法，但是找不到_age变量
    self.age = @"30";
    NSLog(@"age:%@",self.age);//*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[TestViewController setAge:]: unrecognized selector sent to instance 0x10090e5a0'
}

- (void)myTestFunction1
{
    NSLog(@"111111");
    self.name = @"heming";
}

@end

//
//  RuntimeViewController+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/4/1.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "RuntimeViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation RuntimeViewController (Swizzling)

/************************************************* MethodSwizzling ***********************************************
 * 使用Swizzling的过程中要注意两个问题：
 * Swizzling要在+load方法中执行 运行时会自动调用每个类的两个方法，+load与+initialize。
 * +load会在main函数之前调用，并且一定会调用。
 * +initialize是在第一次调用类方法或实例方法之前被调用，有可能一直不被调用。
 *
 * 一般使用Swizzling是为了影响全局，所以为了方法交换一定成功，Swizzling要放在+load中执行。
 * Swzzling是为了影响全局，所以要放在dispatch_once中,只让它执行一次就可以了。
 *****************************************************************************************************************/

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingInstanceMethodWithOriginalSelector:@selector(htOriginalInstanceMethod) swizzledSelector:@selector(htSwizzledInstanceMethod)];
        [self swizzlingClassMethodWithOriginalSelector:@selector(htOriginalClassMethod) swizzledSelector:@selector(htSwizzledClassMethod)];
    });
}

+ (void)swizzlingInstanceMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    //先获取当前类
    Class class = self;
    //再获取原始方法和替换方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /*先尝试添加原 selector 是为了做一层保护，因为如果这个类没有实现原始方法"originalSelector" ，
      但其父类实现了，那 class_getInstanceMethod 会返回父类的方法，这样 method_exchangeImplementations 替换的是父类的那个方法。
     
     注!!!：为什么要先调用class_addMethod而不直接调用method_exchangeImplementations？
     
     先理解selector，method，implementation这三个概念之间的关系：在运行时，类(Class)维护了一个消息分发列表来解决消息的正确发送。
     每一个消息列表的入口是一个方法(Method)，这个方法映射了一对键值对，其中键值是这个方法的名字 selector(SEL)，值是指向这个方法
     实现的函数指针implementation(IMP)。Method swizzling 修改了类的消息分发列表使得已经存在的 selector 映射了另一个实现
     implementation，同时重命名了原生方法的实现为一个新的 selector。
     
     假设父类有个方法method，子类未重写method方法，子类的中想要拿来替换的方法为swizzledMethod：
     
     如果直接调用method_exchangeImplementations，在子类的实例中调用method方法时，确实按预期正常运行的。在父类的实例中调用method
     方法时，就开始崩溃了。因为方法交换后，method方法的IMP其实和子类swizzledMethod的IMP进行了交换，此时等同于父类调用子类方法，当然
     会崩溃（如果不涉及调用子类的方法是不会崩溃的，比如只是简单的在控制台输出信息等）。
     
     如果直接调用class_addMethod，会先判断了子类中是否有method方法，如果有，则添加失败，直接进行交换，如果没有，则添加成功，
     将swizzledMethod的IMP赋值给method这个Selector，然后在将method的IMP（其实是父类中的实现）赋值给swizzledMethod这个Selector
     */
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //如果成功则用原始方法实现替换新方法实现，否则交换两个方法的实现
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    //也可以直接设置原来方法的实现，注意新方法已经不能设置原来方法的实现，因为原来方法的实现已被覆盖
//    method_setImplementation(originalMethod, method_getImplementation(swizzledMethod));
}

+ (void)swizzlingClassMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    //先获取当前类的元类
    Class class = object_getClass(self);
    //再获取原始方法和替换方法
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    //再添加方法以改变原始方法的实现
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    //判断添加方法是否成功，如果成功则用原始方法实现替换新方法实现，否则交换两个方法的实现
    if (didAddMethod)
    {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    //也可以直接设置原来方法的实现，注意新方法已经不能设置原来方法的实现，因为原来方法的实现已被覆盖
//    method_setImplementation(originalMethod, method_getImplementation(swizzledMethod));
}

@end

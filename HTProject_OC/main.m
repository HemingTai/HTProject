//
//  main.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*************************************** main()之前的过程有哪些？ ************************************************************
 main()之前的过程有哪些？
 
 1）dyld 开始将程序二进制文件初始化
 2）交由ImageLoader 读取 image，其中包含了我们的类，方法等各种符号（Class、Protocol 、Selector、 IMP）
 3）由于runtime 向dyld 绑定了回调，当image加载到内存后，dyld会通知runtime进行处理
 4）runtime 接手后调用map_images做解析和处理
 5）接下来load_images 中调用call_load_methods方法，遍历所有加载进来的Class，按继承层次依次调用Class的+load和其他Category的+load方法
 6）至此 所有的信息都被加载到内存中
 7）最后dyld调用真正的main函数
 注意：dyld会缓存上一次把信息加载内存的缓存，所以第二次比第一次启动快一点
 **************************************************************************************************************************/

//argc, argv是系统传的参数，第三个参数(principalClassName)比较特殊，官方文档中解释为 If nil is specified for principalClassName,
//the value for NSPrincipalClass from the Info.plist is used. If there is no NSPrincipalClass key specified,
//the UIApplication class is used.
//它实质上是一个字符串，但是这个字符串比较特殊，你可以指定一个继承于UIApplication的子类类名，如果nil赋值给这个参数，则程序会首先从
//info.pilst中读取键为NSPrincipalClass的值，如果没有这个键值对，则使用“UIApplication”，第四个参数指定代理对象，可以使AppDelegate或者是继承于
//AppDelegate的子类。
int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}


//constructor属性表示在main函数执行之前，可以执行一些操作。constructor的执行时机是在所有load方法都执行完之后，才会执行所有constructor属性修饰的函数。
__attribute__((constructor(101))) static void beforeMain1() {
    NSLog(@"beforeMain1");
}
//在有多个constructor或destructor属性修饰的函数时，可以通过设置优先级来指定执行顺序。
//格式是__attribute__((constructor(101)))的方式，在属性后面直接跟优先级。
//在constructor中根据优先级越低，执行顺序越高。
__attribute__((constructor(102))) static void beforeMain2() {
    NSLog(@"beforeMain2");
}
//overloadable属性允许定义多个同名但不同参数类型的函数，在调用时编译器会根据传入参数类型自动匹配函数。类似于C++的重载
__attribute__((overloadable)) void myPersonalInfo(int age) {
    NSLog(@"my age is %d", age);
}
__attribute__((overloadable)) void myPersonalInfo(NSString *name) {
    NSLog(@"my name is %@", name);
}
__attribute__((overloadable)) void myPersonalInfo(BOOL isVip) {
    NSLog(@"my vip is %d", isVip);
}

//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        myPersonalInfo(20);
//        myPersonalInfo(@"Hem1ngT4i");
//        myPersonalInfo(NO);
//        return 0;
//    }
//}

//destructor属性表示在main函数执行之后做一些操作。
__attribute__((destructor(101))) static void afterMain1() {
    NSLog(@"afterMain1");
}
//在destructor中根据优先级越高，执行顺序越高。
__attribute__((destructor(102))) static void afterMain2() {
    NSLog(@"afterMain2");
}

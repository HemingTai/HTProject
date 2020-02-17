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
        /*********************************** autoreleasepool实现原理 *********************************
         * main()函数编译成C++代码后如下：
         * extern "C" __declspec(dllimport) void * objc_autoreleasePoolPush(void);
         * extern "C" __declspec(dllimport) void objc_autoreleasePoolPop(void *);
         * struct __AtAutoreleasePool {
         *   __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
         *   ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
         *   void * atautoreleasepoolobj;
         * };
         *
         * int main(int argc, char * argv[]) {
         *  { __AtAutoreleasePool __autoreleasepool;
         *        return UIApplicationMain(argc, argv, __null, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("AppDelegate"), sel_registerName("class"))));
         *  }
         * }
         * 可以看到自动释放池在初始化时会调用objc_autoreleasePoolPush()，析构时会调用objc_autoreleasePoolPop()
         * 在runtime源码中，可以看到自动释放池的实现细节如下：
         * class AutoreleasePoolPage {
             magic_t const magic; //用于对当前 AutoreleasePoolPage 完整性的校验
             id *next;
             pthread_t const thread; //保存了当前页所在的线程
             AutoreleasePoolPage * const parent;//前节点
             AutoreleasePoolPage *child;//后节点
             uint32_t const depth;
             uint32_t hiwat;
         * };
         * 每一个自动释放池都是由一系列的 AutoreleasePoolPage 组成的，并且每一个 AutoreleasePoolPage 的大小都是 4096 字节，AutoreleasePoolPage 是以双向链表的形式连接起来的：parent 和 child 就是用来构造双向链表的指针。
         * 在每个自动释放池初始化调用 objc_autoreleasePoolPush 的时候，都会把一个 POOL_SENTINEL(哨兵对象) push 到自动释放池的栈顶，并且返回这个 POOL_SENTINEL 哨兵对象；而当方法 objc_autoreleasePoolPop 调用时，就会向自动释放池中的对象发送 release 消息，直到第一个 POOL_SENTINEL，所以AutoreleasePool可以嵌套，pop的时候总会释放到上次push的位置为止，
         * 多层的pool就是多个哨兵对象多次push而已，就像剥洋葱一样，每次一层，互不影响
         */
        //延伸：autorelease对象何时释放？
        //在没有手动干预Autorelease Pool的情况下，Autorelease对象是在当前的runloop迭代结束时释放的，而它能够释放的原因是系统在每个runloop迭代中都加入了自动释放池Push和Pop
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

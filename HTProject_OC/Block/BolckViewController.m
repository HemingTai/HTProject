//
//  BolckViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/27.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "BolckViewController.h"

@interface BolckViewController ()

@property(nonatomic, copy) void (^HTBlock)(void);
@property(nonatomic, copy) void (^HTBlock1)(BolckViewController *vc);
@property(nonatomic, strong) void (^HTBlock2)(void);
@property(nonatomic, copy) NSString *name;

@end

@implementation BolckViewController

const int vision = 5;
int a = 1;
static int b = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testBlock1];
    [self testBlock2];
    [self testBlock3];
}

- (void)dealloc {
    NSLog(@"---dealloc---");
}

- (void)testBlock1 {
    /************ block 分类 *************/
    // 全局静态block: __NSGlobalBlock__
    void (^block)(void) = ^{
        NSLog(@"hello, world");
    };
    block();
    NSLog(@"block == %@", block);
    
    // 堆block: __NSMallocBlock__
    int a = 10;
    void (^block1)(void) = ^{
        NSLog(@"hello, block - %d", a);
    };
    block1();
    NSLog(@"block1 == %@", block1);
    
    // 栈block: __NSStackBlock__
    NSLog(@"block2 == %@", ^{
        NSLog(@"hello, block - %d", a);
    });
    
    //循环引用，用__weak并不完美，如果即刻返回到前一页面，下面代码则会打印出(null)，原因是当前实例对象已被提前释放
    self.name = @"Hem1ng";
    __weak typeof(self) weakSelf = self;
    self.HTBlock = ^{
        //1、为了解决提前释放问题，需在block里面再转换为强引用
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", strongSelf.name);
        });
    };
    self.HTBlock();
    
    //2、为了解决提前释放问题，可用__block解决，但是最后要置为nil
    __block BolckViewController *vc = self;
    self.HTBlock = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", vc.name);
            vc = nil;
        });
    };
    self.HTBlock();
    
    //3、为了解决提前释放问题，可用将block带参数，参数为当前vc
    self.HTBlock1 = ^(BolckViewController *vc){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", vc.name);
        });
    };
    self.HTBlock1(self);
    
    // __block 在底层中是指针传递，没有__block是值传递
    __block int b = 10;
    NSLog(@"before: %p", &b);
    void (^myBlock)(void) = ^{
        b++;
        NSLog(@"操作:%p", &b);
    };
    NSLog(@"after: %p", &b);
    myBlock();
}

- (void)testBlock2 {
    NSLog(@"captrue const variable in block");
    auto const int height = 170;
    void (^personInfoBlock)(void) = ^{
        NSLog(@"height is %d, vision is %d", height, vision);
    };
    personInfoBlock();
    
    //静态变量会被捕获并且被引用
    static int c = 3;
    int d = 4;
    void (^block)(void) = ^{
        a++;
        b++;
        c++;
        NSLog(@"a=%d,b=%d,c=%d,d=%d",a,b,c,d);
    };
    a++;
    b++;
    c++;
    d++;
    NSLog(@"a=%d,b=%d,c=%d,d=%d",a,b,c,d);
    block();
}

- (void)testBlock3 {
    /**block 使用 copy 是从 MRC 遗留下来的“传统”,在 MRC 中,方法内部的 block 是在栈区的,使用 copy 可以把它放到堆区.在 ARC 中写不写都行：对于 block 使用 copy 还是 strong 效果是一样的，但写上 copy 也无伤大雅，还能时刻提醒我们：编译器自动对 block 进行了 copy 操作。如果不写 copy ，该类的调用者有可能会忘记或者根本不知道“编译器会自动对 block 进行了 copy 操作”。
     */
    self.name = @"Hem1ngT4i";
    __weak typeof(self) weakSelf = self;
    self.HTBlock2 = ^{
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", strongSelf.name);
        });
    };
    self.HTBlock2();
}

/*************************************************** weak属性理解 ***************************************************
 weak实现原理：
 Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象的地址）数组。
 1、初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址。
 2、添加引用时：objc_initWeak函数会调用 objc_storeWeak() 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
 3、释放时，调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。
 追问的问题一：实现weak后，为什么对象释放后会自动为nil？
 runtime对注册的类会进行布局，对于weak对象会放入一个hash表中，用weak指向的对象内存地址作为key，当此对象的引用计数为0的时候会走dealloc，假如weak指向的对象内存地址是a，那么就会以a为键，在这个weak表中搜索，找到所有以a为键的weak对象，从而设置为nil。
 
 追问的问题二：当weak引用指向的对象被释放时，又是如何去处理weak指针的呢？
 1、调用objc_release
 2、因为对象的引用计数为0，所以执行dealloc
 3、在dealloc中，调用了_objc_rootDealloc函数
 4、在_objc_rootDealloc中，调用了object_dispose函数
 5、调用objc_destructInstance
 6、最后调用objc_clear_deallocating，详细过程如下：
 a. 从weak表中获取废弃对象的地址为键值的记录
 b. 将包含在记录中的所有附有 weak修饰符变量的地址，赋值为 nil
 c. 将weak表中该记录删除
 d. 从引用计数表中删除废弃对象的地址为键值的记录
 ******************************************************************************************************************/

@end

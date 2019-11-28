//
//  RuntimeViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/19.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import "RuntimeViewController.h"
#import "RuntimeViewController+Swizzling.h"
#import <objc/message.h>

/******************************************** 运行时-runtime *******************************************************
Objective-C是一门动态语言，它会将一些工作放在代码运行时才处理而并非编译时，也就是说，有很多类和成员变量在我们编译的时是不知道的，而在运行时，我们所编写的代码会转换成完整的确定的代码运行。
 
 SEL: 它是selector在 Objc 中的表示(Swift 中是 Selector 类)。selector是方法选择器，注意 Objc 在相同的类中不会有命名相同的两个方法。
      selector 对方法名进行包装，以便找到对应的方法实现。它的数据结构是：typedef struct objc_selector *SEL;
      我们可以看出它是个映射到方法的 C 字符串，你可以通过 Objc 编译器命令@selector() 或者 Runtime 系统的 sel_registerName 函数来获取一个 SEL 类型的方法选择器。
 注意：不同类中相同名字的方法所对应的 selector 是相同的，由于变量的类型不同，所以不会导致它们调用方法实现混乱。
 
 id: 它是一个参数类型，它是指向某个类的实例的指针。定义如下：
 typedef struct objc_object *id;
 struct objc_object { Class isa; };
 以上定义，看到 objc_object 结构体包含一个 isa 指针，根据 isa 指针就可以找到对象所属的类。
 注意：isa 指针在代码运行时并不总指向实例对象所属的类型，所以不能依靠它来确定类型，要想确定类型还是需要用对象的 -class 方法。
 PS:KVO 的实现机理就是将被观察对象的 isa 指针指向一个中间类而不是真实类型。
 ******************************************************************************************************************/

 /*********************************************** objc-runtime-old.h **********************************************
 Class
 
 typedef struct objc_class *Class;
 Class 其实是指向 objc_class 结构体的指针。objc_class 的数据结构如下：
 
 struct objc_class {
 Class isa;

 Class super_class
 const char *name
 long version
 long info
 long instance_size
 struct objc_ivar_list *ivars
 struct objc_method_list **methodLists
 struct objc_cache *cache
 struct objc_protocol_list *protocols
 
 };
 从 objc_class 可以看到，一个运行时类中关联了它的父类指针、类名、成员变量、方法、缓存以及附属的协议。
 其中 objc_ivar_list 和 objc_method_list 分别是成员变量列表和方法列表：
 
 // 成员变量列表
 struct objc_ivar_list {
 int ivar_count
 #ifdef __LP64__
 int space
 #endif
 //variable length structure
struct objc_ivar ivar_list[1]
}

// 方法列表
struct objc_method_list {
    struct objc_method_list *obsolete
    
    int method_count
#ifdef __LP64__
    int space
#endif
    //variable length structure
    struct objc_method method_list[1]
}
 
 Method
 
 Method 代表类中某个方法的类型
 
 typedef struct objc_method *Method;
 
 struct objc_method {
 SEL method_name
 char *method_types
 IMP method_imp
 }
 objc_method 存储了方法名，方法类型和方法实现：
 
 方法名类型为 SEL
 方法类型 method_types 是个 char 指针，存储方法的参数类型和返回值类型
 method_imp 指向了方法的实现，本质是一个函数指针
 
 Ivar
 
 Ivar 是表示成员变量的类型。
 
 typedef struct objc_ivar *Ivar;
 
 struct objc_ivar {
 char *ivar_name
 char *ivar_type
 int ivar_offset
 #ifdef __LP64__
 int space
 #endif
 }
 其中 ivar_offset 是基地址偏移字节
*******************************************************************************************************************/

 /*********************************************** objc-runtime-new.h **********************************************
  struct objc_class : objc_object {
  // Class ISA;
  Class superclass;
  cache_t cache;             // formerly cache pointer and vtable 方法缓存
 class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
 
 class_rw_t *data() {
 return bits.data();
 } ...}

  struct cache_t {
  struct bucket_t *_buckets; //散列表
  mask_t _mask; //散列表长度-1
  mask_t _occupied; //已经缓存的方法数量
  ...}
  
  struct bucket_t {
  private:
  cache_key_t _key;  //@selector(xxx)作为key
  MethodCacheIMP _imp;  //函数的执行地址
  ...}
  buckets 散列表，是一个数组，数组里面的每一个元素就是一个bucket_t，bucket_t里面存放两个值：_key SEL作为key、_imp 函数的内存地址
  _mask 散列表的长度
  _occupied已经缓存的方法数量
  
  struct class_rw_t {
  // Be warned that Symbolication knows the layout of this structure.
  uint32_t flags;
  uint32_t version;
  
  const class_ro_t *ro;
  
  method_array_t methods;
  property_array_t properties;
  protocol_array_t protocols;
  
  Class firstSubclass;
  Class nextSiblingClass;
  
  char *demangledName;
  ...}
  *****************************************************************************************************************/

/****************************************** objc-runtime-new.h ****************************************************
  OC方法调用流程：
  1.对象通过isa，找到函数所在的类对象
  2.这时候先做缓存查找，如果缓存的函数列表中没找到该方法
  3.就去类的class_rw中的methods中找，如果找到了，调用并缓存该方法
  4.如果类的class_rw中没找到该方法，通过superclass到父类中，走的逻辑还是先查缓存，缓存没有查类里面的方法。
  5.最终如果在父类中调用到了，会将方法缓存到当前类的方法缓存列表中
 ******************************************************************************************************************/

@implementation RuntimeTester

- (void)htMethod
{
    NSLog(@"消息转发成功！");
}

- (void)privateMethod
{
    NSLog(@"私有方法被调用！");
}

- (void)ht_testMethod {
    //模拟耗时操作
    for (NSInteger i=0; i<10; i++) {
        NSLog(@"ht_testMethod called");
    }
}

- (void)ht_testMethodText:(NSString *)text {
    NSLog(@"ht_testMethodText: %@", text);
}

@end



@implementation RuntimeBaseViewController

- (void)htOriginalInstanceMethod
{
    NSLog(@"htOriginalInstanceMethod");
}

@end



@interface RuntimeViewController ()
{
    @private NSMutableDictionary *_propertyDict;
}

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *gender;

@end

@implementation RuntimeViewController

@dynamic name;
@dynamic gender;

/**************************************************** OC的消息机制 **************************************************
 * 消息机制有三个阶段：消息发送 ——> 动态方法解析 ——> 消息转发
 * 消息发送：当前类查找（如果没有则到父类）  ——> 父类查找（先查找缓存cache，如果没有则查找方法列表method_list，如果还没有则沿着继承链继续查找）
 * 动态方法解析：如果都没有对应方法，并且现实了动态解析机制则进入动态方法解析，如果没有实现动态解析，则进入消息转发。（注：如果同时实现了动态解析和消息转发，那么动态解析先于消息转发，只有当动态决议无法决议selector的实现，才会尝试进行消息转发）
 * 动态方法解析流程：先判断曾经是否有动态方法解析，实现了再根据是对象方法还是实例方法调用resolveInstanceMethod:还是resolveClassMethod:，然后动态添加方法，然后标记为动态方法解析过再重新进入消息发送流程
 * 消息转发流程：先调用forwardingTargetForSelector，如果返回值不为nil，则直接进入消息发送，如果为nil，在调用methodSignatureForSelector:(SEL)aSelector获取方法签名，如果方法签名不为nil，则调用forwardInvocation:(NSInvocation *)anInvocation，如果签名为nil，则调用doesNotRecognizeSelector:
 ******************************************************************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取属性的个数
    unsigned int outCount = 0;
    class_copyPropertyList([RuntimeViewController class], &outCount);
    NSLog(@"当前类的属性个数：%d个", outCount);
    
    /********************************************** @dynamic ******************************************************
     * 用@dynamic告诉编译器不要自动生成setter,getter方法，会手动生成
     * 用@dynamic后，可以在存取方法中访问一个私有变量来赋值或取值。
     * 可用消息转发机制来实现@dynamic的setter和getter方法。
     **************************************************************************************************************/
//    _propertyDict = [[NSMutableDictionary alloc]init];
//    self.name = @"Hem1ng";
//    self.gender = @"male";
//    NSLog(@"%@-%@",self.name, self.gender);
    
    [self ht_runtimeAdvancedMethod2];
}

/************************************************* 调用私有方法 ******************************************************/
- (void)invokePrivateMethod {
    //由于消息机制，可通过objc_msgSend来调用私有方法，注意：需要导入头文件<objc/message.h>，在BuildSetting里设置Checking of objc_msgSend calls 为 NO
    RuntimeTester *tester = [[RuntimeTester alloc] init];
    objc_msgSend(tester, @selector(privateMethod));
    //这样也可以调用私有方法
    //    [tester performSelectorOnMainThread:@selector(privateMethod) withObject:nil waitUntilDone:NO];
}

/************************************************* 1.消息发送 ******************************************************/
- (void)sendMessage {
    [self htInstanceMethod];
    [RuntimeViewController htClassMethod];
    [self htMethod];
    
    [self htOriginalInstanceMethod];
    [self htSwizzledInstanceMethod];
    [RuntimeViewController htOriginalClassMethod];
    [RuntimeViewController htSwizzledClassMethod];
}

/************************************************ 2.动态解析 *******************************************************/
- (void)testInstanceMessageTransfer
{
    NSLog(@"实例方法动态解析成功！！");
}

// 动态解析 ——> 实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(htInstanceMethod))
    {
        Method method = class_getInstanceMethod(self, @selector(testInstanceMessageTransfer));
        class_addMethod([self class], sel, method_getImplementation(method), method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (void)testClassMessageTransfer
{
    NSLog(@"类方法动态解析成功！！");
}

// 动态解析 ——> 类方法
+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(htClassMethod))
    {
        /**************************************** objc_getClass和object_getClass区别 *******************************
         * 1.Class objc_getClass(const chat *aClassName)
         *   1> 传入字符串类名
         *   2> 返回对应的类对象
         *
         * 2.Class object_getClass(id obj)
         *   1> 传入的obj可能是instance对象、class对象、meta-class对象
         *   2> 返回值:
         *      a:如果是instance对象，返回class对象
         *      b:如果是class对象，返回meta-class对象
         *      c:如果是meta-class对象，返回NSObject（根类）的meta-class对象
         *
         * 3.-(class)class、+(class)class
         *   1> 返回的就是类对象
         **********************************************************************************************************/
        Method method = class_getClassMethod(self, @selector(testClassMessageTransfer));
        class_addMethod(object_getClass(self), sel, method_getImplementation(method), method_getTypeEncoding(method));
        return YES;
    }
    return [super resolveClassMethod:sel];
}

/*************************************************** 3.消息转发 ****************************************************/
// 第一种方式：指定新的接收者，以实现方法调用
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(htMethod))
    {
        //指定新接收者
        return [[RuntimeTester alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 第二种方式：先获取方法签名，再指定新接收者
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    //object-C方法的本质其实就是一个至少带有两个参数（self,_cmd）的普通C函数，如(void)setName:(NSString *){}该函数从外部调用看，它只包含了一个NSString类型参数
    //在class_addMethod的4个参数中唯一让笔者一开始不太明白的是第四个参数,types,查阅资料后得知其是一个定义该函数返回值类型和参数类型的字符串
    //"v@:@"按顺序分别表示：
    //v：v表示返回值为void
    //@：参数id(self)
    //:：SEL(_cmd)对象
    //@：id(str)
    //一句话来说，types表明了该函数从左到右返回值及参数的类型，@表示object对象，:表示selector对象
    
//    NSString *sel = NSStringFromSelector(aSelector);
//    if ([sel rangeOfString:@"set"].location != NSNotFound)
//    {
//        //v@:@ == void xxx (self, _cmd, NSString *)
//        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//    }
//    else
//    {
//        //@@: == (NSString *) xxx (self, _cmd)
//        return [NSMethodSignature signatureWithObjCTypes:"@@:"];
//    }
    
    if (aSelector == @selector(htMethod))
    {
        // v@: == void xxx (self, _cmd)
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 方法调用
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//    NSString *key = NSStringFromSelector([anInvocation selector]);
//    if ([key rangeOfString:@"set"].location != NSNotFound)
//    {
//        key = [key substringWithRange:NSMakeRange(3, [key length]-4)].lowercaseString;
//        NSString *obj;
//        //NSInvocation 其实封装了一个方法调用，包括：方法名 --> anInvocation.selector、方法调用 --> anInvocation.target、方法参数 --> anInvocation getArgument: atIndex:
//        [anInvocation getArgument:&obj atIndex:2];
//        [_propertyDict setObject:obj forKey:key];
//    }
//    else
//    {
//        NSString *obj = [_propertyDict objectForKey:key];
//        [anInvocation setReturnValue:&obj];
//    }
    
    // 设置新的接收者
    [anInvocation invokeWithTarget:[[RuntimeTester alloc] init]];
}



//- (void)htOriginalInstanceMethod
//{
//    NSLog(@"htOriginalInstanceMethod");
//}

+ (void)htOriginalClassMethod
{
    NSLog(@"htOriginalClassMethod");
}

- (void)htSwizzledInstanceMethod
{
    [self htSwizzledInstanceMethod];
    NSLog(@"htSwizzledInstanceMethod--Add");
}

+ (void)htSwizzledClassMethod
{
    [self htSwizzledClassMethod];
    NSLog(@"htSwizzledClassMethod--Add");
}

/************************************************ runtime进阶用法 ********************************************************/
//! 如果遇到大量的方法执行，可以通过Runtime获取到IMP，直接调用IMP实现优化
- (void)ht_runtimeAdvancedMethod1 {
    RuntimeTester *tester = [[RuntimeTester alloc] init];
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:0];
    for(NSInteger i=0; i<1000; i++) {
        [tester ht_testMethod];
    }
    NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"耗时1：%f",[date2 timeIntervalSinceDate:date1]);
    
    
    void (*function) (id , SEL ) = (void(*)(id, SEL))class_getMethodImplementation([RuntimeTester class], @selector(ht_testMethod));
    NSDate *date3 = [NSDate dateWithTimeIntervalSinceNow:0];
    for(NSInteger i=0; i<1000; i++) {
        function(tester, @selector(ht_testMethod));
    }
    NSDate *date4 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"耗时2：%f",[date4 timeIntervalSinceDate:date3]);
}

//! 通过Runtime的API，将原来的方法回调改为block的回调
- (void)ht_runtimeAdvancedMethod2 {
    IMP function = imp_implementationWithBlock(^(id self,  NSString *text) {
        NSLog(@"implementationWithBlock: %@", text);
    });
    const char *types = sel_getName(@selector(ht_testMethodText:));
    class_replaceMethod([RuntimeTester class], @selector(ht_testMethodText:), function, types);
    RuntimeTester *tester = [[RuntimeTester alloc] init];
    [tester ht_testMethodText:@"Hem1ngT4i"];
}




@end

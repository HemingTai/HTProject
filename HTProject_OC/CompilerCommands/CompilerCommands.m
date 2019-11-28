//
//  CompilerCommands.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "CompilerCommands.h"

static void releaseBefore(NSObject **obj) {
    NSLog(@"--- %@ was released ---", *obj);
}
static void releaseBefore2(NSObject **obj) {
    NSLog(@"--- %@ was released2 ---", *obj);
}
//objc_boxable可以使用@(...)包装成NSValue
typedef struct __attribute__((objc_boxable)) {
    CGFloat x, y, w, h;
}HTRect;


@implementation CompilerCommands

- (instancetype)initWithCommands:(NSString *)cmd name:(NSString *)name {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)mainFunction {
    NSLog(@"The function in CompilerCommands is called");
}

@end



@implementation HTCompilerCommands

- (instancetype)initWithCommands:(NSString *)cmd {
    return [super initWithCommands:cmd name:nil];;
}

- (instancetype)initWithName:(NSString *)name {
    return [self initWithCommands:@"cmd"];
}

- (void)mainFunction {
    [super mainFunction];
    NSLog(@"The function in HTCompilerCommands is called too");
}

__attribute__((overloadable)) void testFunction(NSString *name) {
    NSLog(@"my name is %@", name);
}
__attribute__((overloadable)) void testFunction(NSInteger age) {
    NSLog(@"my age is %ld", age);
}
__attribute__((overloadable)) void testFunction(NSNumber *score) {
    NSLog(@"my score is %@", score);
}

- (void)ht_test {
    testFunction(@"Hem1ngT4i");
    testFunction(20);
    testFunction(@90);
}

@end



@implementation TestCompilerCommands

- (void)dealloc {
    NSLog(@"--- %@ dealloc ---", NSStringFromClass([TestCompilerCommands class]));
}

@end



@implementation HTCompilerCommandsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HTCompilerCommands *cmd = [HTCompilerCommands new];
    [cmd mainFunction];
    [cmd ht_test];
    
    NSLog(@"---%@---", NSStringFromClass([TestCompilerCommands class]));
    //通过cleanup属性，可以指定给一个变量，当变量释放之前执行一个函数。指定的函数执行的时间，是在dealloc之前的。
    //在指定的函数中，可以传入一个形参，参数就是cleanup修饰的变量，形参是一个地址。
    //如果遇到同一个代码块中，同时出现多个cleanup属性时，在代码块作用域结束时，会以添加的顺序进行调用。
    TestCompilerCommands *tcmd __attribute__((unused)) __attribute__((cleanup(releaseBefore))) = [TestCompilerCommands new];
    //unused属性消除未使用警告
    NSObject *obj __attribute__((unused)) = [NSObject new];
    //#pragma unused()也可以消除未使用的警告，但是要注意，只针对变量且必须写在报警告的代码下方
    NSObject *obj2;
    #pragma unused(obj2)
    
    NSInteger a = 10, b = 0;
//    #error 注意校验b的值是否为0
    NSInteger c = a / b;
    #pragma unused(c)
    
    CGRect rect1 = {1,2,3,4};
    NSValue *value1 = @(rect1);
    HTRect rect2 = {5,6,7,8};
    NSValue *value2 = @(rect2);
    NSLog(@"%@,%@",value1, value2);
}

@end

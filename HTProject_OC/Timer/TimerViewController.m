//
//  TimerViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/5/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "TimerViewController.h"
#import "HTProxy.h"

@interface TimerViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HTProxy *proxy;

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    _proxy = [HTProxy alloc];
    _proxy.target = self;
    
    [self testTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
}

- (void)dealloc {
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
    NSLog(@"---vc dealloc---");
}

- (void)testTimer {
    /************************ 定时器只执行一次，即repeats为NO ************************/
    //1. 当前vc不持有timer，在返回前一页时不会立即释放当前vc，待定时器执行完timerAction方法后才会释放当前vc
//    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    //在block里面不需要使用weakSelf，因为类方法不会持有当前对象
//    NSTimer *timer = [NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self timerAction];
//    }];
    //需要将timer添加到runloop
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //2.当前vc持有timer，在返回前一页时，如果调用[self.timer invalidate]会立即释放当前vc，否则不会立即释放当前vc，等待定时器执行完timerAction方法后才会释放当前vc
//    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//    在block里面不需要使用weakSelf，因为类方法不会持有当前对象
//    self.timer = [NSTimer timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self timerAction];
//    }];
    //需要将self.timer添加到runloop
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //3.scheduledTimer是默认添加到runloop的NSDefaultRunLoopMode，不需要手动添加，结论同1
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    //在block里面不需要使用weakSelf，因为类方法不会持有当前对象
//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self timerAction];
//    }];
    
    //4.scheduledTimer是默认添加到runloop的NSDefaultRunLoopMode，不需要手动添加，结论同2
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    //在block里面不需要使用weakSelf，因为类方法不会持有当前对象
//    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//        [self timerAction];
//    }];
    
    
    
    //下面代码如果target的值为self，则会导致内存泄漏，通过proxy，指定弱引用对象，打破循环引用
//    self.timer = [NSTimer timerWithTimeInterval:1 target:_proxy selector:@selector(timerAction) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //以下代码只会输出come 而不会输出timer action called，因为thread对应的runloop已经被释放，所以要保证输出timer action called，必须要让对应的runloop保活，调用runloop的run方法
//    NSThread *thread = [[NSThread alloc] initWithBlock:^{
//        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        NSLog(@"come in");
////        [[NSRunLoop currentRunLoop] run];
//    }];
//    [thread start];
    
    //下面代码如果在返回时没有对timer进行销毁，会导致内存泄漏，但是使用了NSTimer+Swizzling后，即使不销毁也不会内存泄漏
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    NSLog(@"timer action called");
}

@end

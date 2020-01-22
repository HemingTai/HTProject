//
//  OCObjectViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/4/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "OCObjectViewController.h"

@implementation Person

@end



@interface OCObjectViewController ()<UIGestureRecognizerDelegate>

@end

@implementation OCObjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /************************************ OC对象的本质 ************************************
     * 借助汇编指令和LLDB高级调试方法进行探索：
     * b/bl是一条汇编指令，在真机上是b/bl，在模拟器上是callq或者jump，表示要调用方法
     * register是寄存器，x0-x7是存储参数的
     * objc_msgSend(id, SEL, ...) x0存放self，x1存放SEL
     * 查看调用的哪个方法可以在console执行：register read x1
     * 返回值也是放在x0，register read x0将打印返回对象的地址，再进行po
     * 至此说明alloc才是创建对象实例的方法
     * init方法什么都没做，直接返回了，所以init是工厂模式，让开发者重写实现自己的功能
     */
    Person *p = [Person alloc];
    p.age = 10;
    
    Person *p1 = [p init];
    Person *p2 = [p init];
    //因为init方法直接返回对象，所以p1和p2地址相同
    NSLog(@"%p---%p", p1, p2);
}

- (void)myTestFunction {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColor.orangeColor;
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(action3)];
    tap.delegate = self;
    [btn addGestureRecognizer:tap];
}

- (void)action1{
    NSLog(@"action1");
}

- (void)action2{
    NSLog(@"action2");
}

- (void)action3{
    NSLog(@"action3");
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:UIButton.class] ) {
        return NO;
    }
    return YES;
}

@end

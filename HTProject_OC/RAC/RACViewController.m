//
//  RACViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/28.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "RACViewController.h"
#import "RACView.h"
#import "HTModel.h"

@interface RACViewController ()

@property (weak, nonatomic) IBOutlet RACView *rView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic, copy) NSString *key;
@property(nonatomic, strong) RACSignal *signal;
@property(nonatomic, strong) RACSignal *flattenMapSignal;

@end

@implementation RACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.创建信号 创建信号对象，创建一个容量为1的可变数组
    RACSubject *subject = [RACSubject subject];
    [subject.rac_willDeallocSignal subscribeCompleted:^{ //2
        NSLog(@"subject1 dealloc");
    }];
    //2.订阅信号 创建订阅者对象，将block保存到订阅者中，再将订阅者保存到可变数组中
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    //3.发送信号 遍历可变数组中的订阅者，然后调用订阅者的block
    [subject sendNext:@1];
    
    
    
    /**************************************************** RAC 代替delegate *****************************************/
    // 需要设置信号和按钮点击事件，不是最完美的
    [self.rView.btnClickSignal subscribeNext:^(id  _Nullable x)
    {
        NSLog(@"%@", x);
    }];
    
    // 省去设置信号步骤，直接监听方法，这是最完美的
    [[self.rView rac_signalForSelector:@selector(send:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
    /**************************************************** RAC 代替KVO **********************************************/
    // RAC版的KVO，不完美
    [self.rView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"%@", value);
    }];
    
    // RAC信号代替KVO，完美
    [[self.rView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
    /*************************************************** RAC 代替事件监听 *******************************************/
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
    /*************************************************** RAC 代替通知 **********************************************/
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
    
    /*************************************************** RAC 监听TextField *****************************************/
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
    /*************************************************** RAC Timer ************************************************/
//    [[RACSignal interval:1 onScheduler:[RACScheduler  scheduler]]subscribeNext:^(NSDate * _Nullable x) {
//        NSLog(@"%@----%@", x, [NSThread currentThread]);
//    }];
    self.key = @"tai";
    [RACObserve(self, self.key) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    
    
    /*************************************************** RAC的循环引用 **********************************************/
    //1.self持有当前的signal，在block里面，又持有了当前的self，造成循环引用
    @weakify(self);
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber)
    {
        [subscriber sendNext:@"123"];
        @strongify(self);
        NSLog(@"key === %@", self.key);
        return nil;
    }];
    [self.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"self持有signal---%@", x);
    }];
    
    //2.以下代码看似正常，但是仔细看一下RACObserve的宏定义就会发现问题
    /* flattenMap操作接收的block里面出现了self，对self进行了持有，而flattenMap操作返回的信号又由self的属性flattenMapSignal进行了持有，这就造成了循环引用。
     #define _RACObserve(TARGET, KEYPATH) \
     ({ \
     __weak id target_ = (TARGET); \
     [target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
     })
     */
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        HTModel *model = [[HTModel alloc] init];
        model.title = @"456";
        [subscriber sendNext:model];
        [subscriber sendCompleted];
        return nil;
    }];
    self.flattenMapSignal = [signal flattenMap:^__kindof RACStream * _Nullable(HTModel * _Nullable model) {
        @strongify(self);
        return RACObserve(model, title);
    }];
    [self.flattenMapSignal subscribeNext:^(id x) { 
        NSLog(@"self持有flattenMapSignal---%@", x);
    }];
}

- (void)dealloc
{
    NSLog(@"我被销毁了！！！");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    self.rView.frame = CGRectMake(100, 100, 100, 50);
}

@end

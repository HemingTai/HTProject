//
//  MultiThreadViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/19.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import "MultiThreadViewController.h"

/**************************** 多线程-GCD ****************************
 *任务: 就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在GCD中是放在*
 *block中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。 两者的*
 *主要区别是: 是否等待队列的任务执行结束, 以及是否具备开启新线程的能力。      *
 *串行(Serial)：同一时间只有一个任务被执行，只开启一个线程                 *
 *并发(ConCurrent): 同一时间有多个任务被执行，可以开启多个线程。           *
 *注意: 并发队列的并发功能只有在异步（dispatch_async）函数下才有效         *
 *同步(Synchronous): 在当前线程中执行任务,不具备开启新的线程的能力         *
 *异步(Asynchronous): 在新的线程中执行任务，具备开启新的线程的能力         *
 *******************************************************************/

/*
  区别               并发队列                        串行队列                          主队列
同步(sync)    没有开启新线程，串行执行任务      没有开启新线程，串行执行任务      主线程调用：死锁卡住不执行, 其他线程调用：没有开启新线程，串行执行任务
异步(async)   有开启新线程，并发执行任务       有开启新线程(1条),串行执行任务    没有开启新线程，串行执行任务
 */

@interface People : NSObject

+ (instancetype)sharedPeople;

@end

@implementation People

static People *people;

+ (instancetype)sharedPeople
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"初始化...");
        people = [[People alloc] init];
    });
    return people;
}

@end

@interface MultiThreadViewController ()

/** 主队列 */
@property(nonatomic, assign) dispatch_queue_t main;
/** 全局队列 */
@property(nonatomic, assign) dispatch_queue_t global;
/** 信号 */
@property(nonatomic, strong) dispatch_semaphore_t semaphore;
/** 车票总数 */
@property(nonatomic, assign) NSInteger ticketCount;

@end

@implementation MultiThreadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self someTips];
    self.ticketCount = 50;
}

- (void)someTips
{
    // 获取主队列，*注意：主队列也是串行队列，所有主队列中的任务都会放到主线程执行
    self.main = dispatch_get_main_queue();
    //获取全局队列，*注意：全局队列也是并发队列第一个参数是队列优先级，第二个暂时没用默认传0
    /*  - DISPATCH_QUEUE_PRIORITY_HIGH
     *  - DISPATCH_QUEUE_PRIORITY_DEFAULT
     *  - DISPATCH_QUEUE_PRIORITY_LOW
     *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND*/
    self.global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self excuteTaskBySerial];
//    [self excuteTaskByConcurrent];
//    [self excuteTaskBySync];
//    [self excuteTaskByASync];
//    [self excuteTaskByBarrier];
//    [self excuteTaskByAfter];
//    [self excuteTaskByOnce];
//    [self excuteTaskByApply];
//    [self excuteTaskByGroup];
//    [self excuteTaskBySemaphore];
//    [self excuteTicketTaskBySemaphore];
//    [self excuteTaskByTimer];
//    [self excuteTaskByNSThread];
//    [self excuteTaskByNSOperation];
//    [self excuteTask];
    [self excuteConcurrentTask];
}

//! 定时器
- (void)excuteTaskByTimer
{
    __block NSInteger count = 60;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.global);
    // 参1:timer 参2:开始时间 参3:时间间隔 参4:传0 不需要
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        count--;
        NSLog(@"---%@", [NSThread currentThread]);
        if (count == 0)
        {
            dispatch_source_cancel(timer);
            NSLog(@"定时器结束！");
        }
        else
        {
            NSLog(@"倒计时：%ld秒", count);
        }
    });
    dispatch_resume(timer);
}

//! 基于semaphore的购票系统
- (void)excuteTicketTaskBySemaphore
{
    self.semaphore = dispatch_semaphore_create(1);
    //queue1代表窗口A, queue2代表窗口B
    dispatch_queue_t queue1 = dispatch_queue_create("HTProject_OC.Queue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("HTProject_OC.Queue2", DISPATCH_QUEUE_SERIAL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicket];
    });
    dispatch_async(queue2, ^{
        [weakSelf saleTicket];
    });
}

- (void)saleTicket
{
    while (1)
    {
        //dispatch_semaphore_wait会使信号量减1，此时信号量为0，后续线程再进来需要等待，相当于加锁
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (self.ticketCount > 0)
        {
            self.ticketCount--;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数：%ld, 窗口：%@", self.ticketCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:2];
        }
        else
        {
            NSLog(@"票已售完！");
            //dispatch_semaphore_signal会使信号量加1，此时信号量大于0，相当于解锁
            dispatch_semaphore_signal(self.semaphore);
            break;
        }
        //相当于解锁
        dispatch_semaphore_signal(self.semaphore);
    }
}

//! dispatch_semaphore是持有计数的信号,在Dispatch Semaphore中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
- (void)excuteTaskBySemaphore
{
    NSLog(@"semaphore----begin");
    //创建一个Semaphore并初始化信号的总量为0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int number = 0;
    dispatch_async(self.global, ^{
       [NSThread sleepForTimeInterval:2];
        NSLog(@"任务1,%@", [NSThread currentThread]);
        number = 100;
        //发送一个信号，让信号总量加1
        dispatch_semaphore_signal(semaphore);
    });
    //使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore----end, number = %d",number);
}

//! dispatch_group函数是异步执行多个耗时任务，当多个耗时任务都执行完毕后再回到指定线程执行任务。
- (void)excuteTaskByGroup
{
    NSLog(@"group----begin");
    dispatch_group_t group = dispatch_group_create();
    //先调用dispatch_group_async把任务放到队列中，然后将队列放入队列组中。
    dispatch_group_async(group, self.global, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务1, %ld, %@", i, [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, self.global, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务2, %ld, %@", i, [NSThread currentThread]);
        }
    });
    //dispatch_group_notify监听group中任务的完成状态，当所有的任务都执行完成后，回到指定线程执行任务。
    dispatch_group_notify(group, self.main, ^{
        NSLog(@"任务1和任务2都执行完毕!");
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务3, %ld, %@", i, [NSThread currentThread]);
        }
        NSLog(@"group----end");
    });
    
    /******************分割线以上代码和以下代码是等价的******************/
    /*
    //dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
    dispatch_group_enter(group);
    dispatch_async(self.global, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务4, %ld, %@", i, [NSThread currentThread]);
        }
        //dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(self.global, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务5, %ld, %@", i, [NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    //当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。
    //阻塞当前线程，等待指定的group中的任务全部执行完成后，才会往下继续执行。
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"group----end");*/
}

//! dispatch_apply函数按照指定的次数将指定的任务追加到指定的队列中，并等待全部队列执行结束。
- (void)excuteTaskByApply
{
    NSLog(@"apply----begin");
    dispatch_apply(5, self.global, ^(size_t index) {
        NSLog(@"%zd---%@", index, [NSThread currentThread]);
    });
    //因为是在并发队列中异步执行任务，所以各个任务的执行时间长短不定，最后结束顺序也不定。
    //但是apply----end一定在最后执行,这是因为dispatch_apply函数会等待全部任务执行完毕。
    NSLog(@"apply----end");
}

//! dispatch_once函数能保证某段代码在程序运行过程中只被执行1次，并且即使在多线程的环境下，dispatch_once也可以保证线程安全。
- (void)excuteTaskByOnce
{
    NSLog(@"PeopleA:%@", [People sharedPeople]);
    NSLog(@"PeopleB:%@", [People sharedPeople]);
    NSLog(@"PeopleC:%@", [People sharedPeople]);
    
    static int count = 0;
    static dispatch_once_t onceToken;
    //虽然执行了三次，但是只有一次输出
    dispatch_once(&onceToken, ^{
        NSLog(@"count=%d",count++);
    });
    dispatch_once(&onceToken, ^{
        NSLog(@"count=%d",count++);
    });
    dispatch_once(&onceToken, ^{
        NSLog(@"count=%d",count++);
    });
}

//! dispatch_after函数在指定时间之后执行某个任务。
- (void)excuteTaskByAfter
{
    NSLog(@"任务1执行中");
    [NSThread sleepForTimeInterval:2];
    NSLog(@"任务1执行结束");
    NSLog(@"任务2执行中");
    //dispatch_after函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中，严格来说，这个时间并不是绝对准确的
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"任务2执行结束");
    });
    NSLog(@"任务3执行中");
    [NSThread sleepForTimeInterval:2];
    NSLog(@"任务3执行结束");
}

/****** 有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。******/
//! 栅栏执行任务
- (void)excuteTaskByBarrier
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_CONCURRENT);
    [self printNumberByBarrierWithNumber:1 queue:concurrentQueue];
    [self printNumberByBarrierWithNumber:2 queue:concurrentQueue];
    /*dispatch_barrier_async函数会等待前边追加到并发队列中的任务全部执行完毕之后，再将指定的任务追加到该异步队列中。
     然后在dispatch_barrier_async函数追加的任务执行完毕之后，异步队列才恢复为一般动作，接着追加任务到该异步队列并开始执行。*/
    dispatch_barrier_async(concurrentQueue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务3, %ld, %@", i, [NSThread currentThread]);
        }
    });
    [self printNumberByBarrierWithNumber:4 queue:concurrentQueue];
    [self printNumberByBarrierWithNumber:5 queue:concurrentQueue];
    //注意：使用 dispatch_barrier_async ，该函数只能搭配自定义并行队列 dispatch_queue_t 使用。不能使用：dispatch_get_global_queue ，否则 dispatch_barrier_async 的作用会和 dispatch_async 的作用一模一样。
}

/****** 只要是串行队列，不管是同步执行任务还是异步执行任务都是按顺序执行的 ******/
//! 串行队列执行任务
- (void)excuteTaskBySerial
{
    //串行队列同步执行任务
    dispatch_queue_t serialQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_SERIAL);
    [self printNumberBySerialWithNumber:1 queue:serialQueue];
    
    sleep(2);
    
    //串行队列异步执行任务
    [self printNumberByASerialWithNumber:2 queue:serialQueue];
}

/****** 并发队列，同步执行任务相当于串行队列，还是按顺序执行；异步执行任务不一定按顺序执行 ******/
//! 并发队列执行任务
- (void)excuteTaskByConcurrent
{
    //并发队列同步执行任务
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_CONCURRENT);
    [self printNumberByConcurrentWithNumber:1 queue:concurrentQueue];
    
    sleep(1);
    
    //并发队列异步执行任务
    [self printNumberByAConcurrentWithNumber:2 queue:concurrentQueue];
}

/****** 同步执行任务 不管是串行队列还是并发队列都是按顺序执行 不会开启新线程 ******/
//! 同步执行任务
- (void)excuteTaskBySync
{
    //串行队列同步执行任务
    dispatch_queue_t serialQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_SERIAL);
    [self printNumberBySerialWithNumber:1 queue:serialQueue];
    
    sleep(1);
    
    //并发队列同步执行任务
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_CONCURRENT);
    [self printNumberByConcurrentWithNumber:2 queue:concurrentQueue];
}

/****** 异步执行任务 如果是串行队列则按顺序执行，如果是并发队列则不一定按顺序执行 会开启新线程 ******/
//! 异步执行任务
- (void)excuteTaskByASync
{
    //串行队列异步执行任务
    dispatch_queue_t serialQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_SERIAL);
    [self printNumberByASerialWithNumber:1 queue:serialQueue];
    
    sleep(1);
    
    //并发队列异步执行任务
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.HT.HTProject_OC", DISPATCH_QUEUE_CONCURRENT);
    [self printNumberByAConcurrentWithNumber:2 queue:concurrentQueue];
}

// 异步串行队列
- (void)printNumberByASerialWithNumber:(NSInteger)number queue:(dispatch_queue_t)queue
{
    dispatch_async(queue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务%ld, %ld, %@",number, i, [NSThread currentThread]);
        }
    });
}

// 同步串行队列
- (void)printNumberBySerialWithNumber:(NSInteger)number queue:(dispatch_queue_t)queue
{
    dispatch_sync(queue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务%ld, %ld, %@",number, i, [NSThread currentThread]);
        }
    });
}

// 异步并发队列
- (void)printNumberByAConcurrentWithNumber:(NSInteger)number queue:(dispatch_queue_t)queue
{
    dispatch_async(queue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务%ld, %ld, %@",number, i, [NSThread currentThread]);
        }
    });
}

// 同步并发队列
- (void)printNumberByConcurrentWithNumber:(NSInteger)number queue:(dispatch_queue_t)queue
{
    dispatch_sync(queue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务%ld, %ld, %@",number, i, [NSThread currentThread]);
        }
    });
}

- (void)printNumberByBarrierWithNumber:(NSInteger)number queue:(dispatch_queue_t)queue
{
    dispatch_async(queue, ^{
        for(NSInteger i=0;i<3;i++)
        {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务%ld, %ld, %@",number, i, [NSThread currentThread]);
        }
    });
}

/**************************************** NSThread *****************************************/

- (void)printNumber:(NSString *)param
{
    for (NSInteger i=0; i<20; i++)
    {
        NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
        [NSThread sleepForTimeInterval:2];
    }
}

//! 一个 NSThread 对象就代表一条线程
- (void)excuteTaskByNSThread
{
    //创建线程的三种方式
    //1.先创建再启动
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(printNumber:) object:@"1"];
    [thread1 start];
    //2.直接创建并启动
    [NSThread detachNewThreadSelector:@selector(printNumber:) toTarget:self withObject:@"2"];
    //3.直接创建并启动
    [self performSelectorInBackground:@selector(printNumber:) withObject:@"3"];
    [NSThread sleepForTimeInterval:2];
}

/**************************************** NSOperation *****************************************/

//NSOperation是个抽象类，并不具备封装操作的能力，必须使用它的子类NSInvocationOperation、NSBlockOperation，自定义子类继承NSOperation，实现内部相应的方法
- (void)excuteTaskByNSOperation
{
    //创建任务 NSOperation 对象，创建 NSOperationQueue 队列，将任务 NSOperation 对象 add 到 NSOperationQueue 队列中去
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(printNumber:) object:@"1"];
    //注意：默认情况下，调用了start方法后并不会开一条新的线程去执行，而是在当前线程同步执行操作，只有将 NSOperation 放到一个 NSOperationQueue 中，才会异步执行操作
//    [op start];
    //取消单个任务的操作
//    [op cancel];
    
    //在主线程执行
//    NSBlockOperation *bop = [NSBlockOperation blockOperationWithBlock:^{
//        for (NSInteger i=0; i<20; i++)
//        {
//            NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
//            [NSThread sleepForTimeInterval:2];
//        }
//    }];
    //添加额外的任务(在子线程执行)，封装数大于1才会异步执行
//    [bop addExecutionBlock:^{
//        for (NSInteger i=20; i<40; i++)
//        {
//            NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
//            [NSThread sleepForTimeInterval:1];
//        }
//    }];
//    [bop start];
    
    //创建一个其他队列(包括串行队列和并发队列) 放到这个队列中的NSOperation对象会自动放到子线程中执行
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建一个主队列，放到这个队列中的NSOperation对象会自动放到子线程中执行
//    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    //表示并发数量：即同时执行任务的最大数。
    //maxConcurrentOperationCount 默认情况下为-1，表示不进行限制，可进行并发执行。
    //maxConcurrentOperationCount 为1时，队列为串行队列。只能串行执行。
    //maxConcurrentOperationCount 大于1时，队列为并发队列。
//    queue.maxConcurrentOperationCount = 1;
    // YES代表暂停队列，NO代表恢复队列
//    queue.suspended = YES;
    //取消队列所有执行的任务
//    [queue cancelAllOperations];
    NSBlockOperation *bop1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i=0; i<10; i++)
        {
            NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    NSBlockOperation *bop2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i=10; i<20; i++)
        {
            NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    NSBlockOperation *bop3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i=20; i<30; i++)
        {
            NSLog(@"线程%@---%zd---%d",[NSThread currentThread], i, [NSThread isMainThread]);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    //添加依赖，线程2依赖于线程1，也就是说线程2在线程1执行完之后才会执行
    [bop2 addDependency:bop1];
    [bop3 addDependency:bop2];
    
    [queue addOperation:bop1];
    [queue addOperation:bop2];
    [queue addOperation:bop3];
}

- (void)excuteTask {
    //经典面试题：问输出结果是什么
    __block int a = 0;
    while (a<5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"--%d",a);
            a++;
        });
    }
    NSLog(@"a == %d", a);
    
    //延伸
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"a === %d", a);//输出a的最大值
    });
}

//GCD通过信号量可以控制最大并发数
- (void)excuteConcurrentTask {
    dispatch_queue_t workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t serialQueue = dispatch_queue_create("sssssssss",DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);

    for (NSInteger i = 0; i < 10; i++) {
      dispatch_async(serialQueue, ^{
          dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
          dispatch_async(workConcurrentQueue, ^{
              NSLog(@"thread-info:%@开始执行任务%d",[NSThread currentThread],(int)i);
              sleep(1);
              NSLog(@"thread-info:%@结束执行任务%d",[NSThread currentThread],(int)i);
              dispatch_semaphore_signal(semaphore);});
      });
    }
    NSLog(@"主线程...!");
}

@end

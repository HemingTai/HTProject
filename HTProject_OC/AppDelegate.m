//
//  AppDelegate.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "AppDelegate.h"
#import "HTCrashReporter.h"
#import "HTTestModel.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/************************ App的生命周期 ************************
 * App的生命周期分别调用哪些方法（iOS 13以后）：
 * App从启动开始到进入首页分别会调用以下方法：didFinishLaunchingWithOptions -> configurationForConnectingSceneSession ->
   willConnectToSession -> sceneWillEnterForeground -> viewDidLoad -> viewWillAppear -> sceneDidBecomeActive -> viewDidAppear
 * 从前台进入后台分别会调用以下方法：sceneWillResignActive -> sceneDidEnterBackground
 * 从后台进入前台分别会调用以下方法：sceneWillEnterForeground -> sceneDidBecomeActive
 * 从前台进入多任务状态会调用以下方法：sceneWillResignActive
 * 从多任务状态杀死App分别会调用以下方法：sceneDidDisconnect -> didDiscardSceneSessions -> viewWillDisappear -> viewDidDisappear
*************************************************************/

/************************ 事件传递和响应机制 ************************
 * 事件产生：
 * 1> 发生触摸事件后，系统会将该事件加入到一个由UIApplication管理的事件队列中，为什么是队列而不是栈？
      因为队列的特点是先进先出，先产生的事件先处理才符合常理
 * 2> UIApplication会从事件队列中取出最前面的事件，并将事件分发下去以便处理，通常先发送事件给应用程序的主窗口（keyWindow）
 * 3> 主窗口（keyWindow）会在视图层次结构中找到一个最合适的视图来处理触摸事件，寻找最合适的视图的关键就是hitTest:withEvent:方法
 *
 * 事件传递：
 * 事件的传递是自上到下的顺序，即UIApplication->KeyWindow->处理事件最合适的view。
 * 1> 首先判断主窗口（keyWindow）自己是否能接受触摸事件
 * 2> 判断触摸点是否在自己身上
 * 3> 子控件数组中从后往前遍历子控件，重复前面的两个步骤
 * 4> 通过前3步寻找到了fitView，那么会把这个事件交给这个fitView，再遍历这个fitView的子控件，直至没有更合适的view为止
 * 5> 如果没有符合条件的子控件，那么就认为自己是最合适处理这个事件的view
 * 大致流程如下：
 * - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
     // 1.判断窗口能否接收事件
     if (self.userInteractionEnabled == NO || self.hidden == YES ||  self.alpha <= 0.01) return nil;
     // 2.判断点在不在窗口上
     // 不在窗口上
     if ([self pointInside:point withEvent:event] == NO) return nil;
     // 3.从后往前遍历子控件数组
     int count = (int)self.subviews.count;
     for (int i = count - 1; i >= 0; i--)     {
         // 获取子控件
         UIView *childView = self.subviews[i];
         // 坐标系的转换，把窗口上的点转换为子控件上的点
         // 把自己控件上的点转换成子控件上的点
         CGPoint childP = [self convertPoint:point toView:childView];
         UIView *fitView = [childView hitTest:childP withEvent:event];
         if (fitView) {
             // 如果能找到最合适的view
             return fitView;
         }
     }
     // 4.没有找到更合适的view，也就是没有比自己更合适的view
     return self;
 }
 // 作用：判断传过来的点在不在方法调用者的坐标系上
 - (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
 //  return NO;
 }
 *
 * 事件响应：
 * 首先看fitView能否处理这个事件，如果不能则会将事件传递给其上级视图（即fitView的superView）
 * 如果上级视图仍然无法处理则会继续往上传递,一直传递到视图控制器viewController
 * 再判断视图控制器的根视图view是否能处理此事件，如果不能则接着判断该视图控制器能否处理此事件，如果还是不能则继续向上传 递；（对于第二个图视图控制器本身还在另一个视图控制器中，则继续交给父视图控制器的根视图，如果根视图不能处理则交给父视图控制器处理）；一直到window，如果window还是不能处理此事件则继续交给application处理，如果最后application还是不能处理此事件则将其丢弃。
 *
 ************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //为了方便调试过程中及时发现问题，建议只在线上版本使用这个功能，在测试阶段不要开启，以便及时发现并处理问题。
//    [HTCrashReporter ht_interceptCrashWithType:HTCrashTypeAll];
//
//    NSString *nilString = nil;
//    NSArray *array1 = @[@"1",nilString,@"2"];
//    NSLog(@"%@",array1);
//    NSMutableArray *array = [NSMutableArray new];
//    [array setObject:nilString atIndexedSubscript:0];
//    [array setObject:@"1" atIndexedSubscript:1];
//    [array removeObjectAtIndex:2];
//    [array insertObject:nilString atIndex:3];
//
//    UILabel *label0 = [UILabel new];
//    [label0 setValue:self forKey:@"sds"];
//
//    UILabel *label1 = [UILabel new];
//    [label1 setValue:self forKeyPath:@"1"];
//
//    UILabel *label2 = [UILabel new];
//    [label2 setValuesForKeysWithDictionary:@{@"name" : @"asds"}];
//
//    NSMutableArray *marr = label0;
//    [marr addObject:@"sad"];
//
//    NSString *tar = @"asdsadasdas";
//    NSLog(@"--%hu",[tar characterAtIndex:20]);
//    NSLog(@"--%@",[tar substringFromIndex:100]);
//    NSLog(@"--%@",[tar substringToIndex:100]);
//    NSLog(@"--%@",[tar substringWithRange:NSMakeRange(3, 40)]);
//    NSLog(@"--%@", [tar stringByReplacingCharactersInRange:NSMakeRange(2, 20) withString:@"asd"]);
//    NSLog(@"--%@", [tar stringByReplacingOccurrencesOfString:nilString withString:nilString]);
//    NSLog(@"--%@", [tar stringByReplacingOccurrencesOfString:@"a" withString:@"d" options:NSCaseInsensitiveSearch range:NSMakeRange(8, 20)]);
//    NSMutableString *mstr = [NSMutableString stringWithFormat:@"asdsadfasf"];
//    [mstr replaceCharactersInRange:NSMakeRange(0, 34) withString:@"asd"];
//    [mstr insertString:@"asdsa" atIndex:20];
//    [mstr deleteCharactersInRange:NSMakeRange(0, 30)];
//
//    NSDictionary *dic = @{@"title": nilString};
//    NSMutableDictionary *mdic = dic.mutableCopy;
//    mdic[nilString] = @"asd";
//    [mdic removeObjectForKey:nilString];
//
//    [mdic setObject:nilString forKey:@"key"];
//
//    HTTestModel *model = [HTTestModel modelWithDict:@{@"name":@"Hem1ng", @"age":@18, @"male":@YES}];
//    NSLog(@"%@", model);
    
    [IQKeyboardManager sharedManager].enable = YES;
    NSLog(@"--didFinishLaunchingWithOptions");
    return YES;
    
    /************************ App的启动优化 ************************
     * App启动有两个类型：冷启动和热启动：
     *      冷启动：App尚未运行，启动App，加载并构建整个应用，完成初始化的工作，这时候称为冷启动。
     *      热启动：如果你刚刚启动过App，这时候App的启动所需要的数据仍然在缓存中行(常见的场景是用户按了 Home 按钮)，再次启动的时候称为热启动。
     * 注意：启动时间在小于400ms是最佳的，因为从点击图标到显示Launch Screen，到Launch Screen消失这段时间是400ms。启动时间不可以大于20s，否则会被系统杀掉。
     *
     * 启动时间：
     * 一般而言，把iOS冷启动的过程定义为：从用户点击App图标开始到appDelegate的didFinishLaunchingWithOptions方法执行完成为止。
       这个过程主要分为三个阶段：
          T(App 总启动时间) = T1(main()之前的加载时间) + T2(main()之后的加载时间) + T3(首页渲染完成的时间)。
          T1：main()函数之前，即操作系统加载App可执行文件到内存，然后执行一系列的加载&链接等工作，最后执行至App的main()函数。
          T2：main()函数之后，即从main()开始，到appDelegate的didFinishLaunchingWithOptions方法执行完毕。
          T3：didFinishLaunchingWithOptions之后App还需要做一些初始化工作，然后经历定位、首页请求、首页渲染完成。
     *
     * Mach-O：Mach-O 是针对不同运行时可执行文件的文件类型。
     * 哪些名词指的是Mach-o：
            Executable 可执行文件
            Dylib 动态库
            Bundle 无法被连接的动态库，只能通过dlopen()加载
     * 注意：Image 指的是Executable，Dylib或者Bundle的一种，Framework 是动态库和对应的头文件和资源文件的集合
     * Main函数之前优化:
     *  dylib：
            启动的第一步是加载动态库，加载系统的动态库是很快的，因为可以缓存，而加载内嵌的动态库速度较慢。
            所以，提高这一步的效率的关键是：减少动态库的数量，合并动态库，比如公司内部由私有Pod建立了如下动态库：XXTableView, XXHUD, XXLabel，建议合并成一个XXUIKit来提高加载速度
            确认Framework应当设为optional还是required，如果该Framework在当前App支持的所有iOS系统版本都存在，那么就设为required，否则就设为optional，因为optional会有些额外的检查
     *
     *  Rebase & Bind & Objective C Runtime：
            Rebase和Bind都是为了解决指针引用的问题。对于ObjectiveC开发来说，主要的时间消耗在Class/Method的符号加载上，所以常见的优化方案是：减少__DATA段中的指针数量，合并Category和功能类似的类。
            比如：UIView+Frame,UIView+AutoLayout…合并为一个，删除无用的方法，多用Swift中的Struct，因为Swfit Struct是静态分发的
     *
     *  Initializers：
            通常，我们会在+load方法中进行method-swizzling，这也是Nshipster推荐的方式。
            将不必须在+load方法中做的事情延迟到+initialize中，用initialize替代load 减少atribute((constructor))的使用，而是在第一次访问的时候才用dispatch_once等方式初始化
            不要创建线程，使用Swfit重写代码，减少C++静态对象
     *
     * Main函数之后优化启动时间：
     *  优化的核心思想：能延迟初始化的尽量延迟初始化，不能延迟初始化的尽量放到后台初始化，另外按需加载
     *  尽量减少使用xib，直接使用代码加载首页视图
     *  除了用户看到的第一屏内容所依赖的初始化方法（UI和基础服务），尽量以异步，甚至是后台线程的方式来做初始化。
        比如：延迟初始化那些不必要的UIViewController
     *
     * 数据缓存，首页的数据尽可能缓存，以提高下次加载速度。
     */
    
    /******************** git相关问题 ********************
     * 1、git rebase 和 git merge 区别？
     *   git merge：将两个分支，合并提交为一个新提交，并且新提交有2个parent。
     *   git rebase：会取消分支中的每个提交，并把他们临时存放，然后把当前分支更新到最新的origin分支，最后再把所有提交应用到分支上。
     */
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    NSLog(@"--configurationForConnectingSceneSession");
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    NSLog(@"--didDiscardSceneSessions");
}


@end

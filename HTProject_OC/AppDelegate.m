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

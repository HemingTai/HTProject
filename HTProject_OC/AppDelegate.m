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
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

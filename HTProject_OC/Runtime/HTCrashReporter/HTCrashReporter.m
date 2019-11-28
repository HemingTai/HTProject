//
//  HTCrashReporter.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/24.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTCrashReporter.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
#import "NSArray+Swizzling.h"
#import "NSString+Swizzling.h"
#import "NSDictionary+Swizzling.h"
#import "NSTimer+Swizzling.h"

@implementation HTCrashReporter

+ (void)ht_interceptCrashWithType:(HTCrashType)type {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (type & HTCrashTypeStringRangeOrIndexOutOfBounds) {
            [NSString ht_interceptStringAllCrash];
        }
        if (type & HTCrashTypeMutableArrayOwned) {
            [NSArray ht_interceptMutableArrayCrash];
        }
        if (type & HTCrashTypeArrayIndexBeyondBounds) {
            [NSArray ht_interceptArrayCrashCausedByIndexBeyondBounds];
        }
        if (type & HTCrashTypeArrayAttemptToInsertNilObject) {
            [NSArray ht_interceptArrayCrashCausedByAttemptToInsertNilObject];
        }
        if (type & HTCrashTypeObjectKVC) {
            [NSObject ht_interceptObjectCrashCausedByKVC];
        }
        if (type & HTCrashTypeObjectUnrecognizedSelectorSentToInstance) {
            [NSObject ht_interceptObjectCrashCausedByUnrecognizedSelectorSentToInstance];
        }
        if (type & HTCrashTypeTimerIsNotCleaned) {
            [NSTimer ht_interceptTimerAllCrash];
        }
        if (type & HTCrashTypeDictionaryAll) {
            [NSDictionary ht_interceptDictionaryAllCrash];
        }
    });
}

/**
 交换实例方法
 
 @param cls 类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)ht_swizzleInstanceMethodForClass:(Class)cls
                        originalSelector:(SEL)originalSel
                       swizzlingSelector:(SEL)swizzlingSel {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzlingMethod = class_getInstanceMethod(cls, swizzlingSel);
    
    BOOL addedMethod = class_addMethod(cls,
                                       originalSel,
                                       method_getImplementation(swizzlingMethod),
                                       method_getTypeEncoding(swizzlingMethod));
    if (addedMethod) {
        class_replaceMethod(cls,
                            swizzlingSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}

/**
 交换类方法

 @param cls 元类对象
 @param originalSel 原始方法
 @param swizzlingSel 替换方法
 */
+ (void)ht_swizzleClassMethodForClass:(Class)cls
                     originalSelector:(SEL)originalSel
                    swizzlingSelector:(SEL)swizzlingSel {
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method swizzlingMethod = class_getClassMethod(cls, swizzlingSel);
    
    Class metaCls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);
    BOOL addResult = class_addMethod(metaCls,
                                     originalSel,
                                     method_getImplementation(swizzlingMethod),
                                     method_getTypeEncoding(swizzlingMethod));
    if (addResult) {
        class_replaceMethod(metaCls,
                            swizzlingSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}

/**
 捕获异常和异常类型
 
 @param exception 异常
 @param type 异常类型
 */
+ (void)ht_catchException:(NSException *)exception
            withCrashType:(HTCrashType)type {
    [self ht_handleCatchedException:exception withAction:^(NSString * _Nonnull message){
        NSLog(@"%@", message);
    }];
}

/**
 处理捕获的异常
 
 @param exception 异常
 @param action 处理方式，如上传，在控制台输出等
 */
+ (void)ht_handleCatchedException:(NSException *)exception
                       withAction:(void(^)(NSString *))action {
    //获取堆栈数据
    NSArray *callStackSymbolsArray = [NSThread callStackSymbols];
    //获取崩溃位置
    //    NSString *mainCallStackSymbolMsg = [callStackSymbolsArray componentsJoinedByString:@"\n"];
    NSString *mainCallStackSymbolMsg = [self ht_getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArray];
    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = @"崩溃信息定位失败,请您查看函数调用栈来排查错误原因";
    }
    NSString *exceptionName = [NSString stringWithFormat:@"App crashed due to uncaught exception: %@",exception.name];
    NSString *exceptionReason = [NSString stringWithFormat:@"reason: %@ ",exception.reason];
    exceptionReason = [exceptionReason stringByReplacingOccurrencesOfString:@"ht_" withString:@""];
    NSString *logExceptionMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\nFirst throw call stack: %@\n",HTCrashReporterTitleSeparator, exceptionName, exceptionReason, mainCallStackSymbolMsg];
    logExceptionMessage = [NSString stringWithFormat:@"%@\n%@\n ",logExceptionMessage,HTCrashReporterBottomSeparator];
    if (action) {
        action(logExceptionMessage);
    }
}

/**
 获取堆栈主要崩溃信息
 
 @param callStackSymbols 堆栈主要崩溃信息
 @return 堆栈主要崩溃信息，格式为 +[类名 方法名]  或者 -[类名 方法名]
 */
+ (NSString *)ht_getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    __block NSString *mainCallStackSymbolMsg = nil;
    //正则格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *pattern = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExpession = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //直接从下标为2的位置开始，因为下标为0和1的位置分别是ht_handleException和ht_forwardInvocation
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExpession enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                //获取类名
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                //过滤分类方法
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}

@end

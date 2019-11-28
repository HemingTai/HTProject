//
//  NSTimer+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSTimer+Swizzling.h"
#import "HTCrashReporter.h"

@interface HTTimerObject : NSObject

@property(nonatomic,   weak) id target;

@property(nonatomic, assign) id userInfo;

@property(nonatomic, assign) SEL selector;

@property(nonatomic,   weak) NSTimer* timer;

@property(nonatomic,   copy) NSString* targetClassName;

@property(nonatomic,   copy) NSString* targetSelectorName;

@property(nonatomic, assign) NSTimeInterval timeInterval;

@end

@implementation HTTimerObject

- (void)fireTimer{
    if (!self.target) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    if ([self.target respondsToSelector:self.selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self.timer];
        #pragma clang diagnostic pop
    }
}

- (void)dealloc {
    NSLog(@"------ httimer dealloc ------");
}

@end



@implementation NSTimer (Swizzling)

+ (void)ht_interceptTimerAllCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTCrashReporter ht_swizzleClassMethodForClass:[NSTimer class]
                                originalSelector:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)
                            swizzlingSelector:@selector(ht_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
        
        [HTCrashReporter ht_swizzleClassMethodForClass:[NSTimer class]
                                      originalSelector:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:)
                                     swizzlingSelector:@selector(ht_timerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)ht_timerWithTimeInterval:(NSTimeInterval)timeInterval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
    if (!repeats) {
        return [NSTimer ht_timerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats];
    }
    HTTimerObject *timerObj = [[HTTimerObject alloc] init];
    timerObj.target = target;
    timerObj.userInfo = userInfo;
    timerObj.selector = selector;
    timerObj.timeInterval = timeInterval;
    timerObj.targetClassName = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
    timerObj.targetSelectorName = NSStringFromSelector(selector);
    NSTimer *timer = [NSTimer ht_timerWithTimeInterval:timeInterval target:timerObj selector:@selector(fireTimer) userInfo:userInfo repeats:repeats];
    timerObj.timer = timer;
    return timer;
}

+ (NSTimer *)ht_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
    if (!repeats) {
        return [NSTimer ht_scheduledTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats];
    }
    HTTimerObject *timerObj = [[HTTimerObject alloc] init];
    timerObj.target = target;
    timerObj.userInfo = userInfo;
    timerObj.selector = selector;
    timerObj.timeInterval = timeInterval;
    timerObj.targetClassName = [NSString stringWithCString:object_getClassName(target) encoding:NSASCIIStringEncoding];
    timerObj.targetSelectorName = NSStringFromSelector(selector);
    NSTimer *timer = [NSTimer ht_scheduledTimerWithTimeInterval:timeInterval target:timerObj selector:@selector(fireTimer) userInfo:userInfo repeats:repeats];
    timerObj.timer = timer;
    return timer;
}

@end

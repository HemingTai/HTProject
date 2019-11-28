//
//  NSArray+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/24.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import "HTCrashReporter.h"

@implementation NSArray (Swizzling)

/**
 在iOS中NSNumber、NSArray、NSDictionary等这些类都是类簇，一个NSArray的实现可能由多个类组成。
 所以如果想对NSArray进行Swizzling，必须获取到其“真身”进行Swizzling，直接对NSArray进行操作是无效的。
 
 下面列举了NSArray和NSDictionary本类的类名，可以通过Runtime函数取出本类。
 NSArray                __NSArrayI
 NSMutableArray         __NSArrayM
 NSDictionary           __NSDictionaryI
 NSMutableDictionary    __NSDictionaryM
 */

+ (void)ht_interceptArrayAllCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ht_interceptArrayCrashCausedByIndexBeyondBounds];
        [self ht_interceptArrayCrashCausedByAttemptToInsertNilObject];
        [self ht_interceptMutableArrayCrash];
    });
}

+ (void)ht_interceptMutableArrayCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class clsM = NSClassFromString(@"__NSArrayM");
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(setObject:atIndexedSubscript:)
                                        swizzlingSelector:@selector(ht_setObject:atIndexedSubscript:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(removeObjectAtIndex:)
                                        swizzlingSelector:@selector(ht_removeObjectAtIndex:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(insertObject:atIndex:)
                                        swizzlingSelector:@selector(ht_insertObject:atIndex:)];
    });
}

+ (void)ht_interceptArrayCrashCausedByIndexBeyondBounds {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clsI = NSClassFromString(@"__NSArrayI");
        Class cls0 = NSClassFromString(@"__NSArray0");
        Class clsM = NSClassFromString(@"__NSArrayM");
        Class clsS = NSClassFromString(@"__NSSingleObjectArrayI");
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsI
                                         originalSelector:@selector(objectAtIndex:)
                                        swizzlingSelector:@selector(ht_objectAtIndexI:)];

        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsI
                                         originalSelector:@selector(objectAtIndexedSubscript:)
                                        swizzlingSelector:@selector(ht_objectAtIndexedSubscriptI:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(objectAtIndex:)
                                        swizzlingSelector:@selector(ht_objectAtIndexM:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(objectAtIndexedSubscript:)
                                        swizzlingSelector:@selector(ht_objectAtIndexedSubscriptM:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls0
                                         originalSelector:@selector(objectAtIndex:)
                                        swizzlingSelector:@selector(ht_objectAtIndex0:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsS
                                         originalSelector:@selector(objectAtIndex:)
                                        swizzlingSelector:@selector(ht_objectAtIndexS:)];
    });
}

+ (void)ht_interceptArrayCrashCausedByAttemptToInsertNilObject {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [HTCrashReporter ht_swizzleClassMethodForClass:[self class]
                                      originalSelector:@selector(arrayWithObjects:count:)
                                     swizzlingSelector:@selector(ht_arrayWithObjects:count:)];
    });
}

+ (instancetype)ht_arrayWithObjects:(const id _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self ht_arrayWithObjects:objects count:cnt];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayAttemptToInsertNilObject];
        //去掉值为nil的数据，然后重新初始化数组
        NSInteger objIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[objIndex] = objects[i];
                objIndex++;
            }
        }
        instance = [self ht_arrayWithObjects:newObjects count:objIndex];
    } @finally {
        return instance;
    }
}

- (id)ht_objectAtIndexI:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndexI:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)ht_objectAtIndexM:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndexM:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)ht_objectAtIndex0:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndex0:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)ht_objectAtIndexS:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndexS:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)ht_objectAtIndexedSubscriptI:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndexedSubscriptI:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (id)ht_objectAtIndexedSubscriptM:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ht_objectAtIndexedSubscriptM:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {
        return object;
    }
}

- (void)ht_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    @try {
        [self ht_setObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayAttemptToInsertNilObject];
    } @finally {
        
    }
}

- (void)ht_removeObjectAtIndex:(NSUInteger)idx {
    @try {
        [self ht_removeObjectAtIndex:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayIndexBeyondBounds];
    } @finally {

    }
}

- (void)ht_insertObject:(id)obj atIndex:(NSUInteger)idx {
    @try {
        [self ht_insertObject:obj atIndex:idx];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeArrayAttemptToInsertNilObject];
    } @finally {

    }
}

@end

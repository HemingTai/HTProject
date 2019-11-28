//
//  NSDictionary+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/2.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSDictionary+Swizzling.h"
#import "HTCrashReporter.h"

@implementation NSDictionary (Swizzling)

+ (void)ht_interceptDictionaryAllCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clsM = NSClassFromString(@"__NSDictionaryM");
        
        [HTCrashReporter ht_swizzleClassMethodForClass:self
                                      originalSelector:@selector(dictionaryWithObjects:forKeys:count:)
                                     swizzlingSelector:@selector(ht_dictionaryWithObjects:forKeys:count:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(setObject:forKey:)
                                        swizzlingSelector:@selector(ht_setObject:forKey:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(setObject:forKeyedSubscript:)
                                        swizzlingSelector:@selector(ht_setObject:forKeyedSubscript:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(removeObjectForKey:)
                                        swizzlingSelector:@selector(ht_removeObjectForKey:)];
    });
}

+ (instancetype)ht_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self ht_dictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeDictionaryAll];
        //去掉值为nil的数据，然后重新初始化字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self ht_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

- (void)ht_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    @try {
        [self ht_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeDictionaryAll];
    } @finally {
        
    }
}

- (void)ht_setObject:(nullable id)obj forKeyedSubscript:(id <NSCopying>)key {
    @try {
        [self ht_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeDictionaryAll];
    } @finally {
        
    }
}

- (void)ht_removeObjectForKey:(id)aKey {
    @try {
        [self ht_removeObjectForKey: aKey];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeDictionaryAll];
    } @finally {
        
    }
}

@end

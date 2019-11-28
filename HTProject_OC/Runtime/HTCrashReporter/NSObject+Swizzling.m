//
//  NSObject+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/23.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import "HTCrashReporter.h"
#import "HTCrashProxy.h"
#import <objc/runtime.h>

static const char DeallocObjectKey;

@interface HTDeallocProxy : NSObject

@property (nonatomic, copy) void (^deallocBlock)(void);

@end

@implementation HTDeallocProxy

- (void)dealloc {
    if (self.deallocBlock) {
        self.deallocBlock();
    }
    self.deallocBlock = nil;
}

@end


@implementation NSObject (Swizzling)

+ (void)ht_interceptObjectAllCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self ht_interceptObjectCrashCausedByKVC];
        [self ht_interceptObjectCrashCausedByUnrecognizedSelectorSentToInstance];
    });
}

+ (void)ht_interceptObjectCrashCausedByKVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forKey:) swizzlingSelector:@selector(ht_setValue:forKey:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forKeyPath:) swizzlingSelector:@selector(ht_setValue:forKeyPath:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValue:forUndefinedKey:) swizzlingSelector:@selector(ht_setValue:forUndefinedKey:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(setValuesForKeysWithDictionary:) swizzlingSelector:@selector(ht_setValuesForKeysWithDictionary:)];
    });
}

+ (void)ht_interceptObjectCrashCausedByUnrecognizedSelectorSentToInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if DEBUG
        //该方式导致NSInvocation会有一定的内存占用且forwardInvocation:会被频繁调用
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(methodSignatureForSelector:) swizzlingSelector:@selector(ht_methodSignatureForSelector:)];
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(forwardInvocation:) swizzlingSelector:@selector(ht_forwardInvocation:)];
#else
        //通过对forwardingTargetForSelector拦截，可以减少内存开销
        [HTCrashReporter ht_swizzleInstanceMethodForClass:[self class] originalSelector:@selector(forwardingTargetForSelector:) swizzlingSelector:@selector(ht_forwardingTargetForSelector:)];
#endif
    });
}

+ (void)ht_interceptObjectCrashCausedByUnreleasedWithDeallocBlock:(void (^)(void))deallocBlock {
    @synchronized (self) {
        NSMutableArray *deallocArray = objc_getAssociatedObject(self, &DeallocObjectKey);
        if (!deallocArray) {
            deallocArray = [[NSMutableArray alloc] init];
            objc_setAssociatedObject(self, &DeallocObjectKey, deallocArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        HTDeallocProxy *proxy = [[HTDeallocProxy alloc] init];
        proxy.deallocBlock = deallocBlock;
        [deallocArray addObject:proxy];
    }
}

- (void)ht_setValue:(nullable id)value forKey:(NSString *)key {
    @try {
        [self ht_setValue:value forKey:key];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)ht_setValue:(nullable id)value forKeyPath:(NSString *)keyPath {
    @try {
        [self ht_setValue:value forKeyPath:keyPath];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)ht_setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    @try {
        [self ht_setValue:value forUndefinedKey:key];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (void)ht_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues {
    @try {
        [self ht_setValuesForKeysWithDictionary:keyedValues];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeObjectKVC];
    } @finally {
        
    }
}

- (id)ht_forwardingTargetForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [NSMethodSignature methodSignatureForSelector:aSelector];
    if (!signature) {
        HTCrashProxy *proxy = [[HTCrashProxy alloc] init];
        Method proxyMethod = class_getInstanceMethod([HTCrashProxy class], @selector(ht_handleCrashMethod));
        class_addMethod([proxy class], aSelector, method_getImplementation(proxyMethod), method_getTypeEncoding(proxyMethod));
        return proxy;
    }
    return [self ht_forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)ht_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self ht_methodSignatureForSelector:aSelector];
    if (signature == nil) {
        signature = [HTCrashProxy instanceMethodSignatureForSelector:@selector(ht_handleCrashMethod)];
    }
    return signature;
}

- (void)ht_forwardInvocation:(NSInvocation *)anInvocation {
    @try {
        [self ht_forwardInvocation:anInvocation];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeObjectUnrecognizedSelectorSentToInstance];
    } @finally {
        
    }
}

@end

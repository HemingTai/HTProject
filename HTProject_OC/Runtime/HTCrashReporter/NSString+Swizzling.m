//
//  NSString+Swizzling.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/2.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "NSString+Swizzling.h"
#import "HTCrashReporter.h"

@implementation NSString (Swizzling)

+ (void)ht_interceptStringAllCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class cls = NSClassFromString(@"__NSCFConstantString");
        Class clsM = NSClassFromString(@"__NSCFString");
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(characterAtIndex:)
                                        swizzlingSelector:@selector(ht_characterAtIndex:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(substringFromIndex:)
                                        swizzlingSelector:@selector(ht_substringFromIndex:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(substringToIndex:)
                                        swizzlingSelector:@selector(ht_substringToIndex:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(substringWithRange:)
                                        swizzlingSelector:@selector(ht_substringWithRange:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(stringByReplacingCharactersInRange:withString:)
                                        swizzlingSelector:@selector(ht_stringByReplacingCharactersInRange:withString:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(stringByReplacingOccurrencesOfString:withString:)
                                        swizzlingSelector:@selector(ht_stringByReplacingOccurrencesOfString:withString:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:cls
                                         originalSelector:@selector(stringByReplacingOccurrencesOfString:withString:options:range:)
                                        swizzlingSelector:@selector(ht_stringByReplacingOccurrencesOfString:withString:options:range:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(replaceCharactersInRange:withString:)
                                        swizzlingSelector:@selector(ht_replaceCharactersInRange:withString:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(insertString:atIndex:)
                                        swizzlingSelector:@selector(ht_insertString:atIndex:)];
        
        [HTCrashReporter ht_swizzleInstanceMethodForClass:clsM
                                         originalSelector:@selector(deleteCharactersInRange:)
                                        swizzlingSelector:@selector(ht_deleteCharactersInRange:)];
    });
}

- (unichar)ht_characterAtIndex:(NSUInteger)index {
    unichar c;
    @try {
        c = [self ht_characterAtIndex: index];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
        
    }
}

- (NSString *)ht_substringFromIndex:(NSUInteger)from {
    NSString *res = nil;
    @try {
        res = [self ht_substringFromIndex: from];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (NSString *)ht_substringToIndex:(NSUInteger)to {
    NSString *res = nil;
    @try {
        res = [self ht_substringToIndex: to];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (NSString *)ht_substringWithRange:(NSRange)range {
    NSString *res = nil;
    @try {
        res = [self ht_substringWithRange: range];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (NSString *)ht_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    NSString *res = nil;
    @try {
        res = [self ht_stringByReplacingCharactersInRange: range withString: replacement];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (NSString *)ht_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    NSString *res = nil;
    @try {
        res = [self ht_stringByReplacingOccurrencesOfString: target withString: replacement];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (NSString *)ht_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange {
    NSString *res = nil;
    @try {
        res = [self ht_stringByReplacingOccurrencesOfString: target withString: replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
        res = @"";
    } @finally {
        return res;
    }
}

- (void)ht_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    @try {
        [self ht_replaceCharactersInRange: range withString: aString];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

- (void)ht_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    @try {
        [self ht_insertString: aString atIndex: loc];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

- (void)ht_deleteCharactersInRange:(NSRange)range {
    @try {
        [self ht_deleteCharactersInRange: range];
    } @catch (NSException *exception) {
        [HTCrashReporter ht_catchException:exception withCrashType:HTCrashTypeStringRangeOrIndexOutOfBounds];
    } @finally {
    }
}

@end

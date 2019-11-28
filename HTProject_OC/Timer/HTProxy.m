//
//  HTProxy.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/13.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTProxy.h"

@implementation HTProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_target];
}

@end

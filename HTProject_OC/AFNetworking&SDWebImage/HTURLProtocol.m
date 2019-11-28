//
//  HTURLProtocol.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/23.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTURLProtocol.h"

@implementation HTURLProtocol

/**
 对具体的request请求进行拦截，如果某请求已拦截过，则不再进行拦截

 @param request 请求
 @return YES: 拦截, NO: 不拦截
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([request.URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [request.URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        //已处理则不拦截
        if (![NSURLProtocol propertyForKey:request.URL.absoluteString inRequest:request]) {
            return YES;
        }
    }
    return NO;
}

/**
 可以对请求的request进行篡改

 @param request 原始请求
 @return 处理后的请求
 */
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //篡改原始请求
    mutableReqeust.URL = [NSURL URLWithString:@"https://www.baidu.com"];
    mutableReqeust.HTTPMethod = @"GET";
    [mutableReqeust setValue:@"iOS" forHTTPHeaderField:@"platform"];
    return mutableReqeust.copy;
}

/**
 在自定义request请求对象之后，就可以初始化一个 NSURLProtocol 对象了
 */
- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

/**
 自定义request和实例化NSURLProtocol对象后，需要手动发起请求，所以需要重写startLoading方法
 */
- (void)startLoading {
    NSLog(@"startLoading!!!");
    //由于修改后request，还会调用canInitWithRequest检测自定义的request是否可以被拦截，这样会造成死循环，所以此处需要对处理过的request进行标记
    [NSURLProtocol setProperty:@YES forKey:self.request.URL.absoluteString inRequest:self.request.mutableCopy];
    [[[NSURLSession sharedSession] dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        NSError *nerror;
        //篡改返回数据
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"key":@"测试"} options:NSJSONWritingPrettyPrinted error:&nerror];
        [self.client URLProtocol:self didLoadData:jsonData];
        if (error) {
            [self.client URLProtocol:self didFailWithError:error];
        } else {
            [self.client URLProtocolDidFinishLoading:self];
        }
    }] resume];
}

/**
 停止加载
 */
- (void)stopLoading {
    NSLog(@"stopLoading!!!");
}

@end

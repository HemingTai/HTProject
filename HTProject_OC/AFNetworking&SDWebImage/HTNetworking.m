//
//  HTNetworking.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/26.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTNetworking.h"
#import "HTURLProtocol.h"

@implementation HTNetworking

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static HTNetworking *manager;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //如果要对请求做拦截，需在指定protocolClass
        configuration.protocolClasses = @[[HTURLProtocol class]];
        manager = [[HTNetworking alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", @"text/json", nil];
        //移除null或者NSNull
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    });
    return manager;
}

@end

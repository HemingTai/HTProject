//
//  HTNetworking.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/8/26.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTNetworking : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END

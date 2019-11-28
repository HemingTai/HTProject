//
//  BaseViewModel.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Success)(NSArray *array);
typedef void(^Failure)(NSError *error);

@interface BaseViewModel : NSObject

@property(nonatomic, copy) Success successBlock;

@property(nonatomic, copy) Failure failureBlock;

- (void)initWithSuccess:(Success)successBlock failure:(Failure)failureBlock;

@end

NS_ASSUME_NONNULL_END

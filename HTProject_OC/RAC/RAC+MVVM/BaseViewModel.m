//
//  BaseViewModel.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)initWithSuccess:(Success)successBlock failure:(Failure)failureBlock
{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
}

@end

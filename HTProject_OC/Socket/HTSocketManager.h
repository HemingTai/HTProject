//
//  HTSocketManager.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/12.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketIO-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSocketManager : NSObject

@property (nonatomic, strong) SocketIOClient *socket;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END

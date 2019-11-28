//
//  HTSocketManager.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/12.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTSocketManager.h"

@interface HTSocketManager()

@property (nonatomic, strong) SocketManager *socketManager;

@end

@implementation HTSocketManager

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static HTSocketManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[HTSocketManager alloc] init];
        [manager configSocket];
    });
    return manager;
}

- (void)configSocket {
    self.socketManager = [[SocketManager alloc] initWithSocketURL:[NSURL URLWithString:@"https://socket.gjmetal.com"] config:@{@"log":@YES,@"compress":@YES,@"connectParams":@{@"userName":@"guojin"}}];
    self.socket = [self.socketManager socketForNamespace:@"/gj"];
}


@end

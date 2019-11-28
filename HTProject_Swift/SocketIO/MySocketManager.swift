//
//  MySocketManager.swift
//  HTProject_Swift
//
//  Created by Hem1ng on 2019/9/11.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import UIKit
@_exported import SocketIO

class MySocketManager: NSObject {
    
    static let shared = customConfiguration()
    
    fileprivate class func customConfiguration() -> SocketManager {
        /*config配置：
         *.log(true)：一般用于debug，会输出log信息，传入false则不输出log信息
         *.forceNew(true)：每次调用connect时，都会创建一个新引擎
         *.reconnects(true)：是否重连
         *.reconnectAttempts(10)：设置重连次数为10次，-1表示重连次数是无限次
         *.reconnectWait(20)：最小重连等待时间
         *.reconnectWaitMax(40)：最大重连等待时间
         */
        return SocketManager(socketURL: URL(string: "https://socket.gjmetal.com")!, config: [.log(true), .compress, .connectParams(["userName":"guojin"]), .forceNew(true), .reconnects(true), .reconnectAttempts(10), .reconnectWait(20), .reconnectWaitMax(40)])
    }
}

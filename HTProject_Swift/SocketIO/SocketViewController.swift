//
//  SocketViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ng on 2019/9/11.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import UIKit

class SocketViewController: UIViewController {

    //host：https://socket.gjmetal.com/gj?userName=userName
    //盘口：http://172.16.80.33:10020/rest/room/getPosition?contract=CU01
    //行情：http://172.16.80.33:10020/rest/room/getTree?code=future-quote
    //行情房间：http://172.16.80.33:10020/rest/room/getRoomItem?roomCode=3cu
    
    var flag = false
    let socket = MySocketManager.shared.socket(forNamespace: "/gj")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addClientEvents()
        //连接
        socket.connect()
        //连接并设置超时时间和超时回调闭包
//        socket.connect(timeoutAfter: 30) {
//            print("连接超时会回调此闭包")
//        }
    }
    
    deinit {
        if socket.status == .connected {
            //断开连接
            socket.disconnect()
        }
    }
    
    func addClientEvents() {
//        socket.once("joinInit") { (dataArray, ack) in
//            print("once事件：只监听一次")
//        }
//        socket.onAny { (anyEvent) in
//            print("onAny事件：监听所有事件")
//        }
//        socket.on("connect") { (dataArray, ack) in
//            print("on事件：全程一直监听该事件")
//        }
        //on事件是全程监听事件
        socket.on(clientEvent: .connect) { (dataArray, ack) in
            print("连接成功")
        }
        socket.on("joinInit") { (dataArray, ack) in
            print("---joinInit---\(dataArray)")
        }
        socket.on("stream") { (dataArray, ack) in
            print("---stream---\(dataArray)")
        }
        socket.on(clientEvent: .error) { (dataArray, ack) in
            print("连接出错")
        }
        socket.on(clientEvent: .ping) { (dataArray, ack) in
            print("ping")
        }
        socket.on(clientEvent: .pong) { (dataArray, ack) in
            print("pong")
        }
        socket.on(clientEvent: .reconnect) { (dataArray, ack) in
            print("重新连接")
        }
        socket.on(clientEvent: .reconnectAttempt) { (dataArray, ack) in
            print("尝试重新连接")
        }
        socket.on(clientEvent: .disconnect) { (dataArray, ack) in
            print("断开连接")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !flag {
            socket.emit("join", with: ["3cu"])
            flag = true
        } else {
            socket.emit("leave", with: ["3cu"])
            flag = false
        }
    }
}

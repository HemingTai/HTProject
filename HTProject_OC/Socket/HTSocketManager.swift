//
//  HTSocketManager.swift
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/10.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import Foundation
import SocketIO

class HTSocketManager: NSObject {
    
    fileprivate static let shared = customConfiguration()
    
    @objc class func sharedManager() -> SocketManager {
        return shared
    }
    
    fileprivate class func customConfiguration() -> SocketManager {
        return SocketManager(socketURL: URL(string: "https://socket.gjmetal.com")!, config: [.log(true), .compress, .connectParams(["userName":"guojin"])])
    }
}

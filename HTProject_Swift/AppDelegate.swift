//
//  AppDelegate.swift
//  HTProject_Swift
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /********************** OC的协议与Swift的协议有什么不同？为什么说Swift是面向协议编程？************************
     * OC中只有类可以遵循协议，并实现协议方法，struct不可以
     * Swift中协议可以支持扩展，struct也可以遵守协议
     *
     * 协议和协议扩展比基类有三个明显的优点：
     * 1、类型可以遵守多个协议但是只有一个基类。这意味着类型可以随意遵守任何想要特性的协议，而不需要一个巨大的基类。
     * 2、不需要知道源码就可以使用协议扩展添加功能。这意味着我们可以任意扩展协议，包括swift内置的协议，而不需要修改基类的源码。
     * 3、协议可以被类、结构体和枚举遵守，而类层级约束为类类型。
     */

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


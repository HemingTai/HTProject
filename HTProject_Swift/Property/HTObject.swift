//
//  HTObject.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2020/5/8.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//

import UIKit

class HTObject: NSObject {

    //默认属性关键字是public
    var height = 180
    public var name = "heming"
    //fileprivate属性关键字是指在当前file中，任何类都可以访问（包括子类）
    fileprivate var type = "human"
    //private属性关键字是指私有变量，任何类都不可以访问（包括子类）
    private var age = 18
    
    //designated初始化方法，如果不是private修饰，是可以被子类重写的
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
    
    //对于某些我们希望子类中一定实现的 designated 初始化方法，我们可以通过添加 required 关键字进行限制，强制子类对这个方法重写实现
    //这样做的最大的好处是可以保证依赖于某个 designated 初始化方法的 convenience 一直可以被使用
    required init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    //convenience初始化方法，是不可以被子类重写的，也不可以在子类中被以super的形式调用
    convenience init(type: String, age: Int) {
        // 所有的 convenience 初始化方法都必须调用同一个类中的 designated 初始化方法完成设置
        self.init(name: "tai", age: age)
        self.type = type
    }
    
    //对于 convenience 的初始化方法我们也可以加上 required 以确保子类对其进行实现。
    required convenience init(type: String, name: String, age: Int) {
        self.init(name: name, age: age)
        self.type = type
    }
}

class HTObjectSon: HTObject {
    
    let numSon: Int
    
    required init(name: String, age: Int) {
        numSon = 1 + age
        super.init(name: name, age: numSon)
    }
}

class Test: NSObject {
    let htObj = HTObject(type: "huhu", name: "haha", age: 20)
    //只要在子类中实现重写了父类 convenience 方法所需要的 init 方法的话，我们在子类中就可以使用父类的 convenience 初始化方法了
    let htObjSon = HTObjectSon(type: "hehe", age: 18)
}

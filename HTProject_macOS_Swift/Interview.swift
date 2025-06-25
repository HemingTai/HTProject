//
//  Interview.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2025/3/20.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import Foundation

// static 和 class 都可以修饰类方法，他们的区别是什么？
// static 修饰的函数不能被子类重写，而class修饰的函数可以被子类重写。
class ParentClass {
    static func testStatic() {
        print("this is a static function")
    }
    
    class func testClass() {
        print("this is a class function")
    }
}

class SonClass: ParentClass {
//    static func testStatic() {
//        
//    }
    
    override class func testClass() {
        print("this is a class function")
    }
}

//protocol 内可以有这些关键字
protocol TestProtocol {
    associatedtype TestType
    var name: String { get }
    var age: String { get set }
    func testFunction()
    mutating func testUpdateEnum() //只针对值类型起作用
    func testAsyncFunction() async throws
    func getItem() -> TestType
}

//需标记 @objc
@objc protocol TestOptional {
    @objc optional func testOptionFunc() //可选协议要求
}


// Swift 的 static let 已经是线程安全的
class MySingleton {
    static let shared = MySingleton()
    
    private init() {
        
    }
}

/********* [unowned self] 和 [weak self]区别 *********
 * swift虽然使用了ARC自动引用计数来管理内存，但是也不能保证完全准确，在使用闭包的时候有可能会引起循环引用
 * 所以此时只需将闭包捕获列表定义为弱引用(weak)或者无主引用(unowned)即可解决问题
 * 如果捕获（比如 self）可以被设置为 nil，也就是说它可能在闭包前被销毁，那么就要将捕获定义为 weak
 * 如果它们一直是相互引用，即同时销毁的，那么就可以将捕获定义为 unowned
 * weak 只能修饰 optional 类型，unowned 没有限制
 */
weak var son: SonClass?
unowned var son2: SonClass?

let a = [1,2,3].lazy.map {
    print($0)
}

/******************** questions and answers ********************/

/** 下面代码会输出什么？
 class Starship {
     var type: String
     var age: Int
   }
     
 let serenity = Starship(type: "Firefly", age: 24)
 print(serenity.type)
 答案：编译过不去，因为 class 没有 initializer，如果把class 换成 struct 就会输出 Firefly
 */

/** 下面代码有问题吗？
 final class Dog {
     func bark() {
         print("Woof!")
     }
 }

 class Corgi : Dog {
     override func bark() {
         print("Yip!")
     }
 }
 let muttface = Corgi()
 muttface.bark()
 答案：不能编译，final 标记的 class 不能被继承
 */

/** 下面代码会输出什么？
 var i = 2
 do {
     print(i)
     i *= 2
 } while (i < 128)
 答案：编译过不去，swift 里没有 do-while 语句，只有 repeat-while
 */

/** Swift 存储一个 Int 需要几个字节？
 答案：4B
 */

/** 下面代码会输出什么？
 let i = 3

 switch i {
 case 1:
     print("Number was 1")
 case 2:
     print("Number was 2")
 case 3:
     print("Number was 3")
 }
 答案：编译过不去，因为缺少了 default 分支
 */

/** 下面代码会输出什么？
 let names = ["Amy", "Clara"]

 for i in 0 ... names.length {
     print("Hello, \(names[i])!")
 }
 答案：编译过去不，因为数组没有 length 属性，只有 count
 */

/** 下面代码会输出什么？
 var motto = "Bow ties are cool"
 motto.replacing("Bow", with: "Neck")
 print(motto)
 答案：Bow ties are cool，replace 会生成新的 string，不改变原有的 string
 */

/**
 let oneMillion = 1_000_000
 let oneThousand = oneMillion / 0_1_0_0_0
 print(oneThousand)
 答案： 1000
 */

/**
 What output will be produced by the code below?

 let names = ["Amy", "Rory"]

 for name in names {
     name = name.uppercased()
     print("HELLO, \(name)!")
 }
 
 This code will not compile. Because this code will not compile because it modifies name inside the loop. If you want to do this, you must use the var keyword like this: for var name in names.
 */

struct BasicError: Error {
    var message: String
}

class Interview {
    
    func run() {
        test1()
        test2()
        test3()
        test4()
        test5()
    }
    
    func delay(_ seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
    
    func task1(function: String) async -> String {
        print("=== task1 stated in \(function)")
        try? await delay(1)
        print("=== task1 ended in \(function)")
        return "task1"
    }
    
    func task2(function: String) async -> String {
        print("=== task2 stated in \(function)")
        try? await delay(1.5)
        print("=== task2 ended in \(function)")
        return "task2"
    }
    
    func task3(function: String) async -> String {
        print("=== task3 stated in \(function)")
        try? await delay(0.8)
        print("=== task3 ended in \(function)")
        return "task3"
    }
    
    func task4(function: String) async throws -> String {
        print("=== task4 stated in \(function)")
        try? await delay(1.5)
        throw BasicError(message: "=== error occurred in \(function)")
    }
    
    func test1() { //serial
        Task {
            print("=== test1 started")
            _ = await task1(function: "test1")
            print("--------------")
            _ = await task2(function: "test1")
            print("**************")
            _ = await task3(function: "test1")
            print("..............")
            print("=== test1 finished")
        }
    }
    
    func test2() { // concurrent ordered
        print("=== test2 started")
        Task {
            print("=== test2 task started")
            async let task1 = task1(function: "test2")
            async let task2 = task2(function: "test2")
            async let task3 = task3(function: "test2")
            _ = await [task1, task2, task3]
            print("=== test2 task finished")
        }
        print("=== test2 finished")
    }
    
    func test3() { // concurrent unordered
        Task {
            print("=== test3 started")
            await withTaskGroup(of: String.self) { group in
                group.addTask { await self.task1(function: "test3") }
                group.addTask { await self.task2(function: "test3") }
                group.addTask { await self.task3(function: "test3") }
                
                for await result in group {
                    print("+++ \(result) in test3")
                }
            }
            print("=== test3 finished")
        }
    }
    
    func test4() {
        Task {
            print("=== test4 started")
            async let task1 = task1(function: "test4")
            async let task2 = task2(function: "test4")
            async let task3 = task3(function: "test4")
            async let task4 = task4(function: "test4")
            do {
                _ = try await [task1, task2, task3, task4]
            } catch {
                print("=== catch error in test4 \(error.localizedDescription)")
            }
            print("=== test4 finished")
        }
    }
    
    func test5() {
        Task {
            print("=== test5 started")
            do {
                try await withThrowingTaskGroup(of: String.self) { group in
                    group.addTask { await self.task1(function: "test5") }
                    group.addTask { await self.task2(function: "test5") }
                    group.addTask { await self.task3(function: "test5") }
                    group.addTask { try await self.task4(function: "test5") }
                    
                    for try await result in group {
                        print("+++ \(result) in test5")
                    }
                }
            } catch {
                print("=== catch error in test5 \(error.localizedDescription)")
            }
            print("=== test5 finished")
        }
    }
}

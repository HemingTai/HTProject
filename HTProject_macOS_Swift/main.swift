//
//  main.swift
//  HTProject_macOS_Swift
//
//  Created by Hem1ngT4i on 2021/6/4.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import Foundation
import SwiftUICore
import SwiftUI

run()

func run() {
//    testCurryingFunction()
//    testIteration()
//    testAdvancedFunctions()
//    testDiffBetweenStaticAndClass()
//    testDefineIntInOtherWay()
//    testCopyOnWrite()
//    testGetterSetter()
//    testLazyPropertyInStruct()
    testOtherPointsNeededAttention()
//    testRegex()
    //exam1()
    //exam2()
    //exam3()
//    Algorithm.run()
    Interview1().run()
    
    let names = ["Amy", "Rory"]

    //在遍历的时候，如果想改变临时变量，得加 var
    for var name in names {
        name = name.uppercased()
        print("HELLO, \(name)!")
    }
    print(names)
}

//函数柯里化
func myIncrementor(param:Int) -> () -> Int {
    var temp = 0
    func increment() -> Int {
        temp += param
        return temp
    }
    return increment
}

func testCurryingFunction() {
    let incrementByTen = myIncrementor(param: 10)
    print("incrementByTen: \(incrementByTen())")
    print("incrementByTenAgain: \(incrementByTen())")
    let incrementByTwo = myIncrementor(param: 2)
    print("incrementByTwo: \(incrementByTwo())")
    print("incrementByTwoAgain: \(incrementByTwo())")
}

/// 比较for...in & forEach的异同
func testIteration() {
    /********************** for...in & forEach **********************
     * 在遍历的代码块中，如果含有return语句：
     * for...in语句会在条件成立时立即return，程序终止，下一次的遍历也不会执行
     * forEach语句会在条件成立时跳过当前执行，继续执行下一次的遍历
     *
     * 在遍历的代码块中，如果不含有return语句，则两者相同，随便选用
     */
    let array = [1,2,3,4,5]
    
    array.forEach {
        if $0 == 3 {
            return
        }
        print($0)
    }
    print("============ end forEach ============")
    
    for element in array {
        if element == 3 {
            print("============ end for...in ============")
            return
        }
        print(element)
    }
}

/// sorted、filter、map、reduce、flatMap、compactMap
func testAdvancedFunctions() {
    let originalArray = [3,8,5,9,2,6,1,7,4,0]
    
    //sorted: 对数组元素进行排序，会生成一个已排好序的新数组。
    let sortedArray = originalArray.sorted()
    print("=== end sorted: \(sortedArray)")
    
    //filter: 对集合元素按给定条件进行过滤，会生成一个已过滤的新集合；分别有以下两种写法，但结果相同。
    let filterArray1 = originalArray.filter { (element) -> Bool in
        return element > 5
    }
    let filterArray2 = originalArray.filter { $0 > 5 }
    print("=== end filter: \(filterArray1), \(filterArray2)")
    
    //map: 对集合元素分别进行相同操作，会生成一个已操作的新集合；分别有以下两种写法，但结果相同。
    let mapArray1 = originalArray.map { (element) -> Int in
        return element * 2
    }
    let mapArray2 = originalArray.map { $0 * 2 }
    print("=== end map: \(mapArray1), \(mapArray2)")
    
    //reduce: 接收两个参数，一个初始值和一个组合闭包(combine closure): 如下给定一个初始值，并求和集合元素，会返回一个新值
    let sum = originalArray.reduce(10, +)
    let names = ["alan", "brian", "charlie"]
    //name是集合中的元素，text相当于初始值和每一次元素连接之后的值，也可简写成$0,$1
    let reduceResult1 = names.reduce("===") { text, name in
      "\(text), \(name)"
    }
    let reduceResult2 = names.reduce("heming", { "\($0),\($1)" })
    print("=== end reduce: \(sum), \(reduceResult1), \(reduceResult2)")
    
    //compactMap: 可识别集合中的nil值并过滤，会生成一个新集合
    let elementsArray1 = ["5","6",nil,"7",nil,"8"]
    let compactMapArray = elementsArray1.compactMap { $0 }
    print("=== end compactMap: \(compactMapArray)")
    
    //flatMap: 可以将二维数组拆成一维数组
    let elementsArray2 = [[1,2,3,4],[5,6],[7,8,9]]
    let flatMapArray = elementsArray2.flatMap { $0 }
    print("=== end flatMap: \(flatMapArray)")
}

class ParentClass {
    static func testStatic() {
        print("this is a static function in parent")
    }
    
    class func testClass() {
        print("this is a class function in parent")
    }
}

class SonClass: ParentClass {
    // static 标记的函数不可被 override
//    static func testStatic() {
//
//    }
    
    // class 标记的函数可被 override
    override class func testClass() {
        print("this is a class function in Son")
    }
}

func testDiffBetweenStaticAndClass() {
    ParentClass.testStatic()
    ParentClass.testClass()
    SonClass.testClass()
}

class Algorithm {
    static func run() {
        print("twoSum: \(twoSum([1,2,7,11,13], 9))")
        print("lengthOfLongestSubstring: \(lengthOfLongestSubstring("abshdfdf"))")
        print(iteratorTree(inputTree: testTree3))
        
        sortBySelection()
        sortByBubble()
        sortByInsertion()
        quickSort()
    }
    
    // 给定一个数组和一个目标值，找出数组中某两项之和等于目标值得元素的下标
    // Example: nums = [2, 7, 11, 15], target = 9, Because nums[0] + nums[1] = 2 + 7 = 9, return [0, 1].
    static func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var indexArray:[Int] = []
        for i in 0 ..< nums.count {
            let item = nums[i]
            //过滤掉大于目标值的元素
            if item < target {
                indexArray.append(i)
            }
            let result = target - item
            if nums.contains(result) {
                indexArray.append(nums.firstIndex(of: result)!)
                break
            } else {
                indexArray.remove(at: 0)
            }
        }
        return indexArray
    }

    //给定字符串，找出最长子串且不包含重复字符 adcgdfei
    static func lengthOfLongestSubstring(_ s: String) -> Int {
        var result = ""
        var count = 0
        for c in s {
            if result.contains(c) {
                let index1 = result.firstIndex(of: c)
                let index2 = result.index(after: index1!)
                result = String(result[index2..<result.endIndex])
            }
            result.append(c)
            if result.count > count {
                count = result.count
            }
        }
        return count;
    }

    typealias Tree = [String: Any]
    typealias ListTree = [Tree]

    static var outputTree: Tree = [:]
    static let testTree5: Tree = [
        "A": "a1",
        "B": "b1",
        "C": "c1",
        "D": [
                [
                    "A": "a2",
                    "B": "b2",
                    "C": "c2",
                    "D": [
                            [
                                "A": "a3",
                                "B": "b3",
                                "C": "c3",
                                "D": [
                                        [
                                            "A": "a4",
                                            "B": "b4",
                                            "C": "c4",
                                            "D": [
                                                    [
                                                        "A": "a5",
                                                        "B": "b5",
                                                        "C": "c5",
                                                        "D": []
                                                    ]
                                            ]
                                        ]
                                ]
                            ]
                    ]
                ]
        ]
    ]

    static let testTree3: Tree = [
        "A": "a1",
        "B": "b1",
        "C": "c1",
        "D": [
                [
                    "A": "a2",
                    "B": "b2",
                    "C": "c2",
                    "D": [
                            [
                                "A": "a3",
                                "B": "b3",
                                "C": "c3",
                                "D": [
                                        [
                                            "A": "a4",
                                            "B": "b4",
                                            "C": "c4",
                                            "D": []
                                        ]
                                ]
                            ]
                    ]
                ]
        ]
    ]

    static func iteratorTree(inputTree: Tree) -> Tree {
        var iteratorTime = 0
        outputTree = iteratorTree(inputTree: inputTree, iteratorTime: &iteratorTime)
        return outputTree
    }

    static func iteratorTree(inputTree: Tree, iteratorTime: inout Int) -> Tree {
        var tempTree: Tree = [:]
        iteratorTime += 1
        inputTree.forEach { k, v in
            if k == "D" {
                if iteratorTime < 4 {
                    tempTree[k] = iteratorTree(inputTree: (v as! [Tree]).first!, iteratorTime: &iteratorTime)
                } else {
                    tempTree[k] = []
                }
            } else {
                tempTree[k] = v
            }
        }
        return tempTree
    }
    
    //选择排序: 让数组中的每一个数依次与后面的数进行比较，如果前面的数大于后面的数，则记录下较小值的下标，待一轮循环结束后与最小值位置交换 TC = O(n^2), SC = O(1)
    static func sortBySelection() {
        var array = [4, 3, 5, 9, 6, 2, 8, 7, 1]
        for i in 0 ..< array.count - 2 {
            var minIndex = i
            let startIndex = i + 1
            for j in startIndex ..< array.count {
                if array[minIndex] > array[j] {
                    minIndex = j
                }
            }
            if minIndex != i {
                array.swapAt(i, minIndex)
            }
        }
        print(array)
    }
    
    //冒泡排序: 从数组的第一个元素开始，依次比较相邻的两个元素，若第一个元素比第二个元素大则交换位置，一轮结束最大的数排在末位 TC = O(n^2)(倒序数组)，BTC = O(n)(顺序数组), SC = O(1)
    static func sortByBubble() {
        var array = [4, 3, 5, 9, 6, 2, 8, 7, 1]
        //        var array = [4, 5, 6]
        //        var array = [4, 3, 5, 2, 1, 6, 7, 8 , 9]
        let count = array.count
        for i in 0 ..< count {
            //isSorted是用来优化性能的，假设已经是排好序的，如果一轮循环结束后还是排好序的，则直接跳出循环，说明不用排序
            var isSorted = true
            for j in 0 ..< count - 1 - i {
                if array[j] > array[j + 1] {
                    array.swapAt(j, j + 1)
                    isSorted = false
                }
            }
            if isSorted {
                break
            }
        }
        print(array)
    }
    
    //插入排序：将未排序部分的元素逐个插入到已排序部分的正确位置，TC = O(n^2)(倒序数组), BTC = O(n)(顺序数组)，SC = O(1)
    static func sortByInsertion() {
        var array = [4, 3, 5, 9, 6, 2, 8, 7, 1]
        //假设第一个元素已排序，那么未排序的元素从下标 1 开始
        for i in 1 ..< array.count {
            let key = array[i]
            var j = i - 1 //选择已排序序列的最后一个元素
            while j >= 0 && array[j] > key {//如果已排序序列有元素大于当前元素
                array[j + 1] = array[j]//则大于当前元素的元素向后移动
                j -= 1//再循环比较前面的元素
            }
            array[j + 1] = key//插入当前元素
        }
        print(array)
    }
    
    static func quickSort() {
        var array = [4, 3, 5, 9, 6, 2, 8, 7, 1]
        quickSortInPlace(array: &array, low: 0, high: array.count - 1)
        print(array)
        let result = quickSortInFilter(array.shuffled())
        print(result)
    }
    
    private static func quickSortInFilter(_ array: [Int]) -> [Int] {
        //终止条件
        guard array.count > 1 else { return array }
        //选取基准值，这里选择中间元素
        let pivot = array[array.count / 2]
        //分割成三部分，小于基准值，等于基准值，大于基准值
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        return quickSortInFilter(less) + equal + quickSortInFilter(greater)
    }
    
    //快速排序：分治法，选取基准值，将数组分成两部分，一部分小于基准值，另一部分大于基准值，再对这两部分递归排序 TC = O(n^2), BTC = O(nlogn),
    private static func quickSortInPlace(array: inout [Int], low: Int, high: Int) {
        if low < high {
            let pivotIndex = partition(array: &array, low: low, high: high)
            quickSortInPlace(array: &array, low: low, high: pivotIndex - 1)
            quickSortInPlace(array: &array, low: pivotIndex + 1, high: high)
        }
    }
    
    private static func partition(array: inout [Int], low: Int, high: Int) -> Int {
        let pivot = array[high]
        var i = low
        for j in low..<high {
            if array[j] < pivot {
                array.swapAt(i, j)
                i += 1
            }
        }
        array.swapAt(i, high)
        return i
    }
}

func testDefineIntInOtherWay() {
    let oneMillion = 1_000_000
    let oneThousand = oneMillion / 0_1_0_0_0
    print(oneThousand)
}

func testCopyOnWrite() {
    //copy-on-write: 写时复制，值类型当且紧当在改变值的时候才会进行复制，如果只是简单的赋值给另一个变量，内存地址不会发生改变
    let arrayA = [1,2,3]
    print("array A address: \(arrayA.withUnsafeBufferPointer { String(describing: $0.baseAddress) })")
    var arrayB = arrayA
    print("array B address: \(arrayB.withUnsafeBufferPointer { String(describing: $0.baseAddress) })")
    arrayB[2] = 4
    print(arrayA, arrayB)
    print("array B address changed: \(arrayB.withUnsafeBufferPointer { String(describing: $0.baseAddress) })")
}

func testGetterSetter() {
    //属性观察器：willSet 和 didSet, willSet 中可以拿到 newValue, didSet 中可以拿到 oldValue
    struct Circle {
        var radius: Int {
            willSet {
                print("oldValue is \(radius), newValue is \(newValue)")
            }
            
            didSet {
                print("newValue is \(radius), oldValue is \(oldValue)")
            }
        }
    }
    
    var c = Circle(radius: 10)
    c.radius = 20
}

func testLazyPropertyInStruct() {
    struct Point {
        var x = 0
        var y = 0
        lazy var z = 0
        
        mutating func updateX() {
            x += 1
        }
    }
    
    let p = Point()
    //此时访问 p.z 会报错，因为 p 是 let 常量，访问延迟存储属性 z 时，会初始化 z，又因为 z 是存储在 struct 中，所以 p 也会被篡改，想要通过编译，把 let 改成 var 即可
//    print(p.z)
}

func testOtherPointsNeededAttention() {
    print("expanded".dropFirst(3).dropLast(2))
    
    let dataSource = [1, 2, nil, 4, 5, nil, 7, 8, nil]
    let mappedList = dataSource.filter { $0 != nil }.map { $0 }
    print(mappedList)

    //dataSource.append(10) //error, dataSource 是常量
    //let mappedList2 = dataSource.filter { $0 != nil }.map { $0 * $0 }
    //print(mappedList2)
    
    sb()
    ss()
    si()
    qs()
}

func sb() {
    var list = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    for i in 0..<list.count - 1 {
        var sorted = true
        for j in 0..<list.count - 1 - i {
            if list[j] > list[j + 1] {
                list.swapAt(j, j + 1)
                sorted = false
            }
        }
        if sorted {
            break
        }
    }
    print(list)
}

func ss() {
    var list = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    for i in 0..<list.count - 1 {
        var min = i
        for j in i+1..<list.count {
            if list[j] < list[min] {
                min = j
            }
        }
        if min != i {
            list.swapAt(i, min)
        }
    }
    print(list)
}

func si() {
    var list = [1, 4, 5, 2, 6, 3, 8, 7, 9]
    for i in 1..<list.count {
        var j = i - 1
        while j >= 0 && list[j] > list[i] {
            list[j + 1] = list[j]
            j -= 1
        }
        list[j + 1] = list[i]
    }
    print(list)
}

func qs() {
    var list = [3, 4, 9, 2, 6, 1, 8, 7, 5]
    qsw(list: &list, low: 0, high: list.count - 1)
    print(list)
}
func qsw(list: inout [Int], low: Int, high: Int) {
    if low < high {
        let index = qsp(list: &list, low: low, high: high)
        qsw(list: &list, low: 0, high: index - 1)
        qsw(list: &list, low: index + 1, high: high)
    }
}
func qsp(list: inout [Int], low: Int, high: Int) -> Int {
    let pivot = list[high]
    var i = low
    for j in low..<high {
        if list[j] < pivot {
            list.swapAt(i, j)
            i += 1
        }
    }
    list.swapAt(i, high)
    return i
}

/**
 exams:
 1. add an extension function isValidEmail() to the string to check if the string is valid email(string must have @ and have . after @)
 */
extension String {
    func isEmailValid() -> Bool {
        do {
            let reg = try NSRegularExpression(pattern: "^[a-zA-Z0-9\\_\\-\\.]+(@)[a-zA-Z0-9]+\\.[a-zA-Z0-9]+$")
            return reg.matches(in: self, range: NSRange(location: 0, length: self.count)).count > 0
        } catch {
            print(error)
            return false
        }
    }
}

func testRegex() {
    print("abc".isEmailValid())
    print("abc@def".isEmailValid())
    print("abc@def.hig".isEmailValid())
}

class User {
    var name: String
    var age: Int
    var country: String? = nil
    var enabled = false
    static let organization = "Not Organized"
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

enum Result {
    case success(User2)
    case error(String)
    case loading
}

func handleResult(_ result: Result) {
    switch result {
    case .success(let user):
        print(user.name)
    case .error(let message):
        print(message)
    default:
        break
    }
}

struct User2 {
    var id: Int
    var name: String
}

struct UserList: View {
    var list: [User]
    
    var body: some View {
        LazyVStack {
            ForEach(list, id: \.name) {
                Text("Name: \($0.name), Age: \($0.age)")
            }
        }
    }
}

func delay(_ seconds: TimeInterval) async throws {
    try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
}

func fetchUserData() async -> String {
    print()
    try? await delay(1)
    return "User Data"
}

func fetchUserPosts() async -> String {
    try? await delay(1.5)
    return "User Posts"
}

func exam1() {
    Task {//concurrency
        async let posts = fetchUserPosts()
        async let data = fetchUserData()
        let results = await [posts, data] //尽管 posts 和 data 是并发执行的，并且 data 的完成时间更短，但是由于调度的不确定性，posts 可能会先完成，此外 await [posts, data] 会按照数组的任务声明顺序等待其完成，并将结果按顺序存储。如果希望结果按实际完成的顺序排列，请使用 TaskGroup
        print("=== concurrency: " + results.joined(separator: ", "))
    }
}

func exam2() {
    Task {
        await withTaskGroup(of: String.self) { group in
            group.addTask { await fetchUserPosts() }
            group.addTask { await fetchUserData() }
            
            for await result in group {
                print("=== task group: \(result)")
            }
        }
    }
}

func exam3() {
    Task {//serial
        let posts = await fetchUserPosts()
        print("=== serial: " + posts)
        let data = await fetchUserData()
        print("=== serial: " + data)
        exit(0)//在 macOS 的命令行项目下，程序会立刻执行 main.swift 文件，然后退出主线程，这里虽然启动了 Task，但是还未来得及执行主线程就退出了，所以在下方调用 dispathMain() 保持主线程不被退出，然后在 Task 内部调用 exit(0)退出
    }
}

struct BasicError: Error {
    var message: String
}

class Interview1 {
    
    func run() {
//        test1()
//        test2()
//        test3()
//        test4()
//        test5()
        test6()
    }
    
    func delay(_ seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
    
    func task1(function: String) async -> String {
        print("=== task1 started in \(function)")
        try? await delay(1)
        print("=== task1 ended in \(function)")
        return "task1"
    }
    
    func task2(function: String) async -> String {
        print("=== task2 started in \(function)")
        try? await delay(1.5)
        print("=== task2 ended in \(function)")
        return "task2"
    }
    
    func task3(function: String) async -> String {
        print("=== task3 started in \(function)")
        try? await delay(0.8)
        print("=== task3 ended in \(function)")
        return "task3"
    }
    
    func task4(function: String) async throws -> String {
        print("=== task4 started in \(function)")
        try? await delay(1.2)
        throw BasicError(message: "=== task4: error occurred in \(function)")
    }
    
    func test1() { //有序, Task 不会阻塞线程
        print("=== test1 started")
        Task {
            print("=== test1 task started")
            _ = await task1(function: "test1")
            print("--------------")
            _ = await task2(function: "test1")
            print("**************")
            _ = await task3(function: "test1")
            print("..............")
            print("=== test1 task finished")
        }
        print("=== test1 finished")
    }
    
    func test2() { //过程无序，但是结果有序
        print("=== test2 started")
        Task { // Task 不会阻塞线程
            print("=== test2 task started")
            
            async let task1 = task1(function: "test2")
            async let task2 = task2(function: "test2")
            async let task3 = task3(function: "test2")//使用 async let 声明的异步任务会立即启动，可以注释下面三行代码看效果
            
            //results会按照数组的任务声明顺序等待其完成，并将结果按顺序存储，如果希望结果按实际完成的顺序排列，请使用 TaskGroup
            let results = await [task1, task2, task3]
            print("***************** results: \(results)")
            print("=== test2 task finished")
        }
        print("=== test2 finished")
    }
    
    func test3() { //过程无序，结果无序
        Task {
            print("=== test3 started")
            await withTaskGroup(of: String.self) { group in
                group.addTask { await self.task1(function: "test3") }
                group.addTask { await self.task2(function: "test3") }
                group.addTask { await self.task3(function: "test3") }
                
                var results = ""
                for await result in group {
                    results += " \(result) "
                }
                print("***************** results:\(results)")
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
            do {// 并发任务中的某一个任务如果抛出异常，不会影响其他任务的执行
                _ = try await [task1, task2, task3, task4]
            } catch {
                print((error as! BasicError).message)
            }
            print("=== test4 finished")
        }
    }
    
    func test5() {
        Task {
            print("=== test5 started")
            async let task1 = task1(function: "test5")
            async let task2 = task2(function: "test5")
            async let task3 = task3(function: "test5")
            async let task4 = { // 除了 test4() 中可以集中一起处理 error，也可以像这个单独处理 error
                do {
                    return try await self.task4(function: "test5")
                } catch {
                    print(((error as! BasicError).message))
                    return ""
                }
            }()
            _ = await [task1, task2, task3, task4]
            print("=== test5 finished")
        }
    }
    
    func test6() {
        Task {
            print("=== test6 started")
            do {// 在 withThrowingTaskGroup 中，如果某一个 task 抛出异常，那么整个 group 就会取消
                try await withThrowingTaskGroup(of: String.self) { group in
                    group.addTask { await self.task1(function: "test6") }
                    group.addTask { await self.task2(function: "test6") }
                    group.addTask { await self.task3(function: "test6") }
                    group.addTask { try await self.task4(function: "test6") }
                    
                    var results = ""
                    for try await result in group {
                        results += result
                    }
                    print("***************** results:\(results)")//由于 task4 抛异常，因此这行代码不会被执行
                }
            } catch {// 检测到 task4 抛出异常，因此所有任务被取消
                print("=== all tasks are cancelled: \((error as! BasicError).message)")
            }
            print("=== test6 finished")
        }
    }
}

dispatchMain()

//
//  main.swift
//  HTProject_macOS_Swift
//
//  Created by Hem1ngT4i on 2021/6/4.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import Foundation

//函数柯里化
func myIncrementor(param:Int) -> () -> Int {
    var temp = 0
    func increment() -> Int {
        temp += param
        return temp
    }
    return increment
}
let incrementByTen = myIncrementor(param: 10)
print("incrementByTen: \(incrementByTen())")
print("incrementByTenAgain: \(incrementByTen())")
let incrementByTwo = myIncrementor(param: 2)
print("incrementByTwo: \(incrementByTwo())")
print("incrementByTwoAgain: \(incrementByTwo())")

/// 比较for...in & forEach的异同
func function1() {
    /********************** for...in & forEach **********************
     * 在遍历的代码块中，如果含有return语句：
     * for...in语句会在条件成立时立即return，程序终止，下一次的遍历也不会执行
     * forEach语句会在条件成立时跳过当前执行，继续执行下一次的遍历
     *
     * 在遍历的代码块中，如果不含有return语句，则两者相同，随便选用
     */
    let array = [1,2,3,4,5]
    
    array.forEach { (element) in
        if element == 3 {
            return
        }
        print(element)
    }
    print("-------------------------------------")
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
function1()

/// sorted、filter、map、reduce、flatMap、compactMap
func function2() {
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
    let name = ["alan", "brian", "charlie"]
    //name是集合中的元素，text相当于初始值和每一次元素连接之后的值，也可简写成$0,$1
    let reduceResult1 = name.reduce("===") { text, name in
      "\(text), \(name)"
    }
    let reduceResult2 = name.reduce("heming", { "\($0),\($1)" })
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
function2()

// 给定一个数组和一个目标值，找出数组中某两项之和等于目标值得元素的下标
// Example: nums = [2, 7, 11, 15], target = 9, Because nums[0] + nums[1] = 2 + 7 = 9, return [0, 1].
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
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
print("twoSum: \(twoSum([1,2,7,11,13], 9))")

//给定字符串，找出最长子串且不包含重复字符 adcgdfei
func lengthOfLongestSubstring(_ s: String) -> Int {
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
print("lengthOfLongestSubstring: \(lengthOfLongestSubstring("abshdfdf"))")


typealias Tree = [String: Any]
typealias ListTree = [Tree]

var outputTree: Tree = [:]
let testTree5: Tree = [
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

let testTree3: Tree = [
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

func iteratorTree(inputTree: Tree) -> Tree {
    var iteratorTime = 0
    outputTree = iteratorTree(inputTree: inputTree, iteratorTime: &iteratorTime)
    return outputTree
}

func iteratorTree(inputTree: Tree, iteratorTime: inout Int) -> Tree {
    var tempTree: Tree = [:]
    iteratorTime += 1
    inputTree.forEach { k, v in
        if v is ListTree {
            if iteratorTime < 4 {
                tempTree[k] = iteratorTree(inputTree: (v as! ListTree)[0], iteratorTime: &iteratorTime)
            } else {
                tempTree[k] = []
            }
        } else {
            tempTree[k] = v
        }
    }
    return tempTree
}

print(iteratorTree(inputTree: testTree3))

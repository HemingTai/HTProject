//
//  AdvanceFunction.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2020/4/9.
//  Copyright © 2020 Hem1ngT4i. All rights reserved.
//  高阶函数

import UIKit

class HigherOrderFunction: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        function1()
        function2()
    }
    
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
        array.forEach {
            if $0 == 3 {
                return
            }
            print($0)
        }
        print("end forEach")
        
        for element in array {
            if element == 3 {
                return
            }
            print(element)
        }
        print("end for...in")
    }
    
    /// sorted、filter、map、reduce、flatMap、compactMap
    func function2() {
        let originalArray = [3,8,5,9,2,6,1,7,4,0]
        
        //sorted: 对数组元素进行排序，会生成一个已排好序的新数组。
        let sortedArray = originalArray.sorted()
        print(sortedArray)
        
        //filter: 对集合元素按给定条件进行过滤，会生成一个已过滤的新集合；分别有以下两种写法，但结果相同。
        let filterArray1 = originalArray.filter { (element) -> Bool in
            return element > 5
        }
        let filterArray2 = originalArray.filter { return $0 > 5 }
        print(filterArray1, filterArray2)
        
        //map: 对集合元素分别进行相同操作，会生成一个已操作的新集合；分别有以下两种写法，但结果相同。
        let mapArray1 = originalArray.map { (element) -> Int in
            return element*2
        }
        let mapArray2 = originalArray.map { return $0*2 }
        print(mapArray1, mapArray2)
        
        //reduce: 接收两个参数，一个初始值和一个组合闭包(combine closure): 如下给定一个初始值，并求和集合元素，会返回一个新值
        let sum = originalArray.reduce(10, +)
        let name = ["alan", "brian", "charlie"]
        //name是集合中的元素，text相当于初始值和每一次元素连接之后的值，也可简写成$0,$1
        let reduceResult1 = name.reduce("===") { text, name in
          "\(text), \(name)"
        }
        let reduceResult2 = name.reduce("heming", { "\($0),\($1)" })
        print(reduceResult1, sum, reduceResult2)
        
        //compactMap: 可识别集合中的nil值并过滤，会生成一个新集合
        let elementsArray1 = ["5","6",nil,"7",nil,"8"]
        let compactMapArray = elementsArray1.compactMap { $0 }
        print(compactMapArray)
        
        //flatMap: 可以将二维数组拆成一维数组
        let elementsArray2 = [[1,2,3,4],[5,6],[7,8,9]]
        let flatMapArray = elementsArray2.flatMap { $0 }
        print(flatMapArray)
    }
}

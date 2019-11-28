//
//  AlgorithmViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ng on 2019/7/22.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}



class AlgorithmViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("result: \(twoSum([1,2,7,11,13], 9))")
        print("\(lengthOfLongestSubstring("abshdfdf"))")
    }
    
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
}

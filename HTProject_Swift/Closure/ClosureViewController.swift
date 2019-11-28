//
//  ViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngTai on 2018/10/11.
//  Copyright © 2018年 Hem1ng. All rights reserved.
//  

import UIKit

class ClosureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let incrementByTen = myIncrementor(param: 10)
        print("result: \(incrementByTen())")
        print("result: \(incrementByTen())")
        
        let incrementByTwo = myIncrementor(param: 2)
        print("result: \(incrementByTwo())")
        print("result: \(incrementByTwo())")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(AnimationViewController(), animated: true)
    }
    
    func myIncrementor(param:Int) -> () -> Int {
        var temp = 0
        func increment() -> Int {
            temp += param
            return temp
        }
        return increment
    }
}


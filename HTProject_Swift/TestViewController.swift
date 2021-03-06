//
//  TestViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2021/1/27.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import UIKit

class Student {
    
    let name: String
    var score = 0
    
    init(name: String, score: Int = 0) {
        self.name = name
        self.score = score
    }
}

class TestViewController: UIViewController {

    private let intArray = [1,2,3,4,5,6,7,8,9,10]
    private var intArray2 = [1,2,3,4,5,4,3,2,2,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(intArray.toDictionary { String($0) })
        
        let students = intArray.map { Student(name: String($0), score: $0) }.toDictionary { $0.name }
        print(students)
        
        print(intArray.subArray(start: 3, length: 8))
        print(intArray2.distinct(keyFunc: { String($0) }))
        print(intArray2.removeFirst { $0 < 3 }, intArray2)
        print(intArray2.removeAll { $0 < 3 }, intArray2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
    }
}

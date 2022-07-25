//
//  CombineViewController.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2021/1/15.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import UIKit
import Combine

class CombineViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    private var dispose = Set<AnyCancellable>()
    private let student = Student(name: "Hem1ng")
    private let list = [0,1,1,2,3,3,3,4,4,5,6,7,7,8,9,0,1,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //publisher - subscriber
        textField.publisher(for: \.text, options: NSKeyValueObservingOptions.new)
            .sink(receiveValue: { [weak self] in self?.student.score = Int($0 ?? "0") ?? 0 })
            .store(in: &dispose)
        
        list.publisher
            .removeDuplicates()
            .sink { print("==== \($0)") }
            .store(in: &dispose)
        
        list.publisher
            .removeDuplicates() //移除重复值
            .sink(receiveCompletion: { _ in
                print("completion!!!!")
            }, receiveValue: { print("**** \($0)") })
            .store(in: &dispose)
    }
    
    deinit {
        print("====== deinit ======")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
        print((student.name ?? "") + "'s score is \(student.score)")
    }
}

//
//  TestHostingController.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2025/3/13.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import UIKit

class TestHostingController: BaseHostingController<TestView> {

    @InjectViewModel
    var viewModel: TestViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func observeViewModel() {
        viewModel.age.observe(self) { age, _ in
            print(age)
        }
    }
}

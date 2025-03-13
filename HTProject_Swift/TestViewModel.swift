//
//  TestViewModel.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2025/3/13.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import Foundation

class TestViewModel: BaseViewModel {
    lazy var age = LiveData(value: 1)
    lazy var name = liveStateOf("--")
}

//
//  BaseHostingController.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2025/3/13.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

typealias JsonObject = Dictionary<String, Any>

class BaseHostingController<V: View>: UIHostingController<V> {
    private let VIEW_MODEL = "view_model"
    fileprivate(set) var params = JsonObject()
    lazy var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func observeViewModel() {
        //override by subclass
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel() }
        #if DEBUG
            debugPrint("============ \(classForCoder) deinit at \(Date()) ============")
        #endif
    }
}

extension BaseHostingController: ViewModelHolder {
    
    func setParams(_ object: JsonObject) {
        object.forEach { key, value in
            params[key] = value
        }
    }
    
    func setViewModel(_ vm: BaseViewModel) {
        params[VIEW_MODEL] = vm
        observeViewModel()
    }
    
    func getViewModel<VM: BaseViewModel>() -> VM? {
        params[VIEW_MODEL] as? VM
    }
}

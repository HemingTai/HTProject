//
//  Combine+Extension.swift
//  HTProject
//
//  Created by Hem1ngT4i on 2025/3/12.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

extension Publisher where Self.Failure == Never {
    func observe(_ holder: ObserverHolder, valueUpdateListener: @escaping (Self.Output) -> Void) {
        holder.cancellableSet.insert(receive(on: RunLoop.main).eraseToAnyPublisher().sink(receiveValue: valueUpdateListener))
    }
}

protocol ObserverHolder: AnyObject {
    var cancellableSet: Set<AnyCancellable> { get set }
}

protocol LiveStateHolder: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}

extension LiveStateHolder {
    func liveStateOf<T>(_ value: T) -> LiveState<T> {
        LiveState(owner: self, value: value)
    }
}

//for UI
class LiveState<T> {
    @Published var value: T
    weak var holder: LiveStateHolder?
    private var cancellable: AnyCancellable?
    
    var binding: Binding<T> { Binding(get: { self.value}, set: { self.value = $0 })}
    
    fileprivate init(owner: LiveStateHolder, value: T) {
        self.holder = owner
        self.value = value
        cancellable = $value.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.holder?.objectWillChange.send()
            }
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

//for controller
class LiveData<T> {
    @Published var value: T?
    
    init(value: T? = nil) {
        self.value = value
    }
    
    func observe<Holder: ObserverHolder>(_ holder: Holder, _ valueUpdateListener: @escaping (T, Holder) -> Void) {
        weak var owner = holder
        let listener: (T?) -> Void = { v in
            if let value = v, let weakHolder = owner {
                DispatchQueue.main.async {
                    valueUpdateListener(value, weakHolder)
                }
            }
        }
        $value.observe(holder, valueUpdateListener: listener)
    }
}

class BaseViewModel: ObservableObject, LiveStateHolder, ObserverHolder, TaskScope {
    let jobs = Jobs()
    lazy var cancellableSet = Set<AnyCancellable>()
    
    deinit {
        cancellableSet.forEach { $0.cancel() }
        jobs.cancelAll()
    }
}

protocol ViewModelHolder: ObserverHolder {
    func getViewModel<VM: BaseViewModel>() -> VM?
}


@propertyWrapper
class InjectViewModel<VM: BaseViewModel> {
    private var viewModel: VM?
    
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    var wrappedValue: VM {
        get {
            fatalError("never reach here")
        }
        
        set {
            fatalError("never reach here")
        }
    }
    
    //_enclosingInstance instance: 封闭实例，即持有该包装器的对象
    //ReferenceWritableKeyPath<VC, VM>: 指向被包装属性的可写键路径
    //ReferenceWritableKeyPath<VC, P>: 指向包装器自身的可写键路径
    static subscript<VC: ViewModelHolder, P: InjectViewModel<VM>>(_enclosingInstance instance: VC, wrapped wrappedKeyPath: ReferenceWritableKeyPath<VC, VM>, storage storageKeyPath: ReferenceWritableKeyPath<VC, P>) -> VM {
        get {
            let wrapper = instance[keyPath: storageKeyPath]
            return wrapper.viewModel ?? (instance.getViewModel() as? VM).also { wrapper.viewModel = $0 }!
        }
        
        set {
            let wrapper = instance[keyPath: storageKeyPath]
            wrapper.viewModel = newValue
        }
    }
}

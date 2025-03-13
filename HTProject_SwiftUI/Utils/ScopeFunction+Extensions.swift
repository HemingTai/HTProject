//
//  ScopeFunction+extensions.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2022/7/21.
//  Copyright © 2022 Hem1ngT4i. All rights reserved.
//

import Foundation

protocol ScopeFunction {}

extension ScopeFunction {
    
    @inline(__always) func also(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    @inline(__always) func takeIf(_ closure: (Self) -> Bool) -> Self? {
        closure(self) ? self: nil
    }
}

extension Optional {
    
    @discardableResult
    @inline(__always) func `let`<T>(_ closure: (Wrapped) -> T?) -> T? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return closure(wrapped)
        }
    }
    
    @inline(__always) func also(_ closure: (Wrapped) -> Any) -> Wrapped? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            _ = closure(wrapped)
            return wrapped
        }
    }
    
    @inline(__always) func takeIf(_ closure: (Wrapped) -> Bool) -> Wrapped? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return closure(wrapped) ? wrapped : nil
        }
    }
}

extension Optional where Wrapped == String {
    
    /// A Boolean value indicating whether a string is nil or has no characters.
    var isNullOrEmpty: Bool {
        self.let { $0.isEmpty } ?? true
    }

    /// A Boolean value indicating whether a string is not nil and has characters.
    var isNotEmpty: Bool {
        self.let { !$0.isEmpty } ?? false
    }
}

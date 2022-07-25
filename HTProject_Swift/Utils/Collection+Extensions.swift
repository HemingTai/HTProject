//
//  Collection+Extensions.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2021/1/25.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import Foundation

extension Array {
    
    var isNotEmpty: Bool { count > 0 }
    
    func toDictionary<Key: Hashable>(keyFunc: (Element) -> Key?) -> [Key: Element] {
        var dict = [Key: Element]()
        forEach {
            if let key = keyFunc($0) {
                dict[key] = $0
            }
        }
        return dict
    }
    
    func toDictionary<Key: Hashable, T>(entry: (Element) -> (key: Key?, value: T?)) -> [Key: T] {
        var dict = [Key: T]()
        forEach {
            let entryElement = entry($0)
            if let key = entryElement.key, let value = entryElement.value {
                dict[key] = value
            }
        }
        return dict
    }
    
    func toString(separator: String = ",", elementToStringFunction closure: (Element) -> String) -> String {
        map(closure).joined(separator: separator)
    }
    
    func subArray(start: Int = 0, end: Int? = nil) -> [Element] {
        var end = end ?? count - 1
        if end >= count {
            end = count - 1
        }
        if start >= count || start >= end {
            return []
        }
        return Array(self[start...end])
    }
    
    func subArray(start: Int = 0, length: Int? = nil) -> [Element] {
        let length = length ?? count - 1
        if start >= count || length <= 0 {
            return []
        }
        let end = start + length
        return subArray(start: start, end: end)
    }
    
    func distinct<Key: Hashable>(keyFunc: (Element) -> Key) -> [Element] {
        var result = [Element]()
        var resultSet = Set<Key>()
        forEach {
            if !resultSet.contains(keyFunc($0)) {
                resultSet.insert(keyFunc($0))
                result.append($0)
            }
        }
        return result
    }
    
    mutating func removeFirst(where predictFunc: (Element) -> Bool) -> Bool {
        if let index = self.firstIndex(where: predictFunc) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    mutating func removeAll(where predictFunc: (Element) -> Bool) -> Bool {
        var result = false
        while let index = self.firstIndex(where: predictFunc) {
            self.remove(at: index)
            result = true
        }
        return result
    }
    
}

extension Dictionary {
    
    mutating func merge(array: [Value], keyFunc: (Value) -> Key?) {
        array.forEach {
            if let key = keyFunc($0) {
                self[key] = $0
            }
        }
    }
    
    mutating func merge(_ other: [Key: Value]) {
        self.merge(other) { $1 }
    }
    
    func containsKey(_ key: Key) -> Bool {
        self.keys.contains(key)
    }
    
    func toArray() -> [Value] {
        self.compactMap { $1 }
    }
    
    func get<T>(_ propertyName: Key, defaultValue: T) -> T {
        self[propertyName] as? T ?? defaultValue
    }
}

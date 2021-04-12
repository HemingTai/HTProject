//
//  Operator+Extensions.swift
//  HTProject_Swift
//
//  Created by Hem1ngT4i on 2021/1/25.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import Foundation

// ------ for Dictionary --------
// [K:V] += [K:V] ==> merge in left
func +=<KeyType, ValueType>(left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    left.merge(right)
}

// [K:V] += (K,V) ==> merge in left
func +=<KeyType, ValueType>(left: inout [KeyType: ValueType], right: (KeyType, ValueType)) {
    left += [right.0: right.1]
}

// [K:V] + [K:V] ==> combine to new [K:V]
func +<KeyType, ValueType>(left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var result = [KeyType: ValueType]()
    result += left
    result += right
    return result
}

// [K:V] + (K,V) ==> combine to new [K:V]
func +<KeyType, ValueType>(left: [KeyType: ValueType], right: (KeyType, ValueType)) -> [KeyType: ValueType] {
    var result = [KeyType: ValueType]()
    result += left
    result += [right.0: right.1]
    return result
}

// [K:V] -= K ==> remove in left
func -=<KeyType, ValueType>(left: inout [KeyType: ValueType], right: KeyType) {
    left.removeValue(forKey: right)
}

// [K:V] -= [K:V] ==> remove in left
func -=<KeyType, ValueType>(left: inout [KeyType: ValueType], right: [KeyType: ValueType]) {
    right.keys.forEach { left -= $0 }
}

// [K:V] - [K:V] ==> reduce in new [K:V]
func -<KeyType, ValueType>(left: [KeyType: ValueType], right: [KeyType: ValueType]) -> [KeyType: ValueType] {
    var result = left
    result -= right
    return result
}

// [K:V] - K ==> reduce in new [K:V]
func -<KeyType, ValueType>(left: [KeyType: ValueType], right: KeyType) -> [KeyType: ValueType] {
    var result = left
    result -= right
    return result
}

// ------ for Array --------
// [E] += E ==> merge in left
func +=<Element>(left: inout [Element], right: Element) {
    left.append(right)
}

// [E] += [E] ==> merge in left
func +=<Element>(left: inout [Element], right: [Element]) {
    right.forEach { left += $0 }
}

// [E] + E ==> append to left
func +<Element>(left: [Element], right: Element) -> [Element] {
    var result = left
    result += right
    return result
}

// [E] -= E ==> remove in left
func -=<Element: Equatable>(left: inout [Element], right: Element) {
    let _ = left.removeFirst { $0 == right }
}

// [E] -= [E] ==> remove in left
func -=<Element: Equatable>(left: inout [Element], right: [Element]) {
    right.forEach { left -= $0 }
}

// [E] - E ==> reduce in new [E]
func -<Element: Equatable>(left: [Element], right: Element) -> [Element] {
    var result = left
    result -= right
    return result
}

// [E] - [E] ==> reduce in new [E]
func -<Element: Equatable>(left: [Element], right: [Element]) -> [Element] {
    var result = left
    result -= right
    return result
}

// [E] -= E ==> remove in left
func -=<Element: AnyObject>(left: inout [Element], right: Element) {
    let _ = left.removeFirst { $0 === right }
}

// [E] - E ==> reduce in new [E]
func -<Element: AnyObject>(left: [Element], right: Element) -> [Element] {
    var result = left
    result -= right
    return result
}

// ------ for Set --------
// Set<E> += E ==> merge in left
func +=<Element>(left: inout Set<Element>, right: Element) {
    left.insert(right)
}

// Set<E> += [E] ==> merge in left
func +=<Element>(left: inout Set<Element>, right: [Element]) {
    right.forEach { left += $0 }
}

// Set<E> += Set<E> ==> merge in left
func +=<Element>(left: inout Set<Element>, right: Set<Element>) {
    right.forEach { left += $0 }
}

// Set<E> += E ==> combine to new Set[E]
func +<Element>(left: Set<Element>, right: Element) -> Set<Element> {
    var result = left
    result += right
    return result
}

// Set<E> += [E] ==> combine to new Set[E]
func +<Element>(left: Set<Element>, right: [Element]) -> Set<Element> {
    var result = left
    result += right
    return result
}

// Set<E> += [E] ==> combine to new Set[E]
func +<Element>(left: Set<Element>, right: Set<Element>) -> Set<Element> {
    var result = left
    result += right
    return result
}

// Set<E> -= E ==> remove in left
func -=<Element>(left: inout Set<Element>, right: Element) {
    left.remove(right)
}

func -<Element>(left: Set<Element>, right: Element) -> Set<Element> {
    var result = left
    result -= right
    return result
}

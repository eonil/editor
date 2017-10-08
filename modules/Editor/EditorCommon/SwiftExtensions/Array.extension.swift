//
//  Array.extension.swift
//  Editor
//
//  Created by Hoon H. on 2017/06/16.
//  Copyright © 2017 Eonil. All rights reserved.
//

public extension Array {
    @discardableResult
    public mutating func removeFirstIfAvailable() -> Element? {
        guard isEmpty == false else { return nil }
        return removeFirst()
    }
}
public extension Array where Element: AnyObject {
    ///
    /// Removes first discovered designated object.
    ///
    public mutating func removeFirst(_ object: Element) {
        if let i = index(where: { o in o === object }) {
            remove(at: i)
        }
    }
}
public extension Array where Element: Equatable {
    ///
    /// Removes first discovered designated object.
    ///
    public mutating func removeFirst(_ object: Element) {
        if let i = index(where: { o in o == object }) {
            remove(at: i)
        }
    }
}

//
//  SwiftExtensions.swift
//  Editor6
//
//  Created by Hoon H. on 2017/03/04.
//  Copyright © 2017 Eonil. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    mutating func remove(_ element: Element) {
        for i in (startIndex..<endIndex).reversed() {
            if self[i] === element {
                remove(at: i)
                return
            }
        }
        fatalError("Couldn't find the element.")
    }
}

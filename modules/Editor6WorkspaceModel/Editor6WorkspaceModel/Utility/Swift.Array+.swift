//
//  Swift.Array+.swift
//  Editor6WorkspaceModel
//
//  Created by Hoon H. on 2016/10/22.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

extension Array where Element: AnyObject {
    func index(of element: Element) -> Index? {
        return index { (e: Iterator.Element) -> Bool in
            return e === element
        }
    }
    mutating func remove(_ element: Element) {
        guard let i = index(of: element) else { fatalError("The element cannot be found in this array.") }
        remove(at: i)
    }
}

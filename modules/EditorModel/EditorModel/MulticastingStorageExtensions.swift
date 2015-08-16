//
//  MulticastingStorageExtensions.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage

public extension ArrayStorage where T: AnyObject {
	public func contains(value: T) -> Bool {
		for atom in array {
			if atom === value {
				return	true
			}
		}
		return	false
	}
}

extension MutableArrayStorage {
	func append(value: T) {
		insert([value], atIndex: array.count)
	}
	func extend(values: [T]) {
		insert(values, atIndex: array.count)
	}
	func removeAll() {
		delete(0..<array.count)
	}
}
extension MutableArrayStorage where T: AnyObject {
	func removeFirstMatchingObject(value: T) {
		for i in 0..<array.count {
			let	atom	=	array[i]
			if atom === value {
				delete(i...i)
				return
			}
		}
		fatalError("Could not find the value from this storage. self.array = `\(self.array)`")
	}
}
//
//  MulticastingStorageExtensions.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage

extension MutableArrayStorage {
	func append(value: T) {
		insert([value], atIndex: array.count)
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
		fatalError("Could not find the value from this storage.")
	}
}
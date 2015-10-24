//
//  SwiftExtensions.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/08/16.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public extension Indexable {
	/// Returns `startIndex..<endIndex`.
	var wholeRange: Range<Index> {
		get {
			return	startIndex..<endIndex
		}
	}
}

public extension Array where Element: AnyObject {
	public func containsValueByReferentialIdentity(object: Element) -> Bool {
		return	indexOfValueByReferentialIdentity(object) != nil
	}
	public func indexOfValueByReferentialIdentity(object: Element) -> Int? {
		for i in 0..<count {
			if self[i] === object {
				return	i
			}
		}
		return	nil
	}
}

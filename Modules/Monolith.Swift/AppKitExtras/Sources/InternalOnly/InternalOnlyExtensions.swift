//
//  InternalOnlyExtensions.swift
//  UIKitExtras
//
//  Created by Hoon H. on 11/26/14.
//
//

import Foundation

internal extension ArraySlice {
	var array:Array<Element> {
		get {
			return	Array(self)
		}
	}
}
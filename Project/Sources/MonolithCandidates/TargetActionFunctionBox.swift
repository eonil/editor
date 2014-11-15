//
//  TargetActionFunctionBox.swift
//  Editor
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


final class TargetActionFunctionBox : NSObject {
	private let			actionFunction:()->()
	init(_ actionFunction:()->()) {
		self.actionFunction		=	actionFunction
	}
	var action:Selector {
		get {
			return	"invokeActionFunction:"
		}
	}
	var function:()->() {
		get {
			return	actionFunction
		}
	}
	func invokeActionFunction(sender:AnyObject?) {
		actionFunction()
	}
}
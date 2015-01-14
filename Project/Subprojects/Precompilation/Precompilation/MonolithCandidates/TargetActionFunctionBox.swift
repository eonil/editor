//
//  TargetActionFunctionBox.swift
//  Editor
//
//  Created by Hoon H. on 11/14/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


public final class TargetActionFunctionBox : NSObject {
	private let			actionFunction:()->()
	public init(_ actionFunction:()->()) {
		self.actionFunction		=	actionFunction
	}
	public var action:Selector {
		get {
			return	"invokeActionFunction:"
		}
	}
	public var function:()->() {
		get {
			return	actionFunction
		}
	}
	public func invokeActionFunction(sender:AnyObject?) {
		actionFunction()
	}
}
//
//  ShellConsuming.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

public protocol ModelConsumerProtocol: class {
	weak var model: Model? { get set }
}

///	Manages subconsumers and propagates shell object changes
///	to subconsumers automatically.
///
public protocol ModelConsumerNodeType: class, ModelConsumerProtocol {
	func registerShellConsumer(consumer: ModelConsumerProtocol)
	func deregisterShellConsumer(consumer: ModelConsumerProtocol)
}

public class ModelConsumerNode: ModelConsumerProtocol, ModelConsumerNodeType {
	public init() {
	}
	public weak var model: Model? {
		willSet {
			if let _ = model {
				for c in _consumers {
					assert(c is ModelConsumerProtocol)
					let	c	=	c as! ModelConsumerProtocol
					c.model		=	nil
				}
			}
		}
		didSet {
			if let model = model {
				for c in _consumers {
					assert(c is ModelConsumerProtocol)
					let	c	=	c as! ModelConsumerProtocol
					c.model		=	model
				}
			}
		}
	}
	public func registerShellConsumer(consumer: ModelConsumerProtocol) {
		assert(_consumers.contains(consumer) == false)
		_consumers.insert(consumer)
	}
	public func deregisterShellConsumer(consumer: ModelConsumerProtocol) {
		assert(_consumers.contains(consumer) == true)
		_consumers.remove(consumer)
	}

	///

	private var	_consumers	=	ObjectSet<AnyObject>()
}


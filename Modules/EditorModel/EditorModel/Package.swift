//
//  Package.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

///	A pakcage means single product.
public class Package {
	public var workspace: Workspace {
		get {
			return	owner!
		}
	}
	public var location: ValueStorage<NSURL>.Channel {
		get {
			return	WeakChannel(_location)
		}
	}
	
	///
	
	internal weak var owner: Workspace?
	
	internal init(location: NSURL) {
		_location		=	ValueStorage(location)
	}

	private let	_location	:	ValueStorage<NSURL>
	
}

extension Package {
	public class Target {
		public var project: Package {
			get {
				return	owner!
			}
		}
		
		///
		
		internal weak var owner: Package?
	}
}
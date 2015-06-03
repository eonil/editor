//
//  Ownee.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

internal protocol Ownee {
	typealias	Owner	:	AnyObject
	weak var	owner	:	Owner? { get set }
}
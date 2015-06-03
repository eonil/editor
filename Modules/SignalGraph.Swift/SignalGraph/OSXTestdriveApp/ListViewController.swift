//
//  ListViewController.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/24.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct ListColumn<T, V: NSView where V: DataPresentable, V.Data == T> {
	var	label		:	String
	var	instantiate	:	()->V
	var	reconfigure	:	(data: T, view: V)->()
}

class TableController<T, V: NSView where V: DataPresentable, V.Data == T> {
	typealias	Column	=	(
			lable		:	String,
			instantiate	:	()->V,
			reconfigure	:	(data: T, view: V)->()
	)
	

}
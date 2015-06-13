//
//  UIPalette.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

class UIPalette {
	var inspectorPaneDisplay: ValueStorage<Bool> {
		get {
			return	_inspectorPaneDisplay
		}
	}
	
	///
	
	private let	_inspectorPaneDisplay	=	EditableValueStorage<Bool>(false)
}
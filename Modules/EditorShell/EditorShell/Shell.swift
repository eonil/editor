//
//  Shell.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

///	Modeling of UI states and behaviors.
class Shell {
	
	let	navigatorPaneDisplay	=	ValueStorage<Bool>(false)
	let	consolePaneDisplay	=	ValueStorage<Bool>(false)
	let	inspectorPaneDisplay	=	ValueStorage<Bool>(false)
	
}
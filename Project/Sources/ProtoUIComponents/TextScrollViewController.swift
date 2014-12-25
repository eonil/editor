//
//  TextScrollViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class TextScrollViewController : ScrollViewController2 {
	var textViewController:TextViewController {
		get {
			return	super.documentViewController as TextViewController
		}
	}
//	@availability(*,unavailable)
//	override var documentViewController:NSViewController {
//		get {
//			return	super.documentViewController
//		}
//		set(v) {
//			precondition(v is TextViewController, "Only `TextViewController` family objects are accepted.")
//			super.documentViewController	=	v
//		}
//	}
	
	
	
	
	
	override func instantiateDocumentViewController() -> NSViewController {
		return	TextViewController()
	}
}

//extension TextScrollViewController {
//}
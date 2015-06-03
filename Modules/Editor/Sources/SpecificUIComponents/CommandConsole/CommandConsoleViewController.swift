//
//  CommandConsoleViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


class CommandConsoleViewController : TextViewController {
	override func viewDidAppear() {
		super.viewDidAppear()
		self.textView.font	=	Palette.current.codeFont
	}
}
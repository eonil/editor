//
//  Palette.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct Palette {
	static let	current	=	Palette()
	
	private init() {
	}
	
	let	codeFont	=	NSFont(name: "Menlo", size: NSFont.smallSystemFontSize())!
	
	
	
	
	
	
	
	struct Selectors {
		let	userIsWantingToSeeIssueLocation	=	"userIsWantingToSeeIssueLocation:" as Selector
	}
}
//
//  CandidateWindowController.swift
//  Editor
//
//  Created by Hoon H. on 2015/05/24.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class CandidateWindowController {
	
	init() {
		configureWindow()
	}
	var window: NSWindow {
		get {
			return	float
		}
	}
	
	///	MARK:	-	
	
	private let	float	=	NSWindow()
	private let	list	=	CandidateViewController()
	
	private func configureWindow() {
		float.styleMask		|=	NSResizableWindowMask
		float.styleMask		&=	~(NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask)
		float.contentView	=	list.view
	}
}
//
//  CandidateViewController.swift
//  Editor
//
//  Created by Hoon H. on 2015/05/24.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

class CandidateViewController {
	
	init() {
		scroll.documentView		=	table
		scroll.hasVerticalScroller	=	true
		table.setDataSource(agent)
		table.setDelegate(agent)
	}
	
	var view: NSView {
		get {
			return	table
		}
	}
	
	///	MARK:	-	
	
	private let	scroll	=	NSScrollView()
	private let	table	=	NSTableView()
	private let	agent	=	OBJCAgent()
}

private final class OBJCAgent: NSObject, NSTableViewDataSource, NSTableViewDelegate {
	
}
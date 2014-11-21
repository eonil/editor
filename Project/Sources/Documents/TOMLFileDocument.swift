//
//  TOMLFileDocument.swift
//  Editor
//
//  Created by Hoon H. on 11/15/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit


class TOMLFileDocument : NSDocument {
	
	override func makeWindowControllers() {
		super.makeWindowControllers()
	}
	
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		return	nil
	}
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		return	false
	}
	
	
	
	
	
	
	
	
	
	override class func autosavesInPlace() -> Bool {
		return false
	}
	
}
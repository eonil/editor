//
//  Issue.swift
//  EditorIssueListingFeature
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import EditorToolComponents




///	Issue origination can be missing on certain situations.
///	It's obviously not good, but it happens, and I have to deal with it.
public struct Issue {
	public var	origin:IssueOrigin?
	public var	severity:Severity
	public var	message:String
	
	public init(origination:IssueOrigin?, severity:Severity, message:String) {
//		assert(origination == nil || origination!.URL.existingAsDataFile == true, "`origination` must be `nil` or a proper URL (path to an existing file)")
		
		self.origin			=	origination
		self.severity		=	severity
		self.message		=	message
	}
	
	public enum Severity {
		case Information
		case Warning
		case Error
	}
}





public struct IssueOrigin {
	public var	URL:NSURL
	public var	range:CodeRange
	
	public init(URL:NSURL, range:CodeRange) {
		self.URL	=	URL
		self.range	=	range
	}
}










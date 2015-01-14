//
//  CodeFile.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


class CodeFile {
	init(_ url:NSURL) {
		_url	=	url
	}
	
	var locationURL:NSURL {
		get {
			return	_url
		}
	}
	
	///	Notifies this code file has been relocated to a URL.
	func relocateToURL(u:NSURL) {
		_url	=	u
	}
	
	private var	_url:NSURL
}

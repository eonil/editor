//
//  Command.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/05/25.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph


public class Executor {
	public init(_ repository: Repository) {
		self.repository		=	repository
	}
	
//	public func queue(s: Autocompletion.Signal) {
//		repository.autocompletion.queryImpl.signal(s)
//	}
	
	///	MARK:	-
	
	private let	repository	:	Repository
}




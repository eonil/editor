//
//  Model.swift
//  EditorToolComponents
//
//  Created by Hoon H. on 2015/05/25.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

public class Model {
	
	public init() {
	}

	public let	autocompletion	=	Autocompletion()

	///

	public class Autocompletion {
		public typealias	Query			=	(file: String, line: Int, column: Int)
		public typealias	Candidate		=	RacerExecutionController.Match
		
		public init() {
		}

		public var		candidates		:	ArrayStorage<Candidate>.Channel	{ get { return WeakChannel(_candidates) }}
		public var		cargoIsRunning		:	ValueStorage<Bool>.Channel	{ get { return WeakChannel(_cargoIsRunning) }}

		public func query(q: Query) {
			let	ms	=	racerController.resolve(q.file, line: q.line, column: q.column)
			_candidates.extend(ms)
		}
		
		///	

		private let		_candidates		=	ArrayStorage<Candidate>([])
		private let		_cargoIsRunning		=	ValueStorage<Bool>(false)
		private let		racerController		=	RacerExecutionController()
	}
}



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
	
	public class Autocompletion {
		public typealias	Query		=	(file: String, line: Int, column: Int)
		public typealias	Candidate	=	RacerExecutionController.Match
		
		public init() {
		}
		
		public func query(q: Query) {
			let	ms	=	racerController.resolve(q.file, line: q.line, column: q.column)
			candidatesStorage.extend(ms)
		}
		
		public var candidates: ArrayStorage<Candidate> {
			get {
				return	candidatesStorage
			}
		}
		
		public var cargoIsRunning: ValueStorage<Bool> {
			get {
				return	_cargoIsRunning;
			}
		}
		
		///	MARK:	-
		
		private let	candidatesStorage	=	EditableArrayStorage<Candidate>()
		private let	_cargoIsRunning		=	EditableValueStorage<Bool>(false);
		
		private let	racerController		=	RacerExecutionController()
	}
}

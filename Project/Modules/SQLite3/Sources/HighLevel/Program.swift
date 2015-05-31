//
//  Program.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/2/14.
//
//

import Foundation

public struct Program {
	let	database:Database
	let	midlevel:Statement
	
	public func execute() -> Execution {
		return	Execution(program: self, midlevel: midlevel.execute())
	}
	public func execute(parameters:[Value]) -> Execution {
		return	Execution(program: self, midlevel: midlevel.execute(parameters))
	}
	public func execute(parameters:[Query.ParameterValueEvaluation]) -> Execution {
		return	Execution(program: self, midlevel: midlevel.execute(parameters))
	}
}

public struct Execution {
	let	program:Program
	let	midlevel:Statement.Execution
	
	var	statement:Statement {
		get {
			return	program.midlevel
		}
	}
	
	///	Run all at once.
	///	The statement shouldn't produce any result.
	public func all() {
		midlevel.all()
	}
	
	///	Returns snapshot of all rows at once. You can call this only on fresh new `Execution`.
	///	Once started and unfinished execution cannot be used.
	///	If you want to avoid collecting of all rows, then you have to iterate this
	///	manually yourself.
	public func allArrays() -> [[Value]] {
		return	midlevel.allArrays()
	}
	
	///	Returns snapshot of all rows at once. You can call this only on fresh new `Execution`.
	///	Once started and unfinished execution cannot be used.
	///	If you want to avoid collecting of all rows, then you have to iterate this
	///	manually yourself.
	public func allDictionaries() -> [[String:Value]] {
		return	midlevel.allDictionaries()
	}
	
	public var arrayView:ArrayView {
		get {
			return	ArrayView(self)
		}
	}
	public var dictionaryView:DictionaryView {
		get {
			return	DictionaryView(self)
		}
	}
}





































extension Execution {
	///	Provides most essential data iteration.
	///	Shows only value part. You optionally can
	///	take column names.
	public final class ArrayView: SequenceType {
		let	execution:Execution
		init(_ x:Execution) {
			self.execution	=	x
			x.program.midlevel.step()
		}
		public lazy var columns:[String]	=	{
			var	cs	=	[] as [String]
			cs.reserveCapacity(self.execution.program.midlevel.numberOfFields)
			for i in 0..<self.execution.program.midlevel.numberOfFields {
				cs.append(self.execution.program.midlevel.columnNameAtIndex(i))
			}
			return	cs
			}()
		public func generate() -> GeneratorOf<[Value]> {
			let	s	=	execution.program.midlevel
			return	GeneratorOf {
				if s.running {
					var	a1	=	[] as [Value]
					s.numberOfFields >>>> a1.reserveCapacity
					for i in 0..<s.numberOfFields {
						s.columnValueAtIndex(i) >>>> a1.append
					}
					s.step()
					return	a1
				} else {
					return	nil
				}
			}
		}
	}
	
	///	Provides convenient dictionary form.
	public final class DictionaryView: SequenceType {
		let	execution:Execution
		private var _columns	=	nil as [String]?
		public var columns:[String] {
			get {
				return	_columns!
			}
		}
		init(_ x:Execution) {
			self.execution	=	x
			self.execution.program.midlevel.step()
			
			if self.execution.program.midlevel.running {
				var	cs	=	[] as [String]
				cs.reserveCapacity(self.execution.program.midlevel.numberOfFields)
				for i in 0..<self.execution.program.midlevel.numberOfFields {
					cs.append(self.execution.program.midlevel.columnNameAtIndex(i))
				}
				_columns	=	cs
			}
		}
		public func generate() -> GeneratorOf<[String:Value]> {
			let	s	=	self.execution.program.midlevel
			let	cs	=	_columns
			return	GeneratorOf {
				if s.running {
					var	d1	=	[:] as [String:Value]
					for i in 0..<s.numberOfFields {
						d1[cs![i]]	=	s.columnValueAtIndex(i)
					}
					s.step()
					return	d1
				} else {
					return	nil
				}
			}
		}
	}
}















































































//
//
//
//
//
//
//
//
//
//
//
//
//
/////	MARK:
/////	MARK:	Private Stuffs
//
//
//private func snapshotFieldNamesOfRow(r:Statement) -> [String] {
//	let	c	=	r.numberOfFields
//	var	m	=	[] as [String]
//	m.reserveCapacity(c)
//	for i in 0..<c {
//		m.append(r.columnNameAtIndex(i))
//	}
//	return	m
//	
//}
//private func snapshotFieldValuesOfRow(r:Statement) -> [Value] {
//	let	c	=	r.numberOfFields
//	var	m	=	[] as [Value]
//	m.reserveCapacity(c)
//	for i in 0..<c {
//		m.append(r.columnValueAtIndex(i))
//	}
//	return	m
//}
//private func snapshotFieldNamesAndValuesOfRow(r:Statement) -> [(String,Value)] {
//	let	c	=	r.numberOfFields
//	var	m	=	[] as [(String,Value)]
//	m.reserveCapacity(c)
//	for i in 0..<c {
//		m.append((r.columnNameAtIndex(i), r.columnValueAtIndex(i)))
//	}
//	return	m
//}
//private func snapshotRowAsDictionary(r:Statement) -> [String:Value] {
//	let	ks	=	snapshotFieldNamesOfRow(r)
//	let	vs	=	snapshotFieldValuesOfRow(r)
//	return	combine(ks, vs)
//}
//
//
//
//
//
//private struct StatementFieldValuesGenerator: GeneratorType {
//	unowned private let	s:Statement
//	
//	init(_ s:Statement) {
//		self.s	=	s
//	}
//	
//	func next() -> [Value]? {
//		if s.step() {
//			return	snapshotFieldValuesOfRow(s)
//		} else {
//			return	nil
//		}
//	}
//}
//
//
//
//
//





















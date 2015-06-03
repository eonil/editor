//
//  Statement.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation


///	MARK:
///	MARK:	Public Interfaces
///	MARK:

extension Statement {
	
}

///	MARK:	Introspection
extension Statement: Printable {
	public var description: String {
		get {
			return	"Statement(\(_core.sql()))"
		}
	}
}

///	MARK:	Execution Iteration
extension Statement {
	
	public func execute(parameters:[Value]) -> Execution {
		precondition(!running, "You cannot execute a statement which already started manual stepping.")
		precondition(_execution == nil || _execution!.running == false, "Previous execution of this statement-list is not finished. You cannot re-execute this statement-list until it once fully finished.")
		Debug.log("EonilSQLte3 executes: \(self), parameters: \(parameters)")
		
		self.reset()
		self.bind(parameters)
		
		let	x	=	Execution(self)
		_execution	=	x
		return	x
	}
	public func execute(parameters:[Query.ParameterValueEvaluation]) -> Execution {
		let	ps2	=	parameters.map {$0()}
		return	execute(ps2)
	}
	public func execute() -> Execution {
		return	execute([] as [Value])
	}
	
}



























///	MARK:
///	MARK:	Internal/Private Implementations
///	MARK:

///	Comments for Maintainers
///	------------------------
///	This can't be a `SequenceType`, but `GeneratorType` because
///	there's only one iteration context can be exist at once. It
///	is impossible to create multiple context from a statement.
///
///	You should keep `Statement` object alive while you're running 
///	an `Execution`. If the statement dies before the execution 
///	finishes, the program will crash. `Connection` object does not
///	retain the statement object, and you're responsible to keep
///	it alive.
public final class Statement {
	unowned let	connection:Connection
	
	init(connection:Connection, core:Core.Statement) {
		self.connection	=	connection
		
		_core	=	core
		_rowidx	=	-1
	}
	deinit {
		//	It's fine to deinitialise execution while running. SQLite3 handles them well.
		_core.finalize()
	}
	
	
	
	
	////
	
	private let	_core:Core.Statement
	private var	_rowidx:Int				///<	Counted for validation.
	
	private var _started	=	false
	private var _finished	=	false
	
	private var	_execution	=	nil as Execution?
	
}





extension Statement {
	
	var running:Bool {
		get {
			return	_started && !_finished
		}
	}
	func step() -> Bool {
		_started	=	true
		_rowidx++
		if _core.step() {
			return	true
		} else {
			_finished	=	true
			_execution	=	nil
			return	false
		}
	}
	func reset() {
		_started	=	false
		_finished	=	false
		_execution	=	nil
		
		_rowidx	=	-1
		_core.reset()
	}
	
	func bind(parameters:[Value]) {
		for i in 0..<parameters.count {
			let	v			=	parameters[i]
			let	(n1, f1)	=	Int.addWithOverflow(i, 1)
			precondition(f1 == false)
			precondition(IntMax(n1) < IntMax(Int32.max))
			let	n2			=	Int32(n1)
			
			switch v {
			case let Value.Null:		_core.bindNull(at: n2)
			case let Value.Integer(s):	_core.bindInt64(s, at: n2)
			case let Value.Float(s):	_core.bindDouble(s, at: n2)
			case let Value.Text(s):		_core.bindText(s, at: n2)
			case let Value.Blob(s):		_core.bindBytes(s, at: n2)
			}
		}
	}
	
}





























	













extension Statement {
	
	///	Set to `class` to prevent copying.
	public final class Execution {
		private unowned let	s:Statement		///<	Circularly retains `Statement` to keep the statement alive while this execution is running. This will be broke when the execution finishes.
		
		private init(_ statement:Statement) {
			s	=	statement
		}
		
		var statement:Statement {
			get {
				return	s
			}
		}
		var	running:Bool {
			get {
				return	statement.running
			}
		}
		
		///	Run all at once.
		///	The statement shouldn't produce any result.
		public func all() {
			precondition(statement._started == false, "You cannot call this method on once started execution.")
			while statement.step() {
				assert(statement.numberOfFields == 0, "This statement shouldn't produce any result columns.")
			}
		}
		
		///	Returns snapshot of all rows at once. You can call this only on fresh new `Execution`.
		///	Once started and unfinished execution cannot be used.
		///	If you want to avoid collecting of all rows, then you have to iterate this
		///	manually yourself.
		public func allArrays() -> [[Value]] {
			precondition(statement._started == false, "You cannot call this method on once started execution.")
			return	arrays().generate() >>>> collect
		}
		
		///	Returns snapshot of all rows at once. You can call this only on fresh new `Execution`.
		///	Once started and unfinished execution cannot be used.
		///	If you want to avoid collecting of all rows, then you have to iterate this
		///	manually yourself.
		public func allDictionaries() -> [[String:Value]] {
			precondition(statement._started == false, "You cannot call this method on once started execution.")
			return	dictionaries().generate() >>>> collect
		}
		
		///	Returns enumerable array view. Represents a row as an array of values. Only field values, no clumn names.
		public func arrays() -> ArrayView {
			return	ArrayView(statement)
		}
		
		///	Returns enumerable dictionary view. Represents a row as a dictionary of column names and field values.
		public func dictionaries() -> DictionaryView {
			return	DictionaryView(statement)
		}
	}
}




extension Statement.Execution {
	///	Provides most essential data iteration.
	///	Shows only value part. You optionally can
	///	take column names.
	public final class ArrayView: SequenceType {
		unowned let	statement:Statement
		init(_ s:Statement) {
			self.statement	=	s
			s.step()
		}
		public lazy var columns:[String]	=	{
			var	cs	=	[] as [String]
			cs.reserveCapacity(self.statement.numberOfFields)
			for i in 0..<self.statement.numberOfFields {
				cs.append(self.statement.columnNameAtIndex(i))
			}
			return	cs
		}()
		public func generate() -> GeneratorOf<[Value]> {
			let	s	=	statement
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
		unowned let	statement:Statement
		private var _columns	=	nil as [String]?
		public var columns:[String] {
			get {
				return	_columns!
			}
		}
		init(_ s:Statement) {
			self.statement	=	s
			statement.step()

			if statement.running {
				var	cs	=	[] as [String]
				cs.reserveCapacity(statement.numberOfFields)
				for i in 0..<self.statement.numberOfFields {
					cs.append(self.statement.columnNameAtIndex(i))
				}
				_columns	=	cs
			}
		}
		public func generate() -> GeneratorOf<[String:Value]> {
			let	s	=	statement
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
























extension Statement {
	
	var numberOfFields:Int {
		get {
			precondition(_core.dataCount().toIntMax() <= Int.max.toIntMax())
			return	Int(_core.dataCount())
		}
	}
	
	///	0-based indexing.
	subscript(index:Int) -> Value {
		get {
			return	index >>>> columnValueAtIndex
		}
	}
	subscript(column:String) -> Value? {
		get {
			for i in 0..<numberOfFields {
				let	n	=	columnNameAtIndex(i)
				if n == column {
					return	self[i]
				}
			}
			return	nil
		}
	}
	
	func columnNameAtIndex(index:Int) -> String {
		precondition(index.toIntMax() <= Int32.max.toIntMax())
		return	_core.columnName(Int32(index))
	}
	
	func columnValueAtIndex(index:Int) -> Value {
		precondition(_core.null == false)
		precondition(index < numberOfFields)
		
		let	idx2	=	Int32(index)
		let	t2		=	_core.columnType(idx2)
		
		if t2 == Core.ColumnTypeCode.null		{ return Value.Null }
		if t2 == Core.ColumnTypeCode.integer	{ return Value(_core.columnInt64(at: idx2)) }
		if t2 == Core.ColumnTypeCode.float		{ return Value(_core.columnDouble(at: idx2)) }
		if t2 == Core.ColumnTypeCode.text		{ return Value(_core.columnText(at: idx2)) }
		if t2 == Core.ColumnTypeCode.blob		{ return Value(_core.columnBlob(at: idx2)) }
		
		Core.Common.crash(message: "Unknown column type code discovered; \(t2)")
	}
	
}








































































///	MARK:
///	MARK:	Private Stuffs


private func snapshotFieldNamesOfRow(r:Statement) -> [String] {
	let	c	=	r.numberOfFields
	var	m	=	[] as [String]
	m.reserveCapacity(c)
	for i in 0..<c {
		m.append(r.columnNameAtIndex(i))
	}
	return	m
	
}
private func snapshotFieldValuesOfRow(r:Statement) -> [Value] {
	let	c	=	r.numberOfFields
	var	m	=	[] as [Value]
	m.reserveCapacity(c)
	for i in 0..<c {
		m.append(r.columnValueAtIndex(i))
	}
	return	m
}
private func snapshotFieldNamesAndValuesOfRow(r:Statement) -> [(String,Value)] {
	let	c	=	r.numberOfFields
	var	m	=	[] as [(String,Value)]
	m.reserveCapacity(c)
	for i in 0..<c {
		m.append((r.columnNameAtIndex(i), r.columnValueAtIndex(i)))
	}
	return	m
}
private func snapshotRowAsDictionary(r:Statement) -> [String:Value] {
	let	ks	=	snapshotFieldNamesOfRow(r)
	let	vs	=	snapshotFieldValuesOfRow(r)
	return	combine(ks, vs)
}





private struct StatementFieldValuesGenerator: GeneratorType {
	unowned private let	s:Statement
	
	init(_ s:Statement) {
		self.s	=	s
	}
	
	func next() -> [Value]? {
		if s.step() {
			return	snapshotFieldValuesOfRow(s)
		} else {
			return	nil
		}
	}
}










































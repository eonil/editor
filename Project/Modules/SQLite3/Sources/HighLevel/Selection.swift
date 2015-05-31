//
//  Section.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/1/14.
//
//

import Foundation

///	A subset data of a table.
///	This is an one-time-use-only class.
///	You can't reuse this object after you once consumed it.
public final class Selection {
	let	table:Table						///<	Source table.
	let	filter:Query.FilterTree
	
	init(table t:Table, filter f:Query.FilterTree) {
		self.table		=	t
		self.filter		=	f
		
	}
	
	func compile() -> Program {
		let	q	=	select(Query.Identifier(table.info.name), Query.ColumnList.All, filter)
		let	e	=	q.express()
		let	p	=	table.database.compile(e.code)
		return	p
	}
	
	public func sort(sortings:Query.SortingList) -> List {
		return	List(selection: self, sortings: sortings)
	}
}

public extension Selection {
	public func arrays() -> Execution.ArrayView {
		let	q	=	select(Query.Identifier(table.info.name), Query.ColumnList.All, filter)
		let	e	=	q.express()
		let	s	=	table.database.compile(e.code)
		let	x	=	s.execute(e.parameters)
		return	x.arrayView
	}
	public func dictionaries() -> Execution.DictionaryView {
		let	q	=	select(Query.Identifier(table.info.name), Query.ColumnList.All, filter)
		let	e	=	q.express()
		let	s	=	table.database.compile(e.code)
		let	x	=	s.execute(e.parameters)
		return	x.dictionaryView
	}
	
//	public func tuples() -> Selection.TupleView {
//		return	Selection.TupleView(statement)
//	}
//	public func dictionaries() -> Selection.DictionaryView {
//		return	Selection.DictionaryView(statement)
//	}
}













//extension Selection {
//	///	Provides most essential data iteration.
//	///	Shows only value part. You optionally can
//	///	take column names.
//	public final class TupleView: SequenceType {
//		unowned let	owner:Selection
//		
//		init(_ owner:Selection) {
//			self.owner	=	owner
//			owner.statement.step()
//		}
//		public var selection:Selection {
//			get {
//				return	owner
//			}
//		}
//		public lazy var columns:[String]	=	{
//			var	cs	=	[] as [String]
//			cs.reserveCapacity(self.owner.statement.numberOfFields)
//			for i in 0..<self.owner.statement.numberOfFields {
//				cs.append(self.owner.statement.columnNameAtIndex(i))
//			}
//			return	cs
//			}()
//		public func generate() -> GeneratorOf<[Value]> {
//			let	s	=	owner.statement
//			return	GeneratorOf {
//				if s.running {
//					var	a1	=	[] as [Value]
//					s.numberOfFields >>>> a1.reserveCapacity
//					for i in 0..<s.numberOfFields {
//						s.columnValueAtIndex(i) >>>> a1.append
//					}
//					s.step()
//					return	a1
//				} else {
//					return	nil
//				}
//			}
//		}
//	}
//	
//	///	Provides convenient dictionary form.
//	public final class DictionaryView: SequenceType {
//		unowned let	owner:Selection
//		
//		private var _columns	=	nil as [String]?
//		
//		init(_ owner:Selection) {
//			self.owner	=	owner
//			owner.statement.step()
//		}
//
//		public var selection:Selection {
//			get {
//				return	owner
//			}
//		}
//		public var columns:[String] {
//			get {
//				return	_columns!
//			}
//		}
//		init(_ s:Statement) {
//			self.statement	=	s
//			statement.step()
//			
//			if statement.running {
//				var	cs	=	[] as [String]
//				cs.reserveCapacity(statement.numberOfFields)
//				for i in 0..<self.statement.numberOfFields {
//					cs.append(self.statement.columnNameAtIndex(i))
//				}
//				_columns	=	cs
//			}
//		}
//		public func generate() -> GeneratorOf<[String:Value]> {
//			let	s	=	statement
//			let	cs	=	_columns
//			return	GeneratorOf {
//				if s.running {
//					var	d1	=	[:] as [String:Value]
//					for i in 0..<s.numberOfFields {
//						d1[cs![i]]	=	s.columnValueAtIndex(i)
//					}
//					s.step()
//					return	d1
//				} else {
//					return	nil
//				}
//			}
//		}
//	}
//}



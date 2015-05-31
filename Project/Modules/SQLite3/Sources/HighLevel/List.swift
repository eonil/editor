//
//  List.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/9/14.
//
//

import Foundation

///	An ordered list of a `Selection`.
public class List {
	let	selection:Selection
	let	sortings:Query.SortingList
	
	init(selection:Selection, sortings:Query.SortingList) {
		self.selection	=	selection
		self.sortings	=	sortings
	}
	
	public subscript() -> Page {
		get {
			return	self[0..<Int.max]
		}
	}
	
	///	:range:	Specify `LIMIT` and `OFFSET` in range form. `LIMIT` is `distance(range.startIndex, range.endIndex)`, and `OFFSET` is just `startIndex`.
	public subscript(range:Range<Int>) -> Page {
		get {
			let	limit	=	distance(range.startIndex, range.endIndex)
			let	offset	=	range.startIndex
			return	Page(list: self, limit: limit, offset: offset)
		}
	}
}

public extension List {
//	public func arrays() -> Statement.Execution.ArrayView {
//		let	q	=	select(Query.Identifier(table.info.name), Query.ColumnList.All, filter)
//		let	e	=	q.express()
//		let	s	=	table.database.compile(e.code)
//		let	x	=	s.execute(e.parameters)
//		return	x.arrays()
//	}
//	public func dictionaries() -> Statement.Execution.DictionaryView {
//		let	q	=	select(Query.Identifier(table.info.name), Query.ColumnList.All, filter)
//		let	e	=	q.express()
//		let	s	=	table.database.compile(e.code)
//		let	x	=	s.execute(e.parameters)
//		return	x.dictionaries()
//	}
}


///	A subset of an ordered list.
public struct Page {
	let	list:List
	let	limit:Int
	let	offset:Int
	
	public var arrayView:Execution.ArrayView {
		get {
			let	q	=	select(Query.Identifier(list.selection.table.name), Query.ColumnList.All, list.selection.filter, list.sortings, limit, offset)
			let	e	=	q.express()
			let	s	=	list.selection.table.database.compile(e.code)
			let	x	=	s.execute(e.parameters)
			return	x.arrayView
		}
	}
	public var dictionaryView:Execution.DictionaryView {
		get {
			let	q	=	select(Query.Identifier(list.selection.table.name), Query.ColumnList.All, list.selection.filter, list.sortings, limit, offset)
			let	e	=	q.express()
			let	s	=	list.selection.table.database.compile(e.code)
			let	x	=	s.execute(e.parameters)
			return	x.dictionaryView
		}
	}
}













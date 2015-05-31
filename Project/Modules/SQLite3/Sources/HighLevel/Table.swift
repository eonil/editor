//
//  Table.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 10/31/14.
//
//

import Foundation



///	A proxy for a name of a table.
///	Provides simple and convenient methods to get results easily on a single table.
///
///	Table is treated something like a dictionary with PK column (identity) and the
///	other columns (content). Only signle column PK is supported.
///
///	This proxy is linked by name, and metadata are cached. If you make any change on 
///	remote table in database, state of this object will be corrupted silently.
///	To prevent this situation, `Connection` object installs authoriser and crashs app
///	on any trial to change existing table while any `Table` object is alive.
///
public class Table {
	public typealias	Identity	=	Value
	public typealias	Content		=	[Value]

	unowned let owner:TableCollection
	let			database:Database			///<	Extend database lifecycle.
	
	let	info:Internals.TableInfo
	
	lazy var countRows:()->Int64								=	CommandMaker.makeCountRowsCommand(self)		///<	:returns:	Count of all rows in the table.
	lazy var selectRow:(identity:Identity)->Content?			=	CommandMaker.makeSelectRowCommand(self)		///<	:returns:	Only data fields. No key field.
	lazy var insertRow:(identity:Identity,content:Content)->()	=	CommandMaker.makeInsertRowCommand(self)		///<	:values:	Only data fields. No key field.
	lazy var deleteRow:(identity:Identity)->()					=	CommandMaker.makeDeleteRowCommand(self)
	
	init(owner:TableCollection, name:String) {
		self.owner		=	owner
		self.database	=	owner.database
		self.info		=	Internals.TableInfo.fetch(owner.database, tableName: name)
		
		self.owner.registerByBornOfTable(self)
	}
	deinit {
		self.owner.unregisterByDeathOfTable(self)
	}
}

extension Table {
//	public var database:Database {
//		get {
//			return	owner.database
//		}
//	}
	public var name:String {
		get {
			return	info.name
		}
	}
}

extension Table: SequenceType {
	public func generate() -> GeneratorOf<(Identity,Content)> {
		let	q	=	Query.Select(table: Query.Identifier(info.name), columns: Query.ColumnList.All, filter: nil, sorts: nil, limit: nil, offset: nil)
		let	p	=	database.compile(q.express().code)
		let	s	=	p.midlevel
		
		func next() -> (Identity,Content)? {
			if s.step() {
				let	r	=	s
				let	kvs	=	self.info.keyColumnIndexes().map {r[$0]}
				let	dvs	=	self.info.dataColumnIndexes().map {r[$0]}
				assert(kvs.count == 1)
				return	(kvs[0], dvs)
			} else {
				return	nil
			}
		}
		return	GeneratorOf<(Identity,Content)>(next)
	}
}

extension Table {

	public var count:Int {
		get {
			return	Int(countRows())
		}
	}
	
	public subscript(identity:Value) -> Content? {
		get {
			return	self.selectRow(identity: identity)
		}
		set(v) {
			self.deleteRow(identity: identity)
			if let v2 = v {
				self.insertRow(identity: identity, content: v2)
			}
		}
	}
	
	public subscript(identity:Int) -> Content? {
		get {
			return	self[Value(Int64(identity))]
		}
		set(v) {
			self[Value(Int64(identity))]	=	v
		}
	}
	public subscript(identity:Int64) -> Content? {
		get {
			return	self[Value(identity)]
		}
		set(v) {
			self[Value(identity)]	=	v
		}
	}
	public subscript(identity:String) -> Content? {
		get {
			return	self[Value(identity)]
		}
		set(v) {
			self[Value(identity)]	=	v
		}
	}
	
	
	public var keys:GeneratorOf<Identity> {
		get {
			var	g	=	generate()
			return	GeneratorOf<Identity> {g.next()?.0}
		}
	}
	public var values:GeneratorOf<Content> {
		get {
			var	g	=	generate()
			return	GeneratorOf<Content> {g.next()?.1}
		}
	}

}









///	MARK:
///	MARK:	Filtering
extension Table {

	public func filter(f:Query.FilterTree) -> Selection {
		return	Selection(table: self, filter: f)
	}
	
//	public func section(f:Query.FilterTree) -> Section {
//		return	Section(table: self, filter: f)
//	}
	
}




extension Table {
	public var dictionaryView:DictionaryView {
		get {
			return	DictionaryView(table: self)
		}
	}
}






































///	MARK:
///	MARK:	Private Features
///	MARK:

extension Table {
	private final class CommandMaker {
		
		class func makeCountRowsCommand(table:Table) -> ()->Int64 {
			return	{ [unowned table]()->Int64 in
				let	s	=	table.database.compile("SELECT count(*) FROM \(Query.Identifier(table.info.name).express().code)")
				
				return	table.database.apply {
					let	x	=	s.execute()
					let	rs	=	x.allDictionaries()
					assert(rs.count == 1)
					assert(rs[0].count == 1)
					let	r	=	rs[0]
//					let	v	=	r[r.startIndex]
//					return	v.1.integer!
					let	v	=	r.values.first!
					return	v.integer!
				}
			}
		}
		class  func makeSelectRowCommand(table:Table) -> (identity:Identity)->Content? {
			return	{ [unowned table](identity:Identity)->Content? in
				let	bs	=	combine(table.info.keyColumnNames(), [{identity}])
				let	dcs	=	table.info.dataColumnNames().map {Query.Identifier($0)}
				let	f	=	Query.FilterTree.allOfEqualColumnValues(bs)
				let	q	=	Query.Select(table: Query.Identifier(table.name), columns: Query.ColumnList.Items(names: dcs), filter: f, sorts: nil, limit: nil, offset: nil)
				let	s	=	table.database.compile(q.express().code)
				
				return	table.database.apply {
					let	rs	=	s.execute([identity]).allArrays()
					precondition(rs.count <= 1)
					return	rs.count == 0 ? nil : rs[0]
				}
			}
		}
		
		///	Inserts a row with all column values.
		class  func makeInsertRowCommand(table:Table) -> (identity:Identity, content:Content)->() {
			let	kcns	=	table.info.keyColumnNames()
			let	dcns	=	table.info.dataColumnNames()
			
			let	kbs		=	Query.Binding.bind(kcns, values: Array(count: kcns.count, repeatedValue: trapUndefinedParameter))
			let	dbs		=	Query.Binding.bind(dcns, values: Array(count: dcns.count, repeatedValue: trapUndefinedParameter))
			let	q		=	Query.Insert(table: Query.Identifier(table.name), bindings: kbs+dbs)
			let	e		=	q.express()
			let	s		=	table.database.compile(e.code)
			
			return	{ [unowned table](identity:Identity, content:Content)->() in
				assert(kcns.count == 1)					//	Parameter count must equal.
				assert(dcns.count == content.count)		//	Parameter count must equal.
				
				table.database.apply {					
					let	ps	=	[identity] + content
					s.execute(ps).all()
				}
			}
		}
		
		///	Deletes a row with PK columns.
		///	This method does not support generic filter. PK based selection only.
		///	TODO:	Keep a prepared statement.
		class  func makeDeleteRowCommand(table:Table) -> (identity:Identity)->() {
			let	kcns	=	table.info.keyColumnNames()
			let	bs		=	combine(kcns, [trapUndefinedParameter])
			let	f		=	Query.FilterTree.allOfEqualColumnValues(bs)
			let	q		=	Query.Delete(table: Query.Identifier(table.name), filter: f)
			let	e		=	q.express()
			let	p		=	table.database.compile(e.code)
			
			return	{ [unowned table](identity:Identity)->() in
				table.database.apply {
//					let	bs	=	combine(kcns, [identity])
//					let	f	=	Query.FilterTree.allOfEqualColumnValues(bs)
//					let	q	=	Query.Delete(table: Query.Identifier(table.name), filter: f)
//					let	rs	=	table.database.connection.run(q)
//					assert(rs.count == 0)
					
					p.execute([identity]).all()
				}
			}
		}
	}
	
}




private func trapUndefinedParameter() -> Value {
	trapError("This parameter shouldn't be used.")
}


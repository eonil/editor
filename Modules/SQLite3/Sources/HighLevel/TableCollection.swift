//
//  TableCollection.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 11/2/14.
//
//

import Foundation

///	`TableCollection` is a utility helper to iterate table.
///	Users are responsible to keep table object alive.
///	It keeps weak links to instantiated tables.
///	And use them to provide sole instance for same table name.
///	
///	DDL operations are not supported in this object. Schema 
///	must not be mutated while accessing data. 
///	See `Connection.schema` for that.
public final class TableCollection: SequenceType {
	unowned let	owner:Database
	
//	private var	_linkmap	=	[:] as [String:()->Table?]
	private var	_links	=	[] as [()->Table?]
	
	
	
	
	////
	
	init(owner:Database) {
		self.owner	=	owner
	}
	deinit {
		_assertNoDeadLinks()
		assert(_links.count == 0, "You're deinitialising a `TableCollection` (or `Database`) object while there're some live `Table` object. Kill the tables first before deinitialising `TableCollection` or `Database`.")
	}
	
	////
	
	public var database:Database {
		get {
			return	owner
		}
	}
	public func generate() -> GeneratorOf<Table> {
		_assertNoDeadLinks()
		
		let	rs	=	database.connection.prepare("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;").execute().allDictionaries()
		var	g1	=	rs.generate()
		return	GeneratorOf {
			if let r = g1.next() {
				let	n	=	r["name"]!
				return	Table(owner: self, name: n.text!)
			}
			return	nil
		}
	}
	public var count:Int {
		get {
			return	_countAllTablesInCurrentDatabase()
		}
	}
	public subscript(name:String) -> Table {
		get {
			_assertNoDeadLinks()
			let	t1	=	_findInLinksByName(name) ||| _makeAndLinkTableForNameIfExists(name)!
			return	t1
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	////
	
	internal var links:[()->Table?] {
		get {
			return	_links
		}
	}
	internal func registerByBornOfTable(t:Table) {
		_assertNoDeadLinks()
		
		_links.append(linkWeakly(t))
	}
	internal func unregisterByDeathOfTable(t:Table) {
		//	Weak references becomes nil before `deinit` of the object to be called.
		//	Then, just remove dead links like collecting garbages.
		
		_links	=	_links.filter {$0() != nil && $0()! !== t}
		
		_assertNoDeadLinks()
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	////
	
	private func _assertNoDeadLinks() {
		assert(_links.filter {$0() == nil}.count == 0, "We have some dead links to some `Table` objects. This shouldn't happen.")
	}
	
	private func _makeAndLinkTableForNameIfExists(name:String) -> Table? {
		let	ok	=	_checkTableExistenceOnDatabase(name)
		if ok {
			return	Table(owner: self, name: name)
		} else {
			return	nil
		}
	}
	private func _findInLinksByName(name:String) -> Table? {
		let	a	=	_links.filter {$0()!.info.name == name}
		assert(a.count <= 1)
		return	a.first?()
	}
	private func _checkTableExistenceOnDatabase(name:String) -> Bool {
		return	filter(_generateAllTableNamesInCurrentDatabase(), {$0 == name}).count > 0
	}
	private func _generateAllTableNamesInCurrentDatabase() -> GeneratorOf<String> {
//		let	rs	=	database.compile("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;").execute().allDictionaries()
		let	s	=	database.compile("SELECT name FROM sqlite_master WHERE type='table';")
		let	rs	=	s.execute().allDictionaries()
		var	g1	=	rs.generate()
		return	GeneratorOf {
			if let r = g1.next() {
				return	r["name"]!.text!
			}
			return	nil
		}
	}
	private func _countAllTablesInCurrentDatabase() -> Int {
		let	rs	=	database.compile("SELECT count(*) FROM sqlite_master WHERE type='table';").execute().allArrays()
		assert(rs.count == 1)
		let	r	=	rs[0]
		assert(r.count == 1)
		return	Int(r[0].integer!)
	}
}







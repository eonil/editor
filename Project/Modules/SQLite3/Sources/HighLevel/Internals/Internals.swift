//
//  Internals.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 10/31/14.
//
//

import Foundation

struct Internals {
}

///	Dirty stuffs for quick implementation.
extension Internals {
	
	struct TableInfo {
		unowned let	database:Database
		
		let	name:String
		let	columns:[ColumnInfo]		///<	All table related column stuffs will be ordered exactly same with this array.
		
		private init(database:Database, name:String) {
			let	rs:[[String:Value]]	=	database.apply {
				return	database.connection.run("PRAGMA table_info(\( Query.Identifier(name).express().code ))")
			}
			let	cs	=	rs.map {ColumnInfo($0)}
			
			self.database		=	database
			self.name			=	name
			self.columns		=	cs
			
			if Debug.mode {
				for i in 0..<cs.count {
					assert(IntMax(columns[i].cid) == IntMax(i))
				}
			}
		}
		
//		func keyColumn() -> ColumnInfo {
//			return	allColumns.filter {$0.pk}[0]
//		}
		func allColumns() -> [ColumnInfo] {
			return	columns
		}
		func keyColumns() -> [ColumnInfo] {
			return	allColumns().filter {$0.pk}
		}
		func dataColumns() -> [ColumnInfo] {
			return	allColumns().filter {$0.pk == false}
		}
		
//		func keyColumnName() -> String {
//			return	keyColumn().name
//		}
		func keyColumnNames() -> [String] {
			return	keyColumns().map {$0.name}
		}
		func dataColumnNames() -> [String] {
			return	dataColumns().map {$0.name}
		}
//		func keyColumnIndex() -> Int {
//			return	Int(keyColumn().cid)
//		}
		func keyColumnIndexes() -> [Int] {
			return	keyColumns().map {Int($0.cid)}
		}
		func dataColumnIndexes() -> [Int] {
			return	dataColumns().map {Int($0.cid)}
		}
		
//		func findColumnIndexForName(name:String) -> Int? {
//			return	find(columnNames(), name)
//		}
//		func findKeyColumnIndexForName(name:String) -> Int? {
//			return	find([keyColumnName()], name)
//		}
		func findKeyColumnIndexForName(name:String) -> Int? {
			return	find(keyColumnNames(), name)
		}
		func findDataColumnIndexForName(name:String) -> Int? {
			return	find(dataColumnNames(), name)
		}
		
		
		
		///	:tuple:	Must be ordered same as columns.
		func convertTupleToDictionary(tuple:[Value]) -> [String:Value]{
			assert(tuple.count == columns.count)
			var	d1	=	[:] as [String:Value]
			for i in 0..<columns.count {
				let	c	=	columns[i]
				d1[c.name]	=	tuple[i]
			}
			return	d1
		}
		///	:tuple:	Must be ordered same as columns.
		func convertTupleToDictionary(identity:[Value], _ content:[Value]) -> [String:Value]{
			var	a1	=	Array(count: columns.count, repeatedValue: Value.Null)
			for i in 0..<keyColumns().count {
				a1[convertInt64ToInt(keyColumns()[i].cid)]	=	identity[i]
			}
			for i in 0..<dataColumns().count {
				a1[convertInt64ToInt(dataColumns()[i].cid)]	=	content[i]
			}
			return	convertTupleToDictionary(a1)
		}
		
		func convertDictionaryToTuple(d1:[String:Value]) -> [Value] {
			///	Supplied dictionary may have less values then the data columns in the table.
			///	Missing columns will be filled as `NULL`.
			var	a1	=	Array(count: columns.count, repeatedValue: Value.Null)
			for c in columns {
				if let v1 = d1[c.name] {
					a1[convertInt64ToInt(c.cid)]	=	v1
				} else {
					//	Skip missing columns.
				}
			}
			return	a1
		}
		func convertDictionaryToKeyAndValueTuples(d1:[String:Value]) -> ([Value],[Value]) {
			let	a1	=	convertDictionaryToTuple(d1) as [Value]
			let	ks	=	keyColumns().map { (c:ColumnInfo)->Value in a1[self.convertInt64ToInt(c.cid)]}
			let	vs	=	dataColumns().map { (c:ColumnInfo)->Value in a1[self.convertInt64ToInt(c.cid)]}
			return	(ks,vs)
		}

		func convertInt64ToInt(v:Int64) -> Int {
			precondition(IntMax(Int.max) >= IntMax(v))
			return	Int(v)
		}
		
		////
		
		static func fetch(database:Database, tableName:String) -> TableInfo {
			return	TableInfo(database: database, name: tableName)
		}
	}
	
	struct ColumnInfo {
		let	cid:Int64				///<	Column index.
		let	name:String
		let	type:String?
		let	notNull:Bool			///<	`notnull` column.
		let	defaultValue:Value?		///<	`dflt_value` column.
		let	pk:Bool
		
		init(_ r:[String:Value]) {
			cid		=	r["cid"]!.integer!
			name	=	r["name"]!.text!
			type	=	r["type"]!.text!
			notNull	=	r["notnull"]!.integer! == 1
			defaultValue	=	r["dflt_value"]
			pk		=	r["pk"]!.integer! == 1
		}
	}

}





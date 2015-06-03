//
//  Query.Basic.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/16/14.
//
//

import Foundation

public extension Query
{
	
	
	
	
	///	Repesents SELECT statement.
	///
	///		SELECT * FROM "MyTable1"
	///		SELECT "col1", "col2", "col3" FROM "YourTable2"
	///
	public struct Select : QueryExpressible {
		static func all(of table:Identifier) -> Select {
			return	Select(table: table, columns: Query.ColumnList.All, filter: nil, sorts: nil, limit: nil, offset: nil)
		}
		
		public let	table:Identifier
		public let	columns:Query.ColumnList
		public let	filter:Query.FilterTree?
		public let	sorts:SortingList?
		public let	limit:Int?
		public let	offset:Int?

		public func express() -> Query.Expression{
			let	filt1	=	filter == nil ? Expression.empty : concat([expr("WHERE "), filter!.express()])
			let	sort1	=	sorts == nil ? Expression.empty : concat([expr("ORDER BY "), sorts!.express()])
			let	lim1	=	limit == nil ? Expression.empty : expr("LIMIT \(limit!)")
			let	off1	=	offset == nil ? Expression.empty : expr("OFFSET \(offset!)")
			return	[
				expr("SELECT"),
				columns.express(),
				expr(" "),
				expr("FROM"),
				table.express(),
				expr(" "),
				filt1,
				expr(" "),
				sort1,
				expr(" "),
				lim1,
				expr(" "),
				off1,
			] >>>> concat
		}
	}
	
	
	
	
	///	Represents INSERT statement.
	///
	///		INSERT INTO "MyTable1" ("col1", "col2", "col3") VALUES (@param1, @param2, @param3)
	///
	///	http://www.sqlite.org/lang_insert.html
	public struct Insert : QueryExpressible
	{
		public let	table:Identifier
		public let	bindings:[Query.Binding]
		
		public func express() -> Query.Expression
		{
			let	ns		=	bindings.map({ (n:Query.Binding) -> Expression in return n.column.express() })
			var	vs	=	[] as [ParameterValueEvaluation]
			for v in bindings {
				vs.append(v.value)
			}
			
			let	cols	=	Expression.concatenation(separator: expr(", "), components: ns)		///<	`col1, col2, col3, ...`
			let	params	=	Expression.ofParameterList(vs)										///<	`?, ?, ?, ...`
			
			return	[
				expr("INSERT INTO"),
				table.express(),
				expr("("),
				cols,
				expr(")"),
				expr(" VALUES"),
				expr("("),
				params,
				expr(")"),
			] >>>> concat
		}
	}
	
	///	Represents UPDATE statement.
	///
	///		UPDATE "MyTable1" SET "col1"=@param1, "col2"=@param2, "col3"=@param3 WHERE "col4"=@param4
	///
	///	http://www.sqlite.org/lang_update.html
	public struct Update : QueryExpressible
	{
		public let	table:Identifier
		public let	bindings:[Query.Binding]
		public let	filter:Query.FilterTree?
		
		public func express() -> Query.Expression
		{
			let	bs2	=	bindings.map({ u in return u.express() }) as [Query.Expression]
			let	bs3	=	Expression.concatenation(separator: expr(", "), components: bs2)

			Debug.log(bs2[0].code)
			Debug.log(bs2[0].parameters)
			Debug.log(bs3.code)
			return	[
				expr("UPDATE"),
				table.express(),
				expr(" SET "),
				bs3,
				expr(" WHERE "),
				(filter == nil ? expr("") : filter!.express()),
			] >>>> concat
		}
	}
	
	///	Represents DELETE statement.
	///	
	///		DELETE FROM "MyTable1" WHERE "col1"=@param1
	///
	public struct Delete : QueryExpressible
	{
		public let	table:Identifier
		public let	filter:Query.FilterTree
		
		public func express() -> Query.Expression
		{
			return	[
				expr("DELETE FROM"),
				table.express(),
				expr(" WHERE"),
				filter.express(),
			] >>>> concat
		}
	}

}





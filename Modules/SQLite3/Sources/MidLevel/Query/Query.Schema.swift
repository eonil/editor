//
//  Query.Schema.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/16/14.
//
//

import Foundation

public extension Query {
	
//	///	Queries all schematic informations from the database.
//	public struct Master {
//	}
	
	public struct Schema {
		public struct Table {
		}
	}
}














public extension Query.Schema.Table {
	public struct Create : QueryExpressible {
		public let	temporary:Bool
		public let	definition:Schema.Table
		
		
		
		
		
		
		public func express() -> Query.Expression {
			typealias	Column	=	Schema.Column
			
			func resolveColumnCode(c:Column) -> String {
				typealias	CDEF	=	Query.Language.Syntax.ColumnDef
				typealias	CC		=	Query.Language.Syntax.ColumnConstraint
				typealias	CCOPT	=	Query.Language.Syntax.ColumnConstraint.Option
				typealias	FX		=	Query.Language.Syntax.ConflictClause
				typealias	FXX		=	Query.Language.Syntax.ConflictClause.Reaction
				
				let	pk	=	self.definition.key.filter {$0 == c.name}.count > 0
				func resolveColumnDef() -> CDEF {
					func keyConstraints() -> [CC] {
						return	pk ? [
							CC(name: nil, option: CCOPT.PrimaryKey(ordering: nil, conflict: FX(reaction: nil), autoincrement: false)),
						] : []
					}
					func dataConstraints() -> [CC] {
						var	constraints:[CC]	=	[]
						if c.nullable == false {
							constraints	+=	[CC(name: nil, option: CCOPT.NotNull(conflict: FX(reaction: nil)))]
						}
						if c.unique == true {
							constraints	+=	[CC(name: nil, option: CCOPT.Unique(conflict: FX(reaction: nil)))]
						}
						return	constraints
					}
					return	CDEF(name: c.name, type: c.type, constraints: keyConstraints() + dataConstraints())
				}
				return	resolveColumnDef().description
			}
			
			let	ss1	=	definition.columns.map(resolveColumnCode)
			let	ss2	=	join(", ", ss1)
			
			return	[
				expr("CREATE "),
				expr((temporary ? "TEMPORARY " : "")),
				expr("TABLE "),
				Query.Expression(code: definition.name, parameters: []),
				expr("(\(ss2))"),
			] >>>> concat
		}
	}

	
	
	
	
	public struct Drop : QueryExpressible {
		public let	name:Query.Identifier
		public let	ifExists:Bool
		
		public func express() -> Query.Expression {
			return	[
				expr("DROP TABLE "),
				expr((ifExists ? " IF EXISTS " : " ")),
				name.express(),
			] >>>> concat
		}
	}
}














//
//  Query.Language.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/16/14.
//
//

import Foundation






extension Query {
	///	Provides strict SQL statement generation by language AST.
	///	Some elements are simplified or omitted because we don't need that level
	///	of accuracy or expressiveness.
	struct Language {
		struct Syntax {
		}
	}
}

///	Provides syntactic tree for code generation.
extension Query.Language.Syntax {
	typealias	Name			=	String
	typealias	CollateName		=	String
	typealias	TypeName		=	Schema.Column.TypeCode
	
//	struct Expression
//	{
//		
//	}
//	struct SignedNumber
//	{
//		
//	}
//	struct LiteralValue
//	{
//		
//	}

//	static func emptize<T>(value:T?) -> String {
//		return	value == nil ? "" : "\(value!)"
//	}
	
	struct ConflictClause : Printable {
		enum Reaction : String {
			case Rollback	=	"ROLLBACK"
			case Abort		=	"ABORT"
			case Fail		=	"FAIL"
			case Ignore		=	"IGNORE"
			case Replace	=	"REPLACE"
		}

		var	reaction:Reaction?
		
		var description:String {
			get {
				if let r1 = reaction {
					return	"ON CONFLICT \(r1.rawValue)"
				}
				return	""
			}
		}
	}
	
	
	
	
	
	///	http://www.sqlite.org/syntaxdiagrams.html#column-def
	struct ColumnDef : Printable {
		var	name:Name
		var	type:TypeName?
		var	constraints:[ColumnConstraint]
		
		var description:String {
			get {
				let	a1	=	constraints.map({ n in return n.description }) as [String]
				let	s2	=	type == nil ? "" : type!.rawValue
				let	s1	=	reduce(a1, "", +) as String
				return	"\(name) \(s2) \(s1)"
			}
		}
	}
	
	
	
	
	///	http://www.sqlite.org/syntaxdiagrams.html#column-constraint
	struct ColumnConstraint : Printable {
		var	name:Name?
		var	option:Option
		
		enum Option : Printable {
			case PrimaryKey(ordering:PrimaryKeyOrdering?, conflict:ConflictClause, autoincrement:Bool)
			case NotNull(conflict:ConflictClause)
			case Unique(conflict:ConflictClause)
//			case Check(expression:Expression)
//			case Default(option:DefaultOption)
			case Collate(name:CollateName)
			
			enum PrimaryKeyOrdering : String {
				case Ascending	=	"ASC"
				case Descending	=	"DESC"
			}
//			enum DefaultOption : String {
//				case SignedNumber(value:SignedNumber)
//				case LiteralValue(value:LiteralValue)
//				case Expression(value:Expression)
//			}
			
			var description:String {
				get {
					switch self {
						case .PrimaryKey(let value):
							let	s2	=	value.ordering == nil ? "" : "\(value.ordering!.rawValue)"
							let	s1	=	value.autoincrement ? "AUTOINCREMENT" : ""
							return	"PRIMARY KEY \(s2) \(value.conflict) \(s1)"
						
						case .NotNull(let conflict):
							return	"NOT NULL \(conflict)"
						
						case .Unique(let conflict):
							return	"UNIQUE \(conflict)"
						
						case .Collate(let name):
							return	"COLLATE \(name)"
					}
				}
			}
		}
		
		var description:String {
			get {
				let	s1	=	name == nil ? "" : ("CONSTRAINT \(name!)")
				return	"\(s1) \(option)"
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	///	http://www.sqlite.org/lang_savepoint.html
	struct SavepointStmt : Printable {
		var	name:String
		
		var description:String {
			get {
				return	"SAVEPOINT \(name)"
			}
		}
	}
	struct ReleaseStmt : Printable {
		var	name:String
		
		var description:String {
			get {
				return	"RELEASE SAVEPOINT \(name)"
			}
		}
	}
	struct RollbackStmt : Printable {
		var	name:String?
		
		var description:String {
			get {
				if name == nil {
					return	"ROLLBACK TRANSACTION"
				} else {
					return	"ROLLBACK TO SAVEPOINT \(name!)"
				}
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	///	http://www.sqlite.org/pragma.html
	struct Pragma : Printable {
		let	database:String?
		let	name:String
		let	argument:Argument
		
		enum Argument : Printable {
			case Set(value:String)		///<	Value assignment style pragma. `PRAGMA name1=value1`.
			case Call(value:String)		///<	Function call style pragma. `PRAGMA name1(value1)`.
			
			var description:String {
				get {
					switch self {
						case let .Set(value):
							return	"=\(value)"
						
						case let .Call(value):
							return	"(\(value))"
					}
				}
			}
		}
		
		var description:String {
			get {
				let	db	=	database == nil ? "" : (database! + ".")
				return	"PRAGMA \(db)\(name)\(argument)"
			}
		}
	}
	
	
}














//
//  Query.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation




///	Abstracts an object which can produce a fragment of a query statement.
public protocol QueryExpressible {
	func express() -> Query.Expression
}








///	Safely and easily generate SQL queries.
public struct Query {
	
	public typealias	ParameterValueEvaluation		=	()->Value
	
	
	
	
	

	///	Represents a fragment of a query.
	public struct Expression {
		let	code		:	String
		let	parameters	:	[ParameterValueEvaluation]
		
		static let	empty	=	Expression(code: "", parameters: [])
		
		////
		
		init(_ code:String) {
			self.init(code: code, parameters: [])
		}
		init(code:String, parameters:[ParameterValueEvaluation]) {
			self.code		=	code
			self.parameters	=	parameters
		}
		
		
//		public init(stringLiteral value: String) {
//			self	=	Expression(code: value, parameters: [])
//		}
//		public init(extendedGraphemeClusterLiteral value: String) {
//			self	=	Expression(code: value, parameters: [])
//		}
//		public init(unicodeScalarLiteral value: String) {
//			self	=	Expression(code: value, parameters: [])
//		}
		
		////
		
		static func ofParameterList(values:[ParameterValueEvaluation]) -> Expression {
			var	qs0	=	[] as [String]
			for _ in 0..<values.count {
				qs0.append("?")
			}
			let	qs2	=	join(", ", qs0)
			return	Expression(code: qs2, parameters: values)
		}
		static func concatenation(#separator:Expression, components:[Expression]) -> Expression {
			func add(left:Expression, right:Expression) -> Expression {
				return	Expression(code: left.code + right.code, parameters: left.parameters + right.parameters)
			}
			func add_with_sep(left:Expression, right:Expression) -> Expression {
				return	add(add(left, separator), right)
			}
			
			switch components.count {
			case 0:		return	Expression.empty
			case 1:		return	components.first!
			default:	return	components[1..<components.count].reduce(components.first!, combine: add_with_sep)
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	///	Represents names such as table or column.
	public struct Identifier : QueryExpressible, StringLiteralConvertible, Printable {
		public let	name:String
		
		public init(_ name:String) {
			assert(find(name, "\"") == nil, "Identifiers which contains double-quote(\") are not currently supported by Swift layer.")
			
			self.name	=	name
		}
		
		public init(stringLiteral value: String) {
			self	=	Identifier(value)
		}
		public init(extendedGraphemeClusterLiteral value: String) {
			self	=	Identifier(value)
		}
		public init(unicodeScalarLiteral value: String) {
			self	=	Identifier(value)
		}
		
		
		public var description:String {
			get {
				let		x1	=	"\"\(name)\""
				return	x1
			}
		}
		
		public func express() -> Query.Expression {
			return	Expression(code: description, parameters: [])
		}

		public static func convertFromStringLiteral(value: String) -> Identifier {
			return	Identifier(value)
		}
		
		public static func convertFromExtendedGraphemeClusterLiteral(value: String) -> Identifier {
			return	Identifier(value)
		}
	}
	
	public enum ColumnList : QueryExpressible {
		case All
		case Items(names:[Identifier])
		
		public func express() -> Query.Expression {
			//	Don't know why but this works only when order is reversed.
			//	Seemd to be a compiler bug.
			switch self {
			case let Items(s):	return	Expression.concatenation(separator: Query.Expression(", "), components: s.map {$0.express()})
			case let All:		return	Expression(code: "*", parameters: [])
			}
		}
	}
	
	///	Only for value setting expression.
	public struct Binding : QueryExpressible {
		public let	column:Identifier
		public let	value:ParameterValueEvaluation
		
		///	Makes `col1 = @param1` style expression.
		public func express() -> Query.Expression {
			return	[column.express(), Expression("="), Expression(code: "?", parameters: [value])] >>>> concat
		}
		
		init(column:Identifier, value:ParameterValueEvaluation) {
			self.column	=	column
			self.value	=	value
		}
		
		static func bind(names:[String], values:[ParameterValueEvaluation]) -> [Binding] {
			precondition(names.count == values.count)
			var	bs	=	[] as [Binding]
			for i in 0..<names.count {
				let	n	=	names[i]
				let	v	=	values[i]
				let	b	=	Binding(column: Identifier(n), value: v)
				bs.append(b)
			}
			return	bs
		}
	}
//	public struct BindingList : SubqueryExpressible
//	{
//		public let	items:[Binding]
//		
//		func express(uniqueParameterNameGenerator upng: Query.UniqueParameterNameGenerator) -> Query.Expression
//		{
//			return	Expression.expressionize(using: upng)(elements: items).concatenation()
//		}
//	}
	
	
	
	
	
	
	
	
	
	
	public struct FilterTree : QueryExpressible {
		public let	root:Node
		
		public init(root:Node) {
			self.root	=	root
		}
		
		public func express() -> Query.Expression {
			return	root.express()
		}
		
		////
		
		public enum Node : QueryExpressible {
			case Leaf(operation:Operation, column:Identifier, value:Query.ParameterValueEvaluation)
			case Branch(combination:Combination, subnodes:[Node])
			
			////
			
			public enum Operation : QueryExpressible {
				case Equal
				case NotEqual
				case LessThan
				case GreaterThan
				case EqualOrLessThan
				case EqualOrGreaterThan
//				case Between
//				case Like
//				case In
				
				public func express() -> Query.Expression {
					switch self {
						case .Equal:				return	Expression(code: "=", parameters: [])
						case .NotEqual:				return	Expression(code: "<>", parameters: [])
						case .LessThan:				return	Expression(code: "<", parameters: [])
						case .GreaterThan:			return	Expression(code: ">", parameters: [])
						case .EqualOrLessThan:		return	Expression(code: "<=", parameters: [])
						case .EqualOrGreaterThan:	return	Expression(code: ">=", parameters: [])
					}
				}
			}

			public enum Combination : QueryExpressible {
				case And
				case Or
				
				public func express() -> Query.Expression {
					switch self {
						case .And:	return	Expression(code: "AND", parameters: [])
						case .Or:	return	Expression(code: "OR", parameters: [])
					}
				}
			}
			
			public func express() -> Query.Expression {
				switch self {
				case let Leaf(operation: op, column: col, value: val):
					return	[col.express(), op.express(), Expression(code: "?", parameters: [val])] >>>> concat
				
				case let Branch(combination: comb, subnodes: ns):
					let	x1	=	[Expression(" "), comb.express(), Expression(" ")] >>>> concat
					return	Expression.concatenation(separator: x1, components: ns.map {$0.express()})
				}
			}
		}
		
	}
	
	
	
	
	
	
	
	
	public struct SortingList: QueryExpressible {
		public	var	items:[Item]
		
		public init(items:[Item]) {
			self.items	=	items
		}
		public func express() -> Query.Expression {
			return	Expression.concatenation(separator: Query.Expression(", "), components: items.map({$0.express()}))
		}
		
		public struct Item : QueryExpressible {
			public var	column:Identifier
			public var	order:Order
			
			public init(column:Identifier, order:Order) {
				self.column	=	column
				self.order	=	order
			}
			
			public func express() -> Query.Expression {
				return	Expression.concatenation(separator: Query.Expression.empty, components: [
					column.express(),
					Expression(" " + order.rawValue)
					])
			}
		}
		
		public enum Order : String {
			case Ascending	=	"ASC"
			case Descending	=	"DESC"
		}
	}
	
	
	
	
		
}






























///	MARK:	Convenient Filter Tree Generation
extension Query.FilterTree {
	static func allOfEqualColumnValues(cvs:[String:Query.ParameterValueEvaluation]) -> Query.FilterTree {
		var	ns	=	[] as [Node]
		for (c, v) in cvs {
			ns.append(Query.FilterTree.Node.Leaf(operation: Node.Operation.Equal, column: Query.Identifier(c), value: v))
		}
		let	n	=	Node.Branch(combination: Node.Combination.And, subnodes: ns)
		return	Query.FilterTree(root: n)
	}
	static func anyOfEuqlaColumnValues(cvs:[String:Query.ParameterValueEvaluation]) -> Query.FilterTree{
		var	ns	=	[] as [Node]
		for (c, v) in cvs {
			ns.append(Query.FilterTree.Node.Leaf(operation: Node.Operation.Equal, column: Query.Identifier(c), value: v))
		}
		let	n	=	Node.Branch(combination: Node.Combination.Or, subnodes: ns)
		return	Query.FilterTree(root: n)
	}
}
























func expr(s:String) -> Query.Expression {
	return	Query.Expression(s)
}

func concat(exprs:[Query.Expression]) -> Query.Expression {
	return	Query.Expression.concatenation(separator: Query.Expression(""), components: exprs)
}








private func missintParameter() -> Value {
	trapConvenientExtensionsError("Value for this parameter is intentionally missing. It must be provided later.")
}








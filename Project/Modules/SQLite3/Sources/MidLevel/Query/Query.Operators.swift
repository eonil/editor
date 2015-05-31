//
//  Query.Operators.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/16/14.
//
//

import Foundation





//public func +(left:Query.Expression, right:Query.Expression) -> Query.Expression {
//	return	Query.Expression(code: left.code + right.code, parameters: left.parameters + right.parameters)
//}
//public func +(left:Query.Expression, right:Query.Expression?) -> Query.Expression {
////	let	l2	=	left == nil ? Query.Expression.empty : left!
////	let	r2	=	right == nil ? Query.Expression.empty : right!
////	return	l2 + r2
//	return	right == nil ? left : (left + right!)
//}
//public func +(left:Query.Expression, right:String) -> Query.Expression
//{
//	return	left + Query.Expression(code: right, parameters: [])
//}
//public func +(left:String, right:Query.Expression) -> Query.Expression
//{
//	return	Query.Expression(code: left, parameters: []) + right
//}












public func &(left:Query.FilterTree.Node, right:Query.FilterTree.Node) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Branch(combination: Query.FilterTree.Node.Combination.And, subnodes: [left, right])
}
public func |(left:Query.FilterTree.Node, right:Query.FilterTree.Node) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Branch(combination: Query.FilterTree.Node.Combination.Or, subnodes: [left, right])
}

public func ==(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.Equal, column: left, value: { right })
}
public func !=(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.NotEqual, column: left, value: { right })
}
public func <(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.LessThan, column: left, value: { right })
}
public func >(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.GreaterThan, column: left, value: { right })
}
public func <=(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.EqualOrLessThan, column: left, value: { right })
}
public func >=(left:Query.Identifier, right:Value) -> Query.FilterTree.Node
{
	return	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.EqualOrGreaterThan, column: left, value: { right })
}

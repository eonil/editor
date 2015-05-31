////
////  Connection.CRUD.swift
////  EonilSQLite3
////
////  Created by Hoon H. on 11/1/14.
////
////
//
//import Foundation
//
//extension Connection {
//	
//	public func select(table:String, rowsWithAllOf pairs:[String:Value]) -> [[String:Value]] {
//		//		let	ss	=	splitPairs(pairs)
//		//		return	cacheableSelect(rowsWithAllOfColumns: ss.keys)(parameters: ss.values)
//		
//		let	t	=	filterTreeWith(samples: pairs, combinationStyle: Query.FilterTree.Node.Combination.And)
//		let	q	=	Query.Select(table: Query.Identifier(table), columns: Query.ColumnList.All, filter: t)
//		return	snapshot(query: q)
//	}
//	public func select(table:String, rowsWithAnyOf pairs:[String:Value]) -> [[String:Value]] {
//		//		let	ss	=	splitPairs(pairs)
//		//		return	cacheableSelect(rowsWithAnyOfColumns: ss.keys)(parameters: ss.values)
//		let	t	=	filterTreeWith(samples: pairs, combinationStyle: Query.FilterTree.Node.Combination.Or)
//		let	q	=	Query.Select(table: Query.Identifier(table), columns: Query.ColumnList.All, filter: t)
//		return	snapshot(query: q)
//	}
//	///	Selects all rows.
//	public func select(table:String) -> [[String:Value]] {
//		let	q	=	Query.Select(table: Query.Identifier(table), columns: Query.ColumnList.All, filter: nil)
//		return	snapshot(query: q)
//	}
//	
//	
//	
//	
//	
//	public func insert(table:String, rowWith pairs:[String:Value]) {
//		var	bs:[Query.Binding]	=	[]
//		for (c, v) in devaluate(pairs)
//		{
//			bs.append(Query.Binding(column: c, value: v))
//		}
//		let	q	=	Query.Insert(table: Query.Identifier(table), bindings: bs)
//		snapshot(query: q)
//	}
//	///	Performs multiple inserts.
//	///	Columns can different for all each rows.
//	///	So this performs slow insert. If you have rows for all same columns,
//	///	consider using `insertion` method
//	///	for better performance using prepared statement.
//	public func insert(table:String, rows:[[String:Value]]) {
//		for r in rows {
//			insert(table, rowWith: r)
//		}
//	}
//	
//	
//	
//	
//	
//	
//	
//	public func update(table:String, rowsWithAllOf existingPairs:[String:Value], bySetting newPairs:[String:Value])
//	{
//		let	t	=	filterTreeWith(samples: existingPairs, combinationStyle: Query.FilterTree.Node.Combination.And)
//		let	q	=	Query.Update(table: Query.Identifier(table), bindings: bindingsOf(paris: newPairs), filter: t)
//		snapshot(query: q)
//	}
//	public func update(table:String, rowsWithAnyOf existingPairs:[String:Value], bySetting newPairs:[String:Value])
//	{
//		let	t	=	filterTreeWith(samples: existingPairs, combinationStyle: Query.FilterTree.Node.Combination.Or)
//		let	q	=	Query.Update(table: Query.Identifier(table), bindings: bindingsOf(paris: newPairs), filter: t)
//		snapshot(query: q)
//	}
//	
//	
//	
//	
//	
//	
//	
//	public func delete(table:String, rowsWithAllOf pairs:[String:Value])
//	{
//		let	t	=	filterTreeWith(samples: pairs, combinationStyle: Query.FilterTree.Node.Combination.And)
//		let	q	=	Query.Delete(table: Query.Identifier(table), filter: t)
//		snapshot(query: q)
//	}
//	public func delete(table:String, rowsWithAnyOf pairs:[String:Value])
//	{
//		let	t	=	filterTreeWith(samples: pairs, combinationStyle: Query.FilterTree.Node.Combination.Or)
//		let	q	=	Query.Delete(table: Query.Identifier(table), filter: t)
//		snapshot(query: q)
//	}
//	
//	
//	
//	
//	
//	
//	
//	
//	
//	func snapshot(query q:QueryExpressible) -> [[String:Value]] {
//		return
//			apply { [unowned self] in
//				return	q >>>> self.run
//		}
//	}
//	
//	func bindingsOf(paris ps:[String:Value]) -> [Query.Binding] {
//		var	bs:[Query.Binding]	=	[]
//		for (c, v) in devaluate(ps)
//		{
//			bs.append(Query.Binding(column: c, value: v))
//		}
//		return	bs
//	}
//	
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//public extension Connection {
//	private func selection(table:String, mode m:Query.FilterTree.Node.Combination, filterColumns cs:[String]) -> (constraintValues:[Value]) -> [[String:Value]] {
//		let	cs2		=	parameterMappings(cs)
//		let	t		=	filterTreeWith(samples: cs2, combinationStyle: m)
//		let	q		=	Query.Select(table: Query.Identifier(table), columns: Query.ColumnList.All, filter: t)
//		let	x		=	q.express()
//		let	stmts	=	prepare(x.code)	//	Ignore the parameters. New one will be provided.
//		let	cc		=	cs.count
//		
//		return	{ [unowned self](parameters:[Value]) -> [[String:Value]] in
//			precondition(cc == parameters.count, "Parameter count doesn't match.")
//			return	self.apply { [unowned self] in
//				stmts.execute(parameters).allRowsAsDictionaries()
//			}
//		}
//	}
//	public func selection(table:String, valuesInColumns cs:[String]) -> (equalsTo:[Value]) -> [[String:Value]] {
//		return	selection(table, mode: Query.FilterTree.Node.Combination.And, filterColumns: cs)
//	}
//	
//	///	Optimised batched inserts.
//	///	This uses prepared statement.
//	///
//	///	:columns:	Column names for insertion.
//	///	:values:	A table of values for columns and rows to be inserted.
//	public func insertion(table:String, columns cs:[String]) -> (values:[[Value]]) -> () {
//		let	cs2		=	parameterMappings(cs)
//		let	bs		=	cs2.map { Query.Binding($0) }
//		let	q		=	Query.Insert(table: Query.Identifier(table), bindings: bs)
//		let	x		=	q.express()
//		let	stmt1	=	prepare(x.code)	//	Ignore the parameters. New one will be provided.
//		let	cc		=	cs.count
//		
//		return	{ [unowned self](vss:[[Value]])->() in
//			self.apply {
//				for vs1 in vss {
//					precondition(cc == vs1.count, "Parameter count doesn't match.")
//					stmt1.bind(vs1)
//				}
//			}
//		}
//	}
//	
//	
//	
//}
//
//
//private func parameterMappings(cs:[String]) -> [(column: Query.Identifier, value:Query.ParameterValueEvaluation)] {
//	var	m1	=	[] as [(column: Query.Identifier, value:Query.ParameterValueEvaluation)]
//	for i in 0..<cs.count {
//		let	v1	=	(column: Query.Identifier(cs[i]), value: Query.missingParameter)
//		m1.append(v1)
//	}
//	return	m1
//}
//
//private func devaluate(ss:[String:Value]) -> [(column:Query.Identifier, value:Query.ParameterValueEvaluation)] {
//	var	m2	=	[] as [(column:Query.Identifier, value:Query.ParameterValueEvaluation)]
//	for (k,v) in ss {
//		let	v1	=	(column: Query.Identifier(k), value: { v } as Query.ParameterValueEvaluation)
//		m2.append(v1)
//	}
//	return	m2
//}
//
//private func splitPairs <K,V> (dict1:[K:V]) -> (keys:[K], values:[V]) {
//	let	ns	=	[K](dict1.keys)
//	let	vs	=	[V](dict1.values)
//	return	(ns,vs)
//}
//
//
//
//
//
//
//
//
//
//
//private func filterTreeWith(samples ss:[(column:Query.Identifier, value:Query.ParameterValueEvaluation)], combinationStyle cs:Query.FilterTree.Node.Combination) -> Query.FilterTree {
//	var	ns	=	[] as [Query.FilterTree.Node]
//	for (c, v) in ss {
//		ns.append(Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.Equal, column: c, value: v))
//	}
//	let	n	=	Query.FilterTree.Node.Branch(combination: cs, subnodes: ns)
//	let	t	=	Query.FilterTree(root: n)
//	return	t
//}
//
//private func filterTreeWith(samples ss:[String:Value], combinationStyle cs:Query.FilterTree.Node.Combination) -> Query.FilterTree {
//	return	filterTreeWith(samples: devaluate(ss), combinationStyle: cs)
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

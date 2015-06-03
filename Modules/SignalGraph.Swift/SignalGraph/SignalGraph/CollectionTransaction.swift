//
//  CollectionTransaction.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/04/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//





///	Represents an atomic transaction.
///	Mutations are order-dependent to avoid diff cost and ambiguity.
///
///	DESIGN CONSIDERATIONS
///	---------------------
///	Each key and value are passed one by one. I also considered
///	passing `([K],[V])` instead of `(K,V)`, but it really has no benefit 
///	because keys are not guaranteed to be sorted efficiently for batch 
///	processing. Then one by one enumeration is unavoidable.
///	If you really need a sort of batch processing, you can set type `K`
///	and `V` to an appropriate type. For example, you can have `([Int],[String])`
///	typed transaction by setting `K` to `[Int]` and `V` to `[String]`.
///	Of course, making a processing node that supports such types is a different 
///	story. The point is, you can optionally promote this transaction type to a
///	batch processing type simply by setting each types to collection type while
///	reverse is impossible. This is why I chose non-collection type for passing
///	`K` and `V`.
///
///	:see:	Mutation
///			for more details.
public struct CollectionTransaction<K,V>: CollectionTransactionType {
	typealias	Key		=	K
	typealias	Value	=	V
	///	We can represent these four operations with two optional values.
	///
	///	-	Insert:		nil	-> T
	///	-	Update:		T0	-> T1
	///	-	Delete:		T	-> nil
	///
	///	As type `V` is not required to conform `Equatable`, we cannot detect
	///	equality of them, and always treats two values are different. Anyway
	///	implementations can detect and perform some optimization if they can
	///	detect equality themselves.
	///
	///	I also have tried `(K0,V0) -> (K1,V1)` form that expected
	///	to be able to present far more semantics. But it was not because,
	///	I could not find useful combination with different keys.
	///	See this.
	///
	///		-	K,nil	->	K,nil
	///		-	K0,nil	->	K1,nil
	///		-	K0,T0	->	K1,T1
	///		-	K0,T	->	K1,T
	///
	///	No valid operation can be defined for first two cases, so result
	///	undefined. Third case can be interpreted as delete & insert, but it just
	///	increases logical ambiguity and complexity with no noticeable advantage.
	///	Also, as type `V` does not require `Equatable`, there's no generic way 
	///	to detect equality of them at level of this class.
	///
	///	Last one can be interpreted as move, but meaning of key is ambiguous
	///	in order-dependent collections such as `Array`. Also as I noted above,
	///	we have no way to test value equality. 
	///
	///	If an implementation wants to handle movement, it can do it by detecting
	///	two consecutive mutations with equal values. (the implementation is 
	///	responsible to determine equality test)
	///
	///	I also considered using multiple sequence values like `[K],[V]`. But
	///	this was declined due to these reasons.
	///
	///	-	This framework focuses flexible and simple application data flow 
	///		rather than performance optimization.
	///
	///	-	If we really need it, we still can make it by seting `K` and `V` to 
	///		a desired collection type. Actually this is better because we can 
	///		use arbitrary collection type for our needs.
	///
	public typealias	Mutation	=	(identity: K, past: V?, future: V?)
	public var		mutations	:	[Mutation]
}

extension CollectionTransaction {
	static func insert(entry: (key: K, value: V)) -> CollectionTransaction {
		return	CollectionTransaction(mutations: [Primitives.insert(entry)])
	}
	static func update(entry: (key: K, from: V, to: V)) -> CollectionTransaction {
		return	CollectionTransaction(mutations: [Primitives.update(entry)])
	}
	static func delete(entry: (key: K, value: V)) -> CollectionTransaction {
		return	CollectionTransaction(mutations: [Primitives.delete(entry)])
	}
	
	static func insert(subsets: [(key: K, value: V)]) -> CollectionTransaction {
		return	CollectionTransaction(mutations: subsets.map(Primitives.insert))
	}
	static func update(subsets: [(key: K, from: V, to: V)]) -> CollectionTransaction {
		return	CollectionTransaction(mutations: subsets.map(Primitives.update))
	}
	static func delete(subsets: [(key: K, value: V)]) -> CollectionTransaction {
		return	CollectionTransaction(mutations: subsets.map(Primitives.delete))
	}
}

extension CollectionTransaction {
	///	Produces an inversion of this transaction.
	///	You can undo a transaction by applying a inversion if all operations on the 
	///	collection are commutative.
	func reverse() -> CollectionTransaction {
		func reverseMutationOf(m: Mutation) -> Mutation {
			return	(m.identity, m.future, m.past)
		}
		return	CollectionTransaction(mutations: Swift.reverse(mutations))
	}
}

private struct Primitives {
	static func insert<K,V>(t: (K,V)) -> CollectionTransaction<K,V>.Mutation {
		return	(t.0, nil, t.1)
//		return	(past: (t.0, nil), future: (t.0, t.1))
	}
	static func update<K,V>(t: (K,V,V)) -> CollectionTransaction<K,V>.Mutation {
		return	(t.0, t.1, t.2)
//		return	(past: (t.0, t.1), future: (t.0, t.2))
	}
	static func delete<K,V>(t: (K,V)) -> CollectionTransaction<K,V>.Mutation {
		return	(t.0, t.1, nil)
//		return	(past: (t.0, t.1), future: (t.0, nil))
	}
}








///	Non-commutative.
public func + <K,V> (a: CollectionTransaction<K,V>, b: CollectionTransaction<K,V>) -> CollectionTransaction<K,V> {
	return	CollectionTransaction(mutations: a.mutations + b.mutations)
}



public func == <K: Equatable,V: Equatable> (a: CollectionTransaction<K,V>, b: CollectionTransaction<K,V>) -> Bool {
	if a.mutations.count == b.mutations.count {
		for i in 0..<a.mutations.count {
			let	a1	=	a.mutations[i]
			let	b1	=	b.mutations[i]
			
			if a1.identity != b1.identity {
				return	false
			}
			if a1.past != b1.past {
				return	false
			}
			if a1.future != b1.future {
				return	false
			}
		}
	}
	return	true
}
public func == <K: Equatable> (a: CollectionTransaction<K,()>, b: CollectionTransaction<K,()>) -> Bool {
	if a.mutations.count == b.mutations.count {
		for i in 0..<a.mutations.count {
			let	a1	=	a.mutations[i]
			let	b1	=	b.mutations[i]
			
			if a1.identity != b1.identity {
				return	false
			}
		}
	}
	return	true
}



public func == <K: Equatable,V: Equatable> (a: CollectionTransaction<K,V>.Mutation, b: CollectionTransaction<K,V>.Mutation) -> Bool {
	return	a.identity == b.identity && a.past == b.past && a.future == b.future
}
public func == <K: Equatable> (a: CollectionTransaction<K,()>.Mutation, b: CollectionTransaction<K,()>.Mutation) -> Bool {
	return	a.identity == b.identity
}


























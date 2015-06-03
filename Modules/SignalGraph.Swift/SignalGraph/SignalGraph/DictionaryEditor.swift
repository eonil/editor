//
//  DictionaryEditor.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public struct DictionaryEditor<K: Hashable,V> {
	
	public unowned let	origin	:	ReplicatingDictionaryStorage<K,V>
	
	public init(_ origin: ReplicatingDictionaryStorage<K,V>) {
		self.origin		=	origin
	}
	
	public func initiate() {
		self.origin.sensor.signal(DictionarySignal.Initiation(snapshot: [:]))
	}
	public func terminate() {
		self.origin.sensor.signal(DictionarySignal.Termination(snapshot: origin.state))
	}
	
	////
	
	public var count: Int {
		get {
			return	origin.state.count
		}
	}
	public subscript(k: K) -> V? {
		get {
			return	origin.state[k]
		}
		set(v) {
			//	TODO:	Find out behavior in case of `v == nil`
			//			and define a proper behavior.
			assert(v != nil, "The value `v` should not be a `nil`. Operation is not defined yet.")
			if let _ = origin.state[k] {
				let	ms	=	[updateMutation(k, v!)]
				dispatchMutations(ms)
			} else {
				let	ms	=	[insertMutation(k, v!)]
				dispatchMutations(ms)
			}
		}
	}
	public mutating func removeValueForKey(k: K) -> V? {
		let	v	=	origin.state[k]
		let	ms	=	[deleteMutation(k)]
		dispatchMutations(ms)
		return	v
	}
	public mutating func removeAll() {
		origin.sensor.signal(DictionarySignal.Termination(snapshot: origin.state))
		origin.sensor.signal(DictionarySignal.Initiation(snapshot: [:]))
	}
	
	////
	
	private typealias	M	=	CollectionTransaction<K,V>.Mutation
	
	private func insertMutation(k: K, _ v: V) -> M {
		assert(self[k] == nil, "You cannot make an insert mutation for key `\(k)` because there's a value `\(self[k]!)` registered with the key.")
		return	M(k, nil, v)
	}
	private func updateMutation(k: K, _ v: V) -> M {
		assert(self[k] != nil, "You cannot make an update mutation for key `\(k)` because there's no value registered with the key.")
		return	M(k, self[k], v)
	}
	private func deleteMutation(k: K) -> M {
		assert(self[k] != nil, "You cannot make an delete mutation for key `\(k)` because there's no value registered with the key.")
		return	M(k, self[k], nil)
	}
	private func dispatchMutations(ms: [M]) {
		let	t	=	CollectionTransaction(mutations: ms)
		let	s	=	DictionarySignal.Transition(transaction: t)
		origin.sensor.signal(s)
	}
}
//
//  ArraySignalMap.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

///	Maps indexes and values of array mutation signal.
class ArraySignalMap<T,U>: SignalMap<ArraySignal<T>, ArraySignal<U>> {
	///	Maps only values. No changes in indexes.
	///	This is a kind of optimization.
	init(_ map: T -> U) {
		super.init({ (s: ArraySignal<T>) -> ArraySignal<U> in
			switch s {
			case .Initiation(let s):
				return	ArraySignal.Initiation(snapshot: s.map(map))
				
			case .Transition(let s):
				func mapMutation(m: (Int, T?, T?)) -> (Int, U?, U?) {
					func optionalMap(v: T?) -> U? {
						return	v == nil ? nil : map(v!)
					}
					return	(m.0, optionalMap(m.1), optionalMap(m.2))
				}
				let	ms	=	s.mutations.map(mapMutation) as [CollectionTransaction<Int,U>.Mutation]
				let	t	=	CollectionTransaction(mutations: ms)
				return	ArraySignal.Transition(transaction: t)
				
			case .Termination(let s):
				return	ArraySignal.Termination(snapshot: s.map(map))
			}
		})
	}
	
	///	**Not implemented yet**
	///
	///	Mapped array must build a completely sequential indexes.
	@availability(*,unavailable)
	init(_ map: (Int,T) -> (Int, U)) {
		fatalError("Not implemented yet.")
	}
}
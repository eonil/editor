//
//  ArraySignal.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/04/08.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



public enum ArraySignal<T> {
	public typealias	Snapshot	=	[T]
	public typealias	Transaction	=	CollectionTransaction<Array<T>.Index,T>
	case Initiation	(snapshot: Snapshot)
	case Transition	(transaction: Transaction)
	case Termination(snapshot: Snapshot)
}
extension ArraySignal {
	///	Applies mutations in this signal to an array.
	public func apply(inout a: [T]?) {
		switch self {
		case .Initiation(snapshot: let s):
			assert(a == nil, "Target array must be nil to apply initiation snapshot.")
			a	=	s
			
		case .Transition(transaction: let t):
			assert(a != nil)
			for m in t.mutations {
				switch (m.past != nil, m.future != nil) {
				case (false, true):
					//	Insert.
					a!.insert(m.future!, atIndex: m.identity)
					
				case (true, true):
					//	Update.
					a![m.identity]	=	m.future!
					
				case (true, false):
					//	Delete.
					a!.removeAtIndex(m.identity)
					
				default:
					fatalError("Unsupported combination.")
				}
			}
			
		case .Termination(snapshot: let s):
			assert(a != nil)
			assert(s.count == a!.count, "Current array must be equal to latest snapshot to apply termination.")
			a	=	nil
		}
	}
}







public func == <T: Equatable> (a: ArraySignal<T>, b: ArraySignal<T>) -> Bool {
	switch (a, b) {
	case (.Initiation(let a1), .Initiation(let b1)):		return	a1 == b1
	case (.Transition(let a1), .Transition(let b1)):		return	a1 == b1
	case (.Termination(let a1), .Termination(let b1)):		return	a1 == b1
	default:												return	false
	}
}


















//
//  ValueSignal.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public enum ValueSignal<T> {
	//	TODO:	Remove closure and convert into bare value
	//			after compiler support it.
	typealias	Snapshot	=	()->T
	case Initiation	(Snapshot)
	case Transition	(Snapshot)
	case Termination(Snapshot)
}


public func == <T: Equatable> (a: ValueSignal<T>, b: ValueSignal<T>) -> Bool {
	switch (a, b) {
	case (.Initiation(let a1), .Initiation(let b1)):		return	a1() == b1()
	case (.Transition(let a1), .Transition(let b1)):		return	a1() == b1()
	case (.Termination(let a1), .Termination(let b1)):		return	a1() == b1()
	default:												return	false
	}
}


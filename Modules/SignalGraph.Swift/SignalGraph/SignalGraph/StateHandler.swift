//
//  StateHandler.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



///	A simplified monitor host.
///	You can watch signals only you're interested in.
public class StateHandler<T> {
	
	public init() {
		monitor.handler	=	{ [unowned self] s in
			switch s {
			case .Initiation(let s):	self.onInitiation(s())
			case .Transition(let s):	self.onTransition(s())
			case .Termination(let s):	self.onTermination(s())
			}
		}
	}
	public var sensor: SignalSensor<ValueSignal<T>> {
		get {
			return	monitor
		}
	}
	
	public var	onInitiation:		((T)->())	=	NOOP
	public var	onTransition:		((T)->())	=	NOOP
	public var	onTermination:		((T)->())	=	NOOP
	
	public var	allHandlers:		(onInitiation: (T)->(), onTransition: (T)->(), onTermination: (T)->()) {
		get {
			return	(onInitiation, onTransition, onTermination)
		}
		set(v) {
			onInitiation		=	v.onInitiation
			onTransition		=	v.onTransition
			onTermination		=	v.onTermination
		}
	}
	
	////
	
	private let	monitor	=	SignalMonitor<ValueSignal<T>>()
}

private func NOOP<T>(T) {}


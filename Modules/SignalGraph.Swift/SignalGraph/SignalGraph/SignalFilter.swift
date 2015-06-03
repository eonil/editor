//
//  SignalFilter.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/08.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

class SignalFilter<T> {
	///	:param:		filter
	///			Returns `true` if the signal can be passed.
	///			Returns `false` if the signal should not be passed.
	///
	///	Though it is recommended to use referentially transparent function,
	///	you still can use referentially opaque function if you want because
	///	this object is intended to be used for state-less signal processing.
	///	Anyway, using of opaque function will make your processing network 
	///	opaque.
	init (_ filter: T->Bool) {
		self.filter		=	filter
		monitor.handler		=	{ [weak self] v in
			if self!.filter(v)  {
				self!.dispatcher.signal(v)
			}
		}
	}
	var sensor: SignalSensor<T> {
		get {
			return	monitor
		}
	}
	var emitter: SignalEmitter<T> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<T>({ _ in })
	private let	dispatcher	=	SignalDispatcher<T>()
	private let	filter		:	T->Bool
}
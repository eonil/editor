//
//  SignalMap.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/08.
//  Copyright (c) 2015 Eonil. All rights reserved.
//


class SignalMap<T,U> {
	init(_ map: T->U) {
		self.map		=	map
		monitor.handler	=	{ [weak self] v in
			self!.dispatcher.signal(self!.map(v))
		}
	}
	var	sensor: SignalSensor<T> {
		get {
			return	monitor
		}
	}
	var emitter: SignalEmitter<U> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<T>({ _ in })
	private let	dispatcher	=	SignalDispatcher<U>()
	private let	map			:	T->U
}
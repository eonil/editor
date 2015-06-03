//
//  Wait.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



///	Spawns an execution of asynchronous process function for its 
///	completion.
///	This accepts input `T`, and spawns an asynchronous operation
///	using specified function. Callback `U->()` will be called at
///	completion of the processing.
///
///	Note:	Processing doesn't define success or failure. Such 
///			result states need to be defined in the type `U`.
///
///	Signaling also can be asymmetric. Single input may generate
///	multiple outputs, and multiple input can be collapsed into 
///	single output. This is defined by function `process`.
///
///	Callback thread is also undefined. It is defined by the 
///	function `process`, and this object does not manage any 
///	thread stuffs at all. You're responsible to make thread 
///	stuffs to be fine.
///
public class Spawn<T,U> {
	public init(_ process: (T, U->()) -> ()) {
		self.process			=	process
		self.monitor.handler	=	{ [unowned self] s in self.spawn(s) }
	}
	
	public var	sensor: SignalSensor<T> {
		get {
			return	monitor
		}
	}
	public var	emitter: SignalEmitter<U> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private let	process		:	(T, U->()) -> ()
	private let	monitor		=	SignalMonitor<T>()
	private let	dispatcher	=	SignalDispatcher<U>()
	
	private func spawn(s: T) {
		process(s) { [unowned self] s in self.complete(s) }
	}
	
	private func complete(s: U) {
		dispatcher.signal(s)
	}
}






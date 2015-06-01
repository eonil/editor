//
//  ArrayStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//









private final class ArraySignalDispatcher<T>: SignalDispatcher<ArraySignal<T>> {
	weak var owner: ArrayStorage<T>?
	override func register(sensor: SignalSensor<ArraySignal<T>>) {
		Debugging.EmitterSensorRegistration.assertRegistrationOfStatefulChannelingSignaling((self, sensor))
		super.register(sensor)
		if let _ = owner!.values {
			sensor.signal(ArraySignal.Initiation(snapshot: owner!.state))
		}
	}
	override func deregister(sensor: SignalSensor<ArraySignal<T>>) {
		Debugging.EmitterSensorRegistration.assertDeregistrationOfStatefulChannelingSignaling((self, sensor))
		if let _ = owner!.values {
			sensor.signal(ArraySignal.Termination(snapshot: owner!.state))
		}
		super.deregister(sensor)
	}
}




///	A data store that provides signal emission but no mutators.
///
///	You should use one of subclasses.
///
public class ArrayStorage<T>: StorageType {
	public typealias	Element	=	T
	
	public var	state: [T] {
		get {
			assert(values != nil, "This storage has not been initiated or already terminated. You can initialize by sending `ArraySignal.Initiation` signal.")
			return	values!
		}
	}
	
	public var emitter: SignalEmitter<ArraySignal<T>> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private var	values		=	nil as [T]?
	
	private init() {
		dispatcher.owner	=	self
	}
	
	private let	dispatcher	=	ArraySignalDispatcher<T>()
}





///	A storage that provides indirect signal based mutator.
///
///	Initial state of a state-container is undefined, and you should not access
///	them while this contains is not bound to a signal source.
public class ReplicatingArrayStorage<T>: ArrayStorage<T>, ReplicationType {
	
	public override init() {
		super.init()
		monitor.handler	=	{ [unowned self] s in
			s.apply(&self.values)
			self.dispatcher.signal(s)
		}
	}
	
	public var sensor: SignalSensor<ArraySignal<T>> {
		get {
			return	monitor
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<ArraySignal<T>>({ _ in })
}


























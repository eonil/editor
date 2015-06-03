//
//  ValueStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//





private final class ValueSignalDispatcher<T>: SignalDispatcher<ValueSignal<T>> {
	weak var owner: ValueStorage<T>?

	override func register(sensor: SignalSensor<ValueSignal<T>>) {
		Debugging.EmitterSensorRegistration.assertRegistrationOfStatefulChannelingSignaling((self, sensor))
		super.register(sensor)
		if let s = owner!.value {
			sensor.signal(ValueSignal.Initiation({s}))
		}
	}
	override func deregister(sensor: SignalSensor<ValueSignal<T>>) {
		Debugging.EmitterSensorRegistration.assertDeregistrationOfStatefulChannelingSignaling((self, sensor))
		if let s = owner!.value {
			sensor.signal(ValueSignal.Termination({s}))
		}
		super.deregister(sensor)
	}
}

///	A read-only proxy view of a repository.
///
public class ValueStorage<T>: StorageType {
	public var state: T {
		get {
			return	value!
		}
	}
	
	public var emitter: SignalEmitter<ValueSignal<T>> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private let	dispatcher	=	ValueSignalDispatcher<T>()
	
	private init() {
		dispatcher.owner	=	self
	}
	
	private var	value: T? {
		didSet {
			let	v	=	value!
			let	s	=	ValueSignal.Transition({v})
			dispatcher.signal(s)
		}
	}
}







///	A mutable storage. Mutation can be performed by receiving mutation 
///	signals. So the sensor is the only mutator.
///
public class ReplicatingValueStorage<T>: ValueStorage<T>, ReplicationType {
	public override init() {
		super.init()
		self.monitor.handler	=	{ [unowned self] s in
			switch s {
			case .Initiation(let s):
				self.value		=	s()
			case .Transition(let s):
				self.value		=	s()
			case .Termination(_):
				self.value		=	nil
			}
		}
	}
	
	public var sensor: SignalSensor<ValueSignal<T>> {
		get {
			return	monitor
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<ValueSignal<T>>({ _ in })
}






///	Self-editable value-replication.
public class EditableValueStorage<T>: ReplicatingValueStorage<T> {
	public init(_ state: T) {
		super.init()
		super.sensor.signal(ValueSignal.Initiation({state}))
	}
	deinit {
		//	Do not send any signal.
		//	Because any non-strong reference to self is inaccessible here.
	}
	
	public override var state: T {
		get {
			return	super.state
		}
		set(v) {
			super.sensor.signal(ValueSignal.Transition({v}))
		}
	}
	
	@availability(*,unavailable)
	public override var sensor: SignalSensor<ValueSignal<T>> {
		get {
			fatalError("You cannot get sensor of this object. Replication from external emitter is prohibited.")
		}
	}
}





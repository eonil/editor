//
//  DictionaryStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/06.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

private final class DictionarySignalDispatcher<K: Hashable,V>: SignalDispatcher<DictionarySignal<K,V>> {
	weak var owner: DictionaryStorage<K,V>?
	override func register(sensor: SignalSensor<DictionarySignal<K,V>>) {
		Debugging.EmitterSensorRegistration.assertRegistrationOfStatefulChannelingSignaling((self, sensor))
		super.register(sensor)
		if let _ = owner!.pairs {
			sensor.signal(DictionarySignal.Initiation(snapshot: owner!.state))
		}
	}
	override func deregister(sensor: SignalSensor<DictionarySignal<K,V>>) {
		Debugging.EmitterSensorRegistration.assertDeregistrationOfStatefulChannelingSignaling((self, sensor))
		if let _ = owner!.pairs {
			sensor.signal(DictionarySignal.Termination(snapshot: owner!.state))
		}
		super.deregister(sensor)
	}
}

public class DictionaryStorage<K,V where K: Hashable>: StorageType {
	
	public var	state: [K:V] {
		get {
			return	pairs!
		}
	}
	
	public var emitter: SignalEmitter<DictionarySignal<K,V>> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private var	pairs		=	nil as [K:V]?
	
	private init() {
		dispatcher.owner	=	self
	}
	
	private let	dispatcher	=	DictionarySignalDispatcher<K,V>()
}

///	A storage that provides indirect signal based mutator.
///
///	Initial state of a state-container is undefined, and you should not access
///	them while this contains is not bound to a signal source.
public class ReplicatingDictionaryStorage<K,V where K: Hashable>: DictionaryStorage<K,V>, ReplicationType {
	
	public override init() {
		super.init()
		monitor.handler	=	{ [unowned self] s in
			s.apply(&self.pairs)
			self.dispatcher.signal(s)
		}
	}
	
	public var sensor: SignalSensor<DictionarySignal<K,V>> {
		get {
			return	monitor
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<DictionarySignal<K,V>>({ _ in })
}

























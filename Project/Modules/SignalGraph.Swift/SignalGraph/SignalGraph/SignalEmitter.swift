//
//  SignalEmitter.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//


public class SignalEmitter<T>: EmitterType {
	
	public func register(sensor: SignalSensor<T>) {
		self.registerImpl(sensor)
	}
	public func deregister(sensor: SignalSensor<T>) {
		self.deregisterImpl(sensor)
	}
	
	////
	
	typealias	In		=	()
	typealias	Out		=	T
	typealias	Signal	=	T
	
	func register<S: SensorType where S.Signal == Signal>(sensor: S) {
		registerImpl(sensor)
	}
	
	func deregister<S: SensorType where S.Signal == Signal>(sensor: S) {
		deregisterImpl(sensor)
	}
	
	////
	
	private typealias	Entry		=	(ref: ()->AnyObject, callSignal: T->())
	private var			sensors		=	[] as [Entry]
	
	private init() {
	}
	deinit {
		assert(sensors.count == 0, "You must deregister all sensors from this object before this object `deinit`ializes.")
	}
	private func signal(s: T) {
		for e in sensors {
			e.callSignal(s)
		}
	}
	private func registerImpl<S: SensorType where S.Signal == Signal>(sensor: S) {
		let	e	=	Entry(ref: { [weak sensor] in return sensor! }, callSignal: { [weak sensor] in sensor!.signal($0) })
		sensors.append(e)
	}
	
	private func deregisterImpl<S: SensorType where S.Signal == Signal>(sensor: S) {
		for i in reverse(0..<sensors.count) {
			let	e	=	sensors[i]
			if e.ref() === sensor {
				sensors.removeAtIndex(i)
				return
			}
		}
		fatalError("Could not find the sensor object `\(sensor)`. It's not on the registry.")
	}
}

public class SignalDispatcher<T>: SignalEmitter<T>, DispatcherType {
	public override init() {
		super.init()
	}
	public override func signal(s: T) {
		super.signal(s)
	}
}










































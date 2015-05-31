//
//  _junkyard.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/07.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

////public protocol UnicastingEmitterType {
////
////}
////public protocol MulticastingEmitterType {
////
////}
////
////public protocol UnicatchingSensorType {
////
////}
////public protocol MulticatchingSensorType {
////
////}
//
//
//
/////	An emitter that also supports channeling sensors as well
/////	as a non-channeling sensors.
//public protocol ChannelingEmitterType: EmitterType, AnyObject {
//	func register<T: ChannelingSensorType where T.Signal == Signal>(sensor: T)
//	func deregister<T: ChannelingSensorType where T.Signal == Signal>(sensor: T)
//}
//
/////	A sensor to receive state-ful signals.
/////	State-ful signal means signals are inter-dependent to each other
/////	to reconstruct desired state. Due to this requirements of state
/////	dependancy, this kind of sensors must observe only one emitter
/////	at a time.
/////
/////	In addition, the emitter must have a solid identity.
//public protocol ChannelingSensorType: SensorType {
//	///	The emitter notifies registration finished and this
//	///	sensor is going to receive signals from the emitter.
//	func subscribe(emitter: AnyObject)
//	///	The emitter notifies deregistration will occur and
//	///	this sensor is going to stop receiving signals from
//	///	the emitter.
//	func desubscribe(emitter: AnyObject)
//
////	///	The emitter notifies registration finished and this
////	///	sensor is going to receive signals from the emitter.
////	func subscribe<E: ChannelableEmitterType where E.Signal == Signal>(emitter: E)
////	///	The emitter notifies deregistration will occur and
////	///	this sensor is going to stop receiving signals from
////	///	the emitter.
////	func desubscribe<E: ChannelableEmitterType where E.Signal == Signal>(emitter: E)
//}
//










































//
//
////
////  ChannelingSignalSensor.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/06.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//public class ChannelingSignalSensor<T>: ChannelingSensorType {
//	public func signal(s: T) {
//		handler(s)
//	}
//
//	public func subscribe(emitter: AnyObject) {
//		assert(self.emitter === nil, "This is a unique channeling sensor, and already registered to an emitter `\(self.emitter!)`. So cannot be registered to another emitter again.")
//		self.emitter	=	emitter
//	}
//	public func desubscribe(emitter: AnyObject) {
//		assert(self.emitter === emitter, "This is a unique channeling sensor, and can be deregistered only from current emitter `\(self.emitter!)`.")
//		self.emitter	=	nil
//	}
//
////	public func subscribe<E : ChannelableEmitterType where E.Signal == T>(emitter: E) {
////		assert(self.emitter === nil, "This is a unique channeling sensor, and already registered to an emitter `\(self.emitter!)`. So cannot be registered to another emitter again.")
////		self.emitter	=	emitter
////	}
////	public func desubscribe<E : ChannelableEmitterType where E.Signal == T>(emitter: E) {
////		assert(self.emitter === emitter, "This is a unique channeling sensor, and can be deregistered only from current emitter `\(self.emitter!)`.")
////		self.emitter	=	nil
////	}
//	
//	////
//	
//	private typealias	In		=	T
//	private typealias	Out		=	()
//	
//	private var			handler	:	T -> ()
//	private weak var	emitter	:	AnyObject?
//	
//	private init(_ handler: T -> ()) {
//		self.handler	=	handler
//	}
//}
//
//public class ChannelingSignalMonitor<T>: ChannelingSignalSensor<T>, MonitorType {
//	typealias	In		=	T
//	typealias	Out		=	()
//	typealias	Signal	=	T
//	
//	public override init(_ handler: T -> ()) {
//		super.init(handler)
//	}
//	
//	public override var handler: T -> () {
//		didSet {
//		}
//	}
//	
//	public override func signal(s: T) {
//		super.signal(s)
//	}
//}
//




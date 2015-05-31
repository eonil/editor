//
//  SignalGraph.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/05.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

protocol Identifiable {
	func === <T> (Self, T) -> Bool
}



///	A core signal network node that defines input/output signals.
protocol GateType {
	typealias	In
	typealias	Out
}



///	A gate that emits signal to multiple sensors.
protocol EmitterType: GateType {
	typealias	Signal
	typealias	Out		=	Signal
	mutating func register<T: SensorType where T.Signal == Signal>(T)
	mutating func deregister<T: SensorType where T.Signal == Signal>(T)
}
///	A gate that senses signals from single emitter.
///	Sensor type must be identifiable to be resigered/deregistered to/from an emitter.
///
///	Some sensor implementation may limit sensor to be plugged into only one emitter.
///
protocol SensorType: GateType, AnyObject {
	typealias	Signal
	typealias	In		=	Signal
	///	Senses signals.
	func signal(Signal)
}








protocol NonEmissiveType {
	typealias	Out		=	()
}
protocol InsensitiveType {
	typealias	In		=	()
}






///	This is an initial type.
protocol DispatcherType: EmitterType, InsensitiveType {
	typealias	Signal
	typealias	Out		=	Signal
	///	Dispatches a signal.
	func signal(Signal)
}

///	This is a terminal type.
protocol MonitorType: SensorType, NonEmissiveType {
	typealias	Signal
	typealias	In		=	Signal
}












protocol ViewType {
	typealias	Emitter: EmitterType
	var	emitter: Emitter  { get }
}

///	Shows a state and emits mutation events of it.
///	This is essentially a read-only view of a state.
///	Storage does not define how to mutate the state. Mutations are defined by
///	implementations.
protocol StorageType {
	typealias	State
	typealias	Emitter: EmitterType
	var	state: State { get }
	var	emitter: Emitter  { get }
}

///	A storage that reconstructs its state from sensed input signals.
///	Plug sensor of this object into emitter of another repository.
///
///	Replication type intended to reconstruct its state using centralized signal
///	sensor. The sensor is the only mutator. You can chain multiple replications
///	freely.
///
///	**WARNING**
///	If you plug sensor of a replication object into emitter of itself, you will
///	make infinite loop, and result undefined. Implementation should detect and 
///	warn this kind of situation. Error detection is fully up to implementation 
///	specific.
protocol ReplicationType: StorageType {
	typealias	Sensor: SensorType
	var	sensor: Sensor { get }
}








//
//
/////	A repository that supports snapshot mutation of stored state.
//public protocol ValueStorageType: RepositoryType {
//	var state: State { get set }
//}
//
/////	A slot type that stores an array and support fined grained mutation operations.
//public protocol ArrayStorageType: RepositoryType {
//	typealias	Element
//	typealias	State		=	[Element]
//}




















protocol CollectionSignalType {
	typealias	Snapshot
	typealias	Transaction
	//	init(initiation: Snapshot)
	//	init(transition: Transaction)
	//	init(termination: Snapshot)
//	var initiation: Snapshot? { get }
//	var transition: Transaction? { get }
//	var termination: Snapshot? { get }
}

protocol CollectionTransactionType {
	typealias	Key	
	typealias	Value
}






























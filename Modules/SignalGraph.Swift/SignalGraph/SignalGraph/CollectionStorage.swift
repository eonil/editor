////
////  CollectionStorage.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/06.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//
//
//
//
//protocol CollecionStorageType: StorageType {
//	typealias	State:	SignalApplicableCollectionType
//}
//
/////	Collection containers cannot have non-empty initial state because
/////	it's hard to guarantee state integrity if there are many mutators.
/////	Always Having empty initial state will make everything a lot simpler.
//protocol CollectionReplicationType: CollecionStorageType, ReplicationType {
//	typealias	State:	SignalApplicableCollectionType
//	init()
//}
//
//protocol SignalApplicableCollectionType: CollectionType {
//	typealias	Signal
//	init()
//	mutating func apply(Signal)
//}
//
//
//
//
//
////class CollectionStorage<C where C: SignalApplicableCollectionType>: StorageType {
////	
////	private(set) var	state: C = C()
////	
////	var emitter: SignalEmitter<C.Signal> {
////		get {
////			return	dispatcher
////		}
////	}
////	
////	////
////	
////	private init() {
////	}
////	
////	private let	dispatcher	=	SignalDispatcher<C.Signal>()
////}
////
///////	Collection containers cannot have non-empty initial state because
///////	it's hard to guarantee state integrity if there are many mutators.
///////	Always Having empty initial state will make everything a lot simpler.
////class CollectionReplication<C where C: SignalApplicableCollectionType>: CollectionStorage<C>, ReplicationType {
////	
////	override init() {
////		super.init()
////		monitor.handler	=	{ [weak self] s in
////			self!.state.apply(s)
////			self!.dispatcher.signal(s)
////		}
////	}
////	
////	var sensor: SignalSensor<C.Signal> {
////		get {
////			return	monitor
////		}
////	}
////	
////	////
////	
////	private let	monitor		=	SignalMonitor<C.Signal>({ _ in })
////}
//
//
//
//
//
//
//
//

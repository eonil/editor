//
//  SetStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/06.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public class SetStorage<T: Hashable>: StorageType {
	
	public var state: Set<T> {
		get {
			return	values!
		}
	}
	
	public var emitter: SignalEmitter<SetSignal<T>> {
		get {
			return	dispatcher
		}
	}
	
	////
	
	private var	values	=	nil as Set<T>?
	
	private init() {
	}
	
	private let	dispatcher	=	SignalDispatcher<SetSignal<T>>()
}

///	A storage that provides indirect signal based mutator.
///
///	Initial state of a state-container is undefined, and you should not access
///	them while this contains is not bound to a signal source.
public class ReplicatingSetStorage<T: Hashable>: SetStorage<T>, ReplicationType {
	
	public override init() {
		super.init()
		monitor.handler	=	{ [unowned self] s in
			s.apply(&self.values)
			self.dispatcher.signal(s)
		}
	}
	
	public var sensor: SignalSensor<SetSignal<T>> {
		get {
			return	monitor
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<SetSignal<T>>({ _ in })
}









///	Provides in-place `Set`-like mutator interface.
///	Signal sensor is disabled to guarantee consistency.
public class EditableSetStorage<T: Hashable>: ReplicatingSetStorage<T> {
	public init(_ state: Set<T> = Set()) {
		super.init()
		super.sensor.signal(SetSignal.Initiation(snapshot: state))
	}
	deinit {
		//	Do not send any signal. 
		//	Because any non-strong reference to self is inaccessible here.
	}
	
	@availability(*,unavailable)
	public override var sensor: SignalSensor<SetSignal<T>> {
		get {
			fatalError("You cannot get sensor of this object. Replication from external emitter is prohibited.")
		}
	}
}
extension EditableSetStorage: SequenceType {
	public typealias	Index	=	SetIndex<T>
	public func insert(member: T) {
		super.sensor.signal(SetSignal.Transition(transaction: CollectionTransaction.insert((member,()))))
	}
	
	public func remove(member: T) -> T? {
		let	v	=	state.contains(member) ? member : nil as T?
		super.sensor.signal(SetSignal.Transition(transaction: CollectionTransaction.delete((member, ()))))
		return	v
	}
	
	public func generate() -> SetGenerator<T> {
		return	super.state.generate()
	}
	
	public subscript (position: Index) -> T {
		get {
			return	super.state[position]
		}
	}
}










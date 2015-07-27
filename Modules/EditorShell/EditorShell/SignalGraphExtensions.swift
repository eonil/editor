//
//  SignalGraphExtensions.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/16.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import SignalGraph

///	Propagates state of latest mutation from any storage in the list.
///	State of newrly added storage will be treated like newrly arrived value.
///	And states of all storages will be synced to it.
class ValueStorageEqualizer<T> {
	let	storages	=	ArrayStorage<ValueStorage<T>>([])

	init() {
		_connectArray()
	}
	deinit {
		_disconnectArray()
	}

	///

	private let	_arrayMonitor	=	ArrayMonitor<ValueStorage<T>>()
	private let	_allAtomMonitor	=	ValueMonitor<T>()

	private func _connectArray() {
		_arrayMonitor.didAdd		=	{ [weak self] in self!._onAddValueStorages($1) }
		_arrayMonitor.willRemove	=	{ [weak self] in self!._onRemoveValueStorages($1) }
		storages.register(_arrayMonitor)
	}
	private func _disconnectArray() {
		storages.deregister(_arrayMonitor)
	}
	private func _onAddValueStorages(vss: [ValueStorage<T>]) {
		vss.map(_connectAtom)
	}
	private func _onRemoveValueStorages(vss: [ValueStorage<T>]) {
		vss.map(_disconnectAtom)
	}
	private func _connectAtom(atom: ValueStorage<T>) {
		_allAtomMonitor.didBegin	=	{ [weak self] in self!._onAtomBeginState($0) }
		_allAtomMonitor.willEnd		=	{ [weak self] in self!._onAtomEndState($0) }
		atom.register(_allAtomMonitor)
	}
	private func _disconnectAtom(atom: ValueStorage<T>) {
		atom.deregister(_allAtomMonitor)
		_allAtomMonitor.willEnd		=	nil
		_allAtomMonitor.didBegin	=	nil
	}
	private func _onAtomBeginState(state: T) {
		_unicastAtomState(state)
	}
	private func _onAtomEndState(state: T) {
	}
	private func _unicastAtomState(state: T) {
		for atom in storages {
			atom.state	=	state
		}
	}
}


















//import Foundation
//import SignalGraph
//
//typealias	Equalization		=	()->()
//
/////	:return:	A function that breaks synchronization.
/////			You must call this when you finish synchronization.
/////
//func equalize<T: Equatable>(pair: (EditableValueStorage<T>, EditableValueStorage<T>)) -> Equalization {
//	let	sync	=	EditableValueStorageEqualizer<T>()
//	sync.pair	=	pair
//	let	quit	=	{ [sync] ()->() in sync.pair == nil }
//	return	quit
//}
//
//
//
/////	Continuously equalizes states of two editable storages.
/////
/////	This couples two editable storages into one. Mutation on one will be 
/////	propagated to another immediately as the signal arrives. Value type must be
/////	`Equatable` to prevent infinite propagation loop by ignoring duplicated values.
/////
/////
/////
/////	REQUIREMENTS
/////	------------
/////
/////	-	`state` of two storages must be equal when you assigning them to this
/////		object.
/////
/////	-	You must deset `pair` before this object dies.
/////
//class EditableValueStorageEqualizer<T: Equatable> {
//	init() {
//		
//	}
//	deinit {
//		assert(pair == nil)
//	}
//	
//	var pair: (EditableValueStorage<T>, EditableValueStorage<T>)? {
//		willSet {
//			if pair != nil {
//				_disconnect()
//			}
//		}
//		didSet {
//			if pair != nil {
//				_connect()
//			}
//		}
//	}
//	
//	///
//	
//	private let	_mons	=	(MonitoringValueStorage<T>(), MonitoringValueStorage<T>())
//	
//	private func _connect() {
//		assert(pair != nil)
//		assert(pair!.0.state == pair!.1.state)
//		_mons.0.didApplySignal	=	{ [weak self] _ in _sync(self!.pair!.0, self!.pair!.1) }
//		_mons.1.didApplySignal	=	{ [weak self] _ in _sync(self!.pair!.1, self!.pair!.0) }
//		pair!.0.emitter.register(_mons.0.sensor)
//		pair!.1.emitter.register(_mons.1.sensor)
//	}
//	private func _disconnect() {
//		assert(pair != nil)
//		assert(pair!.0.state == pair!.1.state)
//		pair!.0.emitter.deregister(_mons.0.sensor)
//		pair!.1.emitter.deregister(_mons.1.sensor)
//		_mons.0.didApplySignal	=	nil
//		_mons.1.didApplySignal	=	nil
//	}
//}
//
//
//private func _sync<T: Equatable>(from: EditableValueStorage<T>, to: EditableValueStorage<T>) {
//	if from.state != to.state {
//		to.state	=	from.state
//	}
//}
//
//
//
//
//

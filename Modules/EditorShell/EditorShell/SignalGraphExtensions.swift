//
//  SignalGraphExtensions.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/16.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph



typealias	Synchronization		=	()->()

///	:return:	A function that breaks synchronization.
///			You must call this when you finish synchronization.
///
func synchronize<T: Equatable>(pair: (EditableValueStorage<T>, EditableValueStorage<T>)) -> Synchronization {
	let	sync	=	EditableValueStorageSynchronizer<T>()
	sync.pair	=	pair
	let	quit	=	{ [sync] ()->() in sync.pair == nil }
	return	quit
}


///	Synchronizes state of two editable storages.
///
///	This couples two editable storages into one. Mutation on one will be 
///	applied to another ASAP. Value type must be `Equatable` to prevent
///	infinite propagation loop by ignoring duplicated values.
///
///
///
///	REQUIREMENTS
///	------------
///	-	`state` of two storages must be equal when you assigning them to this
///		object.
///
///	-	You must deset `pair` before this object dies.
///
class EditableValueStorageSynchronizer<T: Equatable> {
	init() {
		
	}
	deinit {
		assert(pair == nil)
	}
	
	var pair: (EditableValueStorage<T>, EditableValueStorage<T>)? {
		willSet {
			if pair != nil {
				_disconnect()
			}
		}
		didSet {
			if pair != nil {
				_connect()
			}
		}
	}
	
	///
	
	private let	_mons	=	(MonitoringValueStorage<T>(), MonitoringValueStorage<T>())
	
	private func _connect() {
		assert(pair != nil)
		assert(pair!.0.state == pair!.1.state)
		_mons.0.didApplySignal	=	{ [weak self] _ in _sync(self!.pair!.0, self!.pair!.1) }
		_mons.1.didApplySignal	=	{ [weak self] _ in _sync(self!.pair!.1, self!.pair!.0) }
		pair!.0.emitter.register(_mons.0.sensor)
		pair!.1.emitter.register(_mons.1.sensor)
	}
	private func _disconnect() {
		assert(pair != nil)
		assert(pair!.0.state == pair!.1.state)
		pair!.0.emitter.deregister(_mons.0.sensor)
		pair!.1.emitter.deregister(_mons.1.sensor)
		_mons.0.didApplySignal	=	nil
		_mons.1.didApplySignal	=	nil
	}
}


private func _sync<T: Equatable>(from: EditableValueStorage<T>, to: EditableValueStorage<T>) {
	if from.state != to.state {
		to.state	=	from.state
	}
}






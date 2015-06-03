//
//  DictionaryFilteringDictionaryStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//



///	Manages a subset dictionary by filtering a virtual dictionary derived from 
///	dictionary signal.
///
///	
public class DictionaryFilteringDictionaryStorage<K: Hashable,V>: StorageType {
	
	///
	///	:param:		filter
	///				A filter function to filter key-value pair subset.
	///
	///				REQUIREMENTS
	///				------------
	///				This function must be **referentially transparent**.
	///				That means same input must produce same output always.
	///				In other words, do not change internal logic of this while this
	///				function is bound to this object.
	///
	///				This function should be very cheap because this function will be
	///				called very frequently, and evaluation result will not be memoized
	///				at all. (you can do it yourself if you want)
	///
	public init(_ filter: (K,V) -> Bool) {
		self.filter		=	filter
		monitor.handler	=	{ [unowned self] s in self.process(s) }
	}
	
	public var sensor: SignalSensor<DictionarySignal<K,V>> {
		get {
			return	monitor
		}
	}
	public var state: [K:V] {
		get {
			return	replication.state
		}
	}
	public var emitter: SignalEmitter<DictionarySignal<K,V>> {
		get {
			return	replication.emitter
		}
	}
	
	////
	
	private let	monitor		=	SignalMonitor<DictionarySignal<K,V>>()
	private let	filter		:	(K,V) -> Bool
	private let	replication	=	ReplicatingDictionaryStorage<K,V>()
	
	private var editor: DictionaryEditor<K,V> {
		get {
			return	DictionaryEditor(replication)
		}
	}
	
	private func process(s: DictionarySignal<K,V>) {
		switch s {
		case .Initiation(let s):
			editor.initiate()
			for e in s {
				if filter(e) {
					insert(e)
				}
			}
		case .Transition(let s):
			for m in s.mutations {
				let	ts	=	(m.past == nil, m.future == nil)
				switch ts {
				case (true, false):
					if filter(m.identity, m.future!) {
						insert(m.identity, m.future!)
					}
					
				case (false, false):
					let	fs	=	(filter(m.identity, m.past!), filter(m.identity, m.future!))
					switch fs {
					case (false, true):
						//	Past value was filtered out.
						//	Future value does not.
						//	So treat it as an new insert.
						insert(m.identity, m.future!)
						
					case (true, true):
						//	Both of past and future values
						//	are not filtered out.
						//	This is just a plain update.
						update(m.identity, m.future!)
						
					case (true, false):
						//	Past value was not filtered out.
						//	Future value will be filtered out.
						//	Treat it as a delete.
						delete(m.identity)
						
					case (false, false):
						//	Both of past and future values 
						//	are filtered out.
						//	Just ignore it.
						()
						
					default:
						fatalError("Unsupported filtering state combination `\(fs)`.")
						
					}
				case (false, true):
					if filter(m.identity, m.past!) {
						delete(m.identity)
					}
					
				default:
					fatalError("Unsupported value transiation entry combination `\(ts)`.")
				}
			}
		case .Termination(let s):
			for e in s {
				if filter(e) {
					delete(e.0)
				}
			}
			editor.terminate()
		}
	}
	
	private func insert(e: (K,V)) {
		assert(editor[e.0] == nil, "There should be no existing value for the key `\(e.0)`.")
		var	ed	=	editor
		ed[e.0]		=	e.1
	}
	private func update(e: (K,V)) {
		var	ed	=	editor
		ed[e.0]		=	e.1
	}
	private func delete(e: (K)) {
		var	ed	=	editor
		ed.removeValueForKey(e)
	}
}

















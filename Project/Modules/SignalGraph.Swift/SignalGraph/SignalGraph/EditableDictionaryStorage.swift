//
//  EditableDictionaryStorage.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/09.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

public class EditableDictionaryStorage<K: Hashable,V>: ReplicatingDictionaryStorage<K,V> {
	public init(_ state: Dictionary<K,V> = [:]) {
		super.init()
		super.sensor.signal(DictionarySignal.Initiation(snapshot: state))
	}
	
	private var editor: DictionaryEditor<K,V> {
		get {
			return	DictionaryEditor(self)
		}
		set {
			assert(editor.origin === self)
		}
	}
}
extension EditableDictionaryStorage {
	public var count: Int {
		get {
			return	editor.count
		}
	}
	public subscript(key: K) -> V? {
		get {
			return	editor[key]
		}
		set(v) {
			editor[key]	=	v
		}
	}
	public func removeValueForKey(key: K) -> V? {
		return	editor.removeValueForKey(key)
	}
	public func removeAll() {
		editor.removeAll()
	}
	
	public var keys: LazyForwardCollection<MapCollectionView<[K : V], K>> {
		get {
			return	state.keys
		}
	}
	public var values: LazyForwardCollection<MapCollectionView<[K : V], V>> {
		get {
			return	state.values
		}
	}
}




//
//  Channels.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/06/08.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph




///	A channel means hidden state storage.
///	You always need to replicate them to see what is in it.
///
///	**Internals**
///
///	A channel exposes state mutators internally, so you can
///	manipulate them freely inside of this framework. But you
///	only can observe state outside.
///

//public struct Channel<Storage> {
//	
//}

public struct ValueChannel<T> {
	public var storage: ValueStorage<T>	{ get { return editor } }
	
	///
	
	internal let	editor		:	EditableValueStorage<T>
	
	internal init(_ state: T) {
		editor			=	EditableValueStorage(state)
	}
}

public struct ArrayChannel<T> {
	public var storage: ArrayStorage<T>	{ get { return editor } }
	
	///
	
	internal let	editor		:	EditableArrayStorage<T>
	
	internal init(_ state: [T]) {
		self.editor		=	EditableArrayStorage(state)
	}
}

public struct SetChannel<T: Hashable> {
	public var storage: SetStorage<T> 	{ get { return editor } }
	
	///
	
	internal let	editor		:	EditableSetStorage<T>
	
	internal init(_ state: Set<T>) {
		self.editor		=	EditableSetStorage(state)
	}
}

public struct DictionaryChannel<K: Hashable, V> {
	public var storage: DictionaryStorage<K,V>	{ get { return editor } }
	
	///
	
	internal let	editor		:	EditableDictionaryStorage<K,V>

	internal init(_ state: Dictionary<K,V>) {
		self.editor		=	EditableDictionaryStorage<K,V>(state)
	}
}














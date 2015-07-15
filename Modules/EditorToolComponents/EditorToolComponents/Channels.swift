////
////  Channels.swift
////  EditorToolComponents
////
////  Created by Hoon H. on 2015/06/27.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import SignalGraph
//
//
//
//
//
////	Classes in this file provides internal-only mutator access.
//
//
//
//
//public protocol StorageType: ChannelType {
//	typealias	Snapshot
//	typealias	Signal
//
//	init(_ snapshot: Snapshot)
//	var snapshot: Snapshot { get }
//}
//
//public class StorageChannel<S: StorageType>: ChannelType {
//	public init(_ snapshot: S.Snapshot) {
//		storage	=	S(snapshot)
//	}
//	public var snapshot: S.Snapshot {
//		get {
//			return	storage.snapshot
//		}
//	}
//
//	public func register(identifier: ObjectIdentifier, handler: S.Signal -> ()) {
//		storage.register(identifier, handler: handler)
//	}
//	public func deregister(identifier: ObjectIdentifier) {
//		storage.deregister(identifier)
//	}
//
//	///
//
//	internal let	storage	:	S
//}
//
//final class ValueStorage<T>: StateStorage<T>, StorageType {
//	required override init(_ state: T) {
//		super.init(state)
//	}
//	var snapshot: T {
//		get {
//			return	state
//		}
//	}
//}
//final class ChannelableSetStorage<T: Hashable>: SetStorage<T>, StorageType {
//	required override init(_ state: Set<T>) {
//		super.init(state)
//	}
//}
//final class ChannelableArrayStorage<T>: ArrayStorage<T>, StorageType {
//	required override init(_ state: Array<T>) {
//		super.init(state)
//	}
//}
//final class ChannelableDictionaryStorage<K: Hashable, V>: DictionaryStorage<K,V>, StorageType {
//	required override init(_ state: Dictionary<K,V>) {
//		super.init(state)
//	}
//}
//
//public class ValueChannel<T>: StorageChannel<ValueStorage<T>> {
//	public override init(_ state: T) {
//		super.init(state)
//	}
//}
//public class SetChannel<T: Hashable>: StorageChannel<ChannelableSetStorage<T>> {
//	public init() {
//		super.init([])
//	}
//}
//public class ArrayChannel<T>: StorageChannel<ChannelableArrayStorage<T>> {
//	public init() {
//		super.init([])
//	}
//}
//public class DictionayChannel<K: Hashable, V>: StorageChannel<ChannelableDictionaryStorage<K,V>> {
//	public init() {
//		super.init([:])
//	}
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////public class SetChannel<T: Hashable>: ChannelType {
////	public var snapshot: Set<T> {
////		get {
////			return	storage.snapshot
////		}
////	}
////
////	public func register(identifier: ObjectIdentifier, handler: CollectionSignal<Set<T>,T,()> -> ()) {
////		storage.register(identifier, handler: handler)
////	}
////	public func deregister(identifier: ObjectIdentifier) {
////		storage.deregister(identifier)
////	}
////
////	///
////
////	internal let	storage	=	SetStorage<T>([])
////}
////
////public class ArrayChannel<T>: ChannelType {
////	public var snapshot: [T] {
////		get {
////			return	storage.snapshot
////		}
////	}
////
////	public func register(identifier: ObjectIdentifier, handler: CollectionSignal<[T],Int,T> -> ()) {
////		storage.register(identifier, handler: handler)
////	}
////	public func deregister(identifier: ObjectIdentifier) {
////		storage.deregister(identifier)
////	}
////
////	///
////
////	internal let	storage	=	ArrayStorage<T>([])
////}
////
////public class DictionaryChannel<K: Hashable, V>: ChannelType {
////	public var snapshot: [K:V] {
////		get {
////			return	storage.snapshot
////		}
////	}
////
////	public func register(identifier: ObjectIdentifier, handler: CollectionSignal<[K:V],K,V> -> ()) {
////		storage.register(identifier, handler: handler)
////	}
////	public func deregister(identifier: ObjectIdentifier) {
////		storage.deregister(identifier)
////	}
////
////	///
////
////	internal let	storage	=	DictionaryStorage<K,V>([:])
////}
//
//
//
//
//
//
//
//

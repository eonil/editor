////
////  EventAutocastingArray.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/10/28.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//public struct ArrayStorage<M: BroadcastingModelType, T where M.Event: BroadcastableEventType, M.Event.Sender == M> {
//
//	internal init(host: M, onDidInsert: (index: Int)->M.Event, onWillDelete: (index: Int)->M.Event) {
//		self	=	ArrayStorage(host: host, onDidInsert: { onDidInsert(index: $0) }, onWillDelete: { onWillDelete(index: $0) })
//	}
//	internal init(host: M, onDidInsert: (index: Int, value: T)->M.Event, onWillDelete: (index: Int, value: T)->M.Event) {
//		_host		=	host
//		_onDidInsert	=	onDidInsert
//		_onWillDelete	=	onWillDelete
//	}
//
//
//
//
//
//	///
//
//	public mutating func insert(value: T, atIndex: Int) {
//		_array.insert(value, atIndex: atIndex)
//		_onDidInsert(atIndex, value).dualcastWithSender(_host)
//	}
//	public mutating func removeAtIndex(index: Int) {
//		_onWillDelete(index, _array[index]).dualcastWithSender(_host)
//		_array.removeAtIndex(index)
//	}
//
//
//
//
//
//	///
//
//	private var		_array		=	[T]()
//	private unowned let	_host		:	M
//	private let		_onDidInsert	:	(Int,T) -> M.Event
//	private let		_onWillDelete	:	(Int,T) -> M.Event
//
//}
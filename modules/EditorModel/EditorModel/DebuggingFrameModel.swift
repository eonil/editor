////
////  DebuggingFrameModel.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/21.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import MulticastingStorage
//import LLDBWrapper
//
///// A wrapper around `LLDBFrame` to provide UI-friendly interface.
/////
//public class DebuggingFrameModel: ModelSubnode<DebuggingTargetModel> {
//
//	public struct Info {
//		var	name	:	String
//	}
//
//	///
//
//	internal init(_ frame: LLDBFrame) {
//		_lldbFrame	=	frame
//	}
//
//	public var target: DebuggingTargetModel {
//		get {
//			return	owner!
//		}
//	}
//
//	override func didJoinModelRoot() {
//		super.didJoinModelRoot()
//		_install()
//	}
//	override func willLeaveModelRoot() {
//		_deinstall()
//		super.willLeaveModelRoot()
//	}
//
//	///
//
//	var values: ArrayStorage<DebuggingFrameValueModel> {
//		get {
//			return	_values
//		}
//	}
//
//	///
//
//	private let	_lldbFrame	:	LLDBFrame
//	private let	_values		=	MutableArrayStorage<DebuggingFrameValueModel>([])
//
//	private func _install() {
//		_values
//	}
//	private func _deinstall() {
//		if _values.array.count > 0 {
//			_handleWillDeleteRange(_values.array.wholeRange)
//		}
//	}
//
//	private func _handleDidInsertRange(range: Range<Int>) {
//		let	vl	=	_lldbFrame.variablesWithArguments(true, locals: true, statics: true, inScopeOnly: true, useDynamic: LLDBDynamicValueType.NoDynamicValues)
//		let	ms	=	vl.allAvailableValues.map({ DebuggingFrameValueModel($0) })
//		ms.map({ $0.owner = self })
//		_values.extend(ms)
//	}
//	private func _handleWillDeleteRange(range: Range<Int>) {
//		_values.array[range].map({ $0.owner = nil })
//		_values.removeAll()
//	}
//
//	private func _makeInfo() -> Info {
//		_lldbFrame.
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

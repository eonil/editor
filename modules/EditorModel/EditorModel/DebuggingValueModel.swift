////
////  DebuggingValueModel.swift
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
//public class DebuggingFrameValueModel: DebuggingValueModel {
//
//	internal override init(_ value: LLDBValue) {
//		super.init(value)
//	}
//	var stackFrame: DebuggingFrameModel {
//		get {
//			return	owner! as! DebuggingFrameModel
//		}
//	}
//}
//
//public class DebuggingSubvalueModel: DebuggingValueModel {
//
//	var supervalue: DebuggingValueModel {
//		get {
//			return	owner! as! DebuggingValueModel
//		}
//	}
//}
//
///// A wrapper around `LLDBValue` to provide UI-friendly interface.
/////
//public class DebuggingValueModel: ModelSubnode<ModelNode> {
//
//	public struct Content {
//		var	name		:	String
//		var	summary		:	String
//		var	address		:	LLDBAddress
//	}
//
//	///
//
//	private init(_ value: LLDBValue) {
//		_lldbValue	=	value
//	}
//
//	override func didJoinModelRoot() {
//		super.didJoinModelRoot()
//		_install()
//
//	}
//	override func willLeaveModelRoot() {
//		_deinstall()
//		super.willLeaveModelRoot()
//	}
//
//	///
//
//	public var content: ValueStorage<Content?> {
//		get {
//			return	_content
//		}
//	}
//	public var subvalues: ArrayStorage<DebuggingSubvalueModel> {
//		get {
//			return	_subvalues
//		}
//	}
//
//	///
//
//	private let	_lldbValue	:	LLDBValue
//
//	private let	_content	=	MutableValueStorage<Content?>(nil)
//	private let	_subvalues	=	MutableArrayStorage<DebuggingSubvalueModel>([])
//
//	private func _install() {
//		_content.value	=	_makeContent()
//
//		let	ms	=	_lldbValue.allAvailableChildren.map({ DebuggingSubvalueModel($0) })
//		ms.map({ $0.owner = self })
//	}
//	private func _deinstall() {
//		_subvalues.array.map({ $0.owner = nil })
//
//		_content.value	=	nil
//	}
//
//	private func _makeContent() -> Content {
//		return	Content(
//			name	:	_lldbValue.name,
//			summary	:	_lldbValue.summary,
//			address	:	_lldbValue.address)
//	}
//}
//
//
//
//
//
//

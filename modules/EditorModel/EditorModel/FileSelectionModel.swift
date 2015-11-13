////
////  FileSelectionModel.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/30.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import MulticastingStorage
//import EditorCommon
//
//public class FileSelectionModel: ModelSubnode<FileTreeModel> {
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
//	public func focusFileAtPath(path: WorkspaceItemPath) {
//		assert(_focusedPath.value == nil)
//		_focusedPath.value	=	path
//	}
//	public func defocusFileAtPath() {
//		assert(_focusedPath.value != nil)
//		_focusedPath.value	=	nil
//	}
//	public func selectFileAtPath(path: WorkspaceItemPath) {
//		_selectedPaths.append(path)
//	}
//	public func deselectFileAtPath(path: WorkspaceItemPath) {
//		_selectedPaths.removeFirstEqualValue(path)
//	}
//
//	///
//
//	private let	_focusedPath	=	MutableValueStorage<WorkspaceItemPath?>(nil)
//	private let	_selectedPaths	=	MutableArrayStorage<WorkspaceItemPath>([])
//
//	///
//
//	private func _install() {
//		
//	}
//	private func _deinstall() {
//
//	}
//}
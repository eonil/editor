//
//  FileSelectionModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/30.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon

public class FileSelectionModel: ModelSubnode<FileTreeModel> {
	override func didJoinModelRoot() {
		super.didJoinModelRoot()
		_install()
	}
	override func willLeaveModelRoot() {
		_deinstall()
		super.willLeaveModelRoot()
	}

	///

	private let	_focused	=	MutableValueStorage<WorkspaceItemPath?>(nil)
	private let	_marked		=	MutableArrayStorage<WorkspaceItemPath>([])

	private func _install() {

	}
	private func _deinstall() {

	}
}
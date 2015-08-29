//
//  WorkspaceItemPointer.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// An absolute pointer to a workspace item.
///
public struct WorkspaceItemPointer {

	public init(workspace: WorkspaceModel, path: WorkspaceItemPath) {
		_workspace	=	workspace
		_path		=	path
	}

	///

	public var workspace: WorkspaceModel {
		get {
			return	_workspace!
		}
	}
	public var path: WorkspaceItemPath {
		get {
			return	_path
		}
	}

	///

	private weak var	_workspace	:	WorkspaceModel?
	private var		_path		: 	WorkspaceItemPath

}

public extension WorkspaceItemPointer {

	public init?(workspace: WorkspaceModel, absoluteFileURL u: NSURL) throws {
		guard u.fileURL else {
			return	nil
		}

		_workspace	=	workspace
		_path		=	try! WorkspaceItemPath(absoluteFileURL: u, `for`: workspace)!
	}

	public func absoluteFileURL() -> NSURL {
		assert(_workspace!.location.value!.fileURL == true)

		return	_path.absoluteFileURL(`for`: _workspace!)
	}

}

extension WorkspaceItemPointer: Equatable, Hashable {
	public var hashValue: Int {
		get {
			return	ObjectIdentifier(workspace).hashValue | path.hashValue
		}
	}
}
public func == (a: WorkspaceItemPointer, b: WorkspaceItemPointer) -> Bool {
	return	a.workspace === b.workspace
	&&	a.path == b.path
}













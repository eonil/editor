//
//  WorkspaceItemPath.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// An absolute path from workspace root.
///
public struct WorkspaceItemPath {

	public static let	root	=	WorkspaceItemPath(parts: [])

	public init(parts: [String]) {
		assert(parts.filter({ $0 == "" }).count == 0, "Empty string cannot be a name part.")

		_parts		=	parts
	}

	///

	public var parts: [String] {
		get {
			return	_parts
		}
	}

	public func pathByDeletingLastComponent() -> WorkspaceItemPath {
		precondition(parts.count > 0)
		return	WorkspaceItemPath(parts: Array(parts[0..<parts.endIndex-1]))
	}
	public func hasPrefix(prefixPath: WorkspaceItemPath) -> Bool {
		guard prefixPath.parts.count <= _parts.count else {
			return	false
		}
		for i in 0..<prefixPath.parts.count {
			guard parts[i] == prefixPath.parts[i] else {
				return	false
			}
		}
		return	true
	}

	///

	private var		_parts		=	[String]()
}

public extension WorkspaceItemPath {

	public init?(absoluteFileURL u: NSURL, `for` workspace: WorkspaceModel) throws {
		guard u.fileURL else {
			return	nil
		}

		if workspace.location.value! == u {
			// Path to root. Nothing to do.
			return
		}
		else {
			var	u	=	u
			while let p = u.lastPathComponent {
				_parts.append(p)
				if let u1 = u.URLByDeletingLastPathComponent {
					u	=	u1
					if workspace.location.value! == u {
						// Path discovered.
						return
					}
				}
				else {
					break
				}
			}

			// No more part, but still not a path to this workspace.
			// Invalid, wrong URL.
			throw WorkspaceItemPathError(message: "The `absoluteFileURL` is not a part of this workspace.")
		}

	}

	public func absoluteFileURL(`for` workspace: WorkspaceModel) -> NSURL {
		assert(workspace.location.value!.fileURL == true)

		var	u	=	workspace.location.value!
		for p in _parts {
			u	=	u.URLByAppendingPathComponent(p)
		}
		return	u
	}

}

extension WorkspaceItemPath: Equatable, Hashable {
	public var hashValue: Int {
		get {
			return	parts.last?.hashValue ?? 0
		}
	}
}
public func == (a: WorkspaceItemPath, b: WorkspaceItemPath) -> Bool {
	return	a.parts == b.parts
}




public struct WorkspaceItemPathError: ErrorType {
	public let	message	:	String
}














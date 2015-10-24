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
		assert(parts.map(WorkspaceItemPath._isPartValid).reduce(true, combine: { $0 && $1 }))

		_parts	=	parts
	}

	///

	public var parts: [String] {
		get {
			return	_parts
		}
	}

	public func pathByAppendingLastComponent(part: String) -> WorkspaceItemPath {
		assert(WorkspaceItemPath._isPartValid(part))
		return	WorkspaceItemPath(parts: parts + [part])
	}
	public func pathByDeletingFirstComponent() -> WorkspaceItemPath {
		precondition(parts.count > 0)
		return	WorkspaceItemPath(parts: Array(parts[parts.startIndex.successor()..<parts.endIndex]))
	}
	public func pathByDeletingLastComponent() -> WorkspaceItemPath {
		precondition(parts.count > 0)
		return	WorkspaceItemPath(parts: Array(parts[parts.startIndex..<parts.endIndex.predecessor()]))
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

	private enum _PartError: ErrorType {
		/// A part is empty.
		case PartIsEmpty
		/// A path part cannot contain any slash character (`/`) that is reserved for part separator.
		case PartContainsSlash
	}

	private var	_parts	=	[String]()

	private static func _isPartValid(part: String) -> Bool {
		do {
			try _validatePart(part)
			return	true
		}
		catch {
			return	false
		}
	}
	private static func _validatePart(part: String) throws {
		guard part != "" else {
			throw	_PartError.PartIsEmpty
		}
		guard part.containsString("/") == false else {
			throw	_PartError.PartContainsSlash
		}
	}
}

public extension WorkspaceItemPath {

//	public init?(absoluteFileURL u: NSURL, `for` workspace: WorkspaceModel) throws {
//		guard u.fileURL else {
//			return	nil
//		}
//
//		if workspace.location.value! == u {
//			// Path to root. Nothing to do.
//			return
//		}
//		else {
//			var	u	=	u
//			while let p = u.lastPathComponent {
//				_parts.append(p)
//				if let u1 = u.URLByDeletingLastPathComponent {
//					u	=	u1
//					if workspace.location.value! == u {
//						// Path discovered.
//						return
//					}
//				}
//				else {
//					break
//				}
//			}
//
//			// No more part, but still not a path to this workspace.
//			// Invalid, wrong URL.
//			throw WorkspaceItemPathError(message: "The `absoluteFileURL` is not a part of this workspace.")
//		}
//
//	}

	public func absoluteFileURL(`for` workspace: WorkspaceModel) -> NSURL {
		assert(workspace.location.value!.fileURL == true)

		var	u	=	workspace.location.value!
		for p in _parts {
			u	=	u.URLByAppendingPathComponent(p)
		}
		return	u
	}

}

extension WorkspaceItemPath: CustomStringConvertible {
	public var description: String {
		get {
			return	"(WorkspaceItemPath: \(_parts))"
		}
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














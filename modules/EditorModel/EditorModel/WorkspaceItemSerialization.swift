//
//  WorkspaceItemSerialization.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// Provides serialization of workspace path items.
///
/// This serializes a path item into a custom schemed URL.
/// Each path items will be stored in this form.
///
/// 	editor://workspace/folder1/folder2?group
/// 	editor://workspace/folder1/folder2/file3?comment=extra%20info
///
/// Rules
/// -----
/// 1. Conforms RFC URL standards. (done by Cocoa classes)
/// 2. Slashes(`/`) cannot be a part of node name. Even with escapes.
///    This equally applied to all of Unix file systems and URL standards. 
///    You must use slashes as a directory separator to conform URL standard
///    even if you're using this data on Windows.
/// 3. All files are stored in sorted flat list. Yes, base paths are 
///    duplicated redundant data, but this provides far more DVCS-friendly
///    (diff/merge) data form, and I believe that is far more important
///    then micro spatial efficiency. Also, in most cases, you will be 
///    using at least a kind of compression, and this kind of redundancy
///    is very compression friendly.
///
/// Workspace is defined by a sorted list of paths to files in the workspace.
/// All items are full paths to workspace root.
/// Container directories must have an explicit entry. Missing container
/// is an error.
///
/// Strict reader requires all intermediate folders comes up before any 
/// descendant nodes. Anyway error-tolerant reader will be provided later
/// for practical use with DVCS systems by inferring missing containers.
///
struct WorkspaceItemSerialization {
	typealias	PersistentItem	=	(path: WorkspaceItemPath, group: Bool, comment: String?)

	struct Error: ErrorType {
		let	message	:	String

	}

	static func deserialize(u: NSURLComponents) throws -> PersistentItem {
		assert(u.scheme == "editor")
		assert(u.host == "workspace")
		assert(u.path != nil)
		assert(u.path!.hasPrefix("/"))
		guard u.scheme == "editor" else {
			throw Error(message: "The expression URL `\(u)` does not have `editor://` scheme.")
		}
		guard u.host == "workspace" else {
			throw Error(message: "The expression URL `\(u)` does not have `editor://workspace` host.")
		}
		guard u.path != nil else {
			throw Error(message: "The expression URL `\(u)` must have a non-nil path.")
		}
		guard u.path!.hasPrefix("/") else {
			throw Error(message: "The expression URL `\(u)` path must starts with `/`.")
		}

		var	parts	=	[String]()
		var	comment	=	nil as String?
		var	group	=	false

		parts		=	u.path!.componentsSeparatedByString("/")
		assert(parts.count >= 1)
		assert(parts.first == "")
		guard parts.count >= 1 else {
			throw Error(message: "The expression URL `\(u)` path must starts with `/`.")
		}
		guard parts.first == "" else {
			throw Error(message: "The expression URL `\(u)` path must starts with `/`.")
		}
		parts.removeFirst()
		if parts.last == "" {
			parts.removeLast()
		}

		for q in u.queryItems ?? [] {
			if q.name == "comment" {
				comment	=	q.value
			}
			if q.name == "group" {
				group	=	true
			}
		}

		let	path	=	WorkspaceItemPath(parts: parts)
		return	(path, group, comment)
	}

	static func serialize(item: PersistentItem) -> NSURLComponents {
		for p in item.path.parts {
			precondition(p.containsString("/") == false)
		}

		func getQueryItems() -> [NSURLQueryItem] {
			let	items	=	[
				item.group == false ? Optional.None : NSURLQueryItem(name: "group", value: nil),
				item.comment == nil ? Optional.None : NSURLQueryItem(name: "comment", value: item.comment),
			]
			as [NSURLQueryItem?]
			return	items.filter { $0 != nil }.map { $0! }
		}

		let	u	=	NSURLComponents()
		u.scheme	=	"editor"
		u.host		=	"workspace"
		u.path		=	"/" + item.path.parts.joinWithSeparator("/")
		u.queryItems	=	getQueryItems()
		return	u
	}
}



extension WorkspaceItemSerialization {
	static func deserializeList(snapshot: String) throws -> [PersistentItem] {
		let	lines	=	snapshot.componentsSeparatedByString("\n").filter({ $0 != "" })
		let	items	=	try lines.map(deserialize)
		return	items
	}
	static func deserialize(expression: String) throws -> PersistentItem {
		if let u = NSURLComponents(string: expression) {
			return	try deserialize(u)
		}
		else {
			throw Error(message: "The expression `\(expression)` must be a valid URL string.")
		}
	}
	static func serializeList(items: [PersistentItem]) -> String {
		let	lines	=	items.map(serialize).map({ $0.string! })
		let	str	=	lines.joinWithSeparator("\n")
		return	str
	}
}




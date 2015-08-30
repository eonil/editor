//
//  WorkspaceItemSerialization.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

struct WorkspaceItemSerialization {
	typealias	PersistentItem	=	(path: WorkspaceItemPath, comment: String?)

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
		}

		let	path	=	WorkspaceItemPath(parts: parts)
		return	(path, comment)
	}
	static func serialize(item: PersistentItem) -> NSURLComponents {
		for p in item.path.parts {
			precondition(p.containsString("/") == false)
		}

		let	u	=	NSURLComponents()
		u.scheme	=	"editor"
		u.host		=	"workspace"
		u.path		=	"/" + item.path.parts.joinWithSeparator("/")
		u.queryItems	=	item.comment == nil ? nil : [NSURLQueryItem(name: "comment", value: item.comment!)]
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




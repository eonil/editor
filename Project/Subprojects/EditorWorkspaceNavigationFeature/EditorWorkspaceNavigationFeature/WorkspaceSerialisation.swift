//
//  WorkspaceSerialisation.swift
//  EditorWorkspaceNavigationFeature
//
//  Created by Hoon H. on 2015/02/21.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import Standards
import EditorCommon

//extension WorkspaceRepository {
//	init(workspaceAtURL u:NSURL) {
//		
//	}
//}
//
//extension WorkspaceRepository {
//	func writeToWorkspaceAtURL(u:NSURL) {
//		
//	}
//}

private let	CONF_FILE_NAME	=	".eonil.editor.workspace.configuration"

class WorkspaceSerialisation {
	static func configurationFileURLForWorkspaceAtURL(u:NSURL) -> NSURL {
		return	u.URLByAppendingPathComponent(CONF_FILE_NAME)
	}
	///	This will creates a new repository if there's no existing configuration.
	static func readRepositoryConfiguration(fromWorkspaceAtURL u:NSURL) -> WorkspaceRepository {
		precondition(u.existingAsDirectoryFile, "No directory at the URL `\(u)`.")
		
		let	confFileURL	=	configurationFileURLForWorkspaceAtURL(u)
		precondition(confFileURL.existingAsDataFile, "No file at the URL `\(confFileURL)`.")
		
		let	data		=	NSData(contentsOfURL: confFileURL)!
		let	rep			=	deserialise(data)
		
		Debug.log("Workspace configuration read from `\(u)`.")
		return	rep
	}
	static func writeRepositoryConfiguration(repository:WorkspaceRepository, toWorkspaceAtURL u:NSURL) {
		let	confFileURL	=	configurationFileURLForWorkspaceAtURL(u)
		let	data		=	serialise(repository)
		let	ok			=	data.writeToURL(confFileURL, atomically: true)
		precondition(ok)
		
		Debug.log("Workspace configuration written to `\(u)`.")
	}
	
	
	
	
	static func serialise(repository:WorkspaceRepository) -> NSData {
		return	JSON.serialise(repository.json)!
	}
	static func deserialise(data:NSData) -> WorkspaceRepository {
		let	j	=	JSON.deserialise(data)
		return	WorkspaceRepository.objectify(j, errorTrap: { s in fatalError(s) })!
	}
}












extension WorkspaceRepository {
	static func objectify(json: JSON.Value?, @noescape errorTrap:(String)->()) -> WorkspaceRepository? {
		if json == nil			{ errorTrap("JSON value for `\(self.dynamicType)` is `nil`."); return nil }
		if json!.object == nil	{ errorTrap("JSON value for `\(self.dynamicType)` is not an JSON object."); return nil }
		
		let o		=	json!.object!
		let	root	=	o["root"]?.object
		
		if root == nil			{ errorTrap("JSON object for `\(self.dynamicType)` has no proper `root` value."); return nil }
		
		let	name	=	root!["name"]?.string
		
		if name == nil			{ errorTrap("JSON object for `root` field of `\(self.dynamicType)` has no proper `name` value."); return nil }
		
		let	o1		=	self.init(name: name!)
		o1.root.reconfigure(o["root"]!, errorTrap: errorTrap)
		return	o1
	}
	var json:JSON.Value {
		get {
			let	o	=	[
				"version"	:	JSON.Value.String("0.0.0"),
				"root"		:	self.root.json,
			] as JSON.Object
			return	JSON.Value.Object(o)
		}
	}
}
extension WorkspaceNode {
	///	Erases all existing state and reset to data restored from supplied JSON data.
	private func reconfigure(json: JSON.Value?, @noescape errorTrap:(String)->()) {
		func inner(@noescape errorTrap:(String)->()) -> ()? {
			if json == nil			{ errorTrap("JSON value for `\(self.dynamicType)` is `nil`."); return nil }
			if json!.object == nil	{ errorTrap("JSON value for `\(self.dynamicType)` is not an JSON string."); return nil }
			
			let	o			=	json!.object!
//			let	name		=	o["name"]?.string
			let	comment		=	o["comment"]?.string
			let	flags		=	WorkspaceNodeFlags(json: o["flags"], errorTrap: errorTrap)
			let	subnodes	=	o["subnodes"]?.array
			
//			if name == nil			{ errorTrap("JSON object for `\(self.dynamicType)` is not have `name` string field."); return nil }
			
			if flags == nil		{ errorTrap("A JSON object for `\(self.dynamicType)`'s child has no proper `flags` value."); return nil }
			if subnodes == nil		{ errorTrap("JSON object for `\(self.dynamicType)` is not have `subnodes` array field."); return nil }
			
//			self.rename(name!)
			self.comment	=	comment		// `comment` can be `nil`.
			if flags!.isOpenFolder {
				self.setExpanded()
			}
			
			self.deleteAllChildNodes()
			for j in subnodes! {
				if j.object == nil		{ errorTrap("One of more item is not JSON object value in array of JSON object for `\(self.dynamicType)`."); return nil }
				let	o1		=	j.object!
				let	name	=	o1["name"]?.string
				let	kind	=	WorkspaceNodeKind(json: o1["kind"], errorTrap: errorTrap)
				
				if name == nil		{ errorTrap("A JSON object for `\(self.dynamicType)`'s child has no `name` string field."); return nil }
				if kind == nil		{ errorTrap("A JSON object for `\(self.dynamicType)`'s child has no proper `kind` value."); return nil }

				let	sn		=	self.createChildNodeAtLastAsKind(kind!, withName: name!)
				sn.reconfigure(j, errorTrap: errorTrap)
			}
			
			return	nil
		}
		inner(errorTrap)
	}
	var json:JSON.Value {
		get {
			let	ns	=	children.map({ n in n.json })
			let	ns1	=	JSON.Value.Array(ns)
			
			let	o	=	[
				"name"		:	JSON.Value.String(name),
				"comment"	:	comment == nil ? JSON.Value.Null : JSON.Value.String(comment!),
				"kind"		:	kind.json,
				"flags"		:	flags.json,
				"subnodes"	:	ns1,
			] as JSON.Object
			return	JSON.Value.Object(o)
		}
	}
}

extension WorkspaceNodeKind {
	init?(json: JSON.Value?, @noescape errorTrap:(String)->()) {
		if json == nil			{ errorTrap("JSON value for `\(self.dynamicType)` is `nil`."); return nil }
		if json!.string == nil	{ errorTrap("JSON value for `\(self.dynamicType)` is not an JSON string."); return nil }
		
		switch json!.string! {
		case "file":	self	=	File
		case "folder":	self	=	Folder
		default:		
			errorTrap("JSON value for `\(self.dynamicType)` is an unknown value `\(json!.string!)`.")
			return nil
		}
	}
	var	json:JSON.Value {
		get {
			switch self {
			case .File:		return	JSON.Value.String("file")
			case .Folder:	return	JSON.Value.String("folder")
			}
		}
	}
}
extension WorkspaceNodeFlags {
	init?(json:JSON.Value?, @noescape errorTrap:(String)->()) {
		if json == nil			{ errorTrap("JSON value for `\(self.dynamicType)` is `nil`."); return nil }
		if json!.object == nil	{ errorTrap("JSON value for `\(self.dynamicType)` is not an JSON object."); return nil }
		
//		let	_lazy	=	json!.object!["lazySubtree"]?.boolean
//		let	_subws	=	json!.object!["subworkspace"]?.boolean
		let	_open	=	json!.object!["isOpenFolder"]?.boolean
		
//		if _lazy == nil			{ errorTrap("JSON object for `WorkspaceNodeFlags` has no proper `lazySubtree` value."); return nil }
//		if _subws == nil		{ errorTrap("JSON object for `WorkspaceNodeFlags` has no proper `subworkspace` value."); return nil }
		if _open == nil			{ errorTrap("JSON object for `WorkspaceNodeFlags` has no proper `isOpenFolder` value."); return nil }
		
		self.isOpenFolder	=	_open!
//		self.subworkspace	=	_subws!
	}
	var	json:JSON.Value {
		get {
			let	o	=	[
//				"lazySubtree"	:	JSON.Value.Boolean(lazySubtree),
				"isOpenFolder"	:	JSON.Value.Boolean(isOpenFolder),
//				"subworkspace"	:	JSON.Value.Boolean(subworkspace),
				] as JSON.Object
			return	JSON.Value.Object(o)
		}
	}
}




































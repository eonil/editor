////
////  Selection.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/08/14.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//public final class Selection {
//
//	weak var owner: Model?
//
//	public var project: ProjectSelection {
//		get {
//			return	owner!.workspaces.
//		}
//	}
//	public let	project		=	ProjectSelection()
//	public let	file		=	FileSelection()
//	public let	symbol		=	SymbolSelection()
//	public let	search		=	SearchSelection()
//	public let	editing		=	EditingSelection()
//	public let	debugging	=	DebuggingSelection()
//
//	public init() {
//		project.owner	=	self
//		file.owner	=	self
//		symbol.owner	=	self
//		search.owner	=	self
//		editing.owner	=	self
//		debugging.owner	=	self
//	}
//
//}
//
////
////
////
////
////
////
////
////public final class FileSelection {
////	internal weak var owner: Selection?
////
////	public var nodes: ArrayStorage<NSURL> {
////		get {
////			return	_nodesOverDepth
////		}
////	}
////
////	///
////
////	private let	_nodesOverDepth	=	MutableArrayStorage<NSURL>([])
////}
////public final class SymbolSelection {
////	internal weak var owner: Selection?
////}
////
////public final class SearchSelection {
////	internal weak var owner: Selection?
////}
////
////public final class EditingSelection {
////	internal weak var owner: Selection?
////}
////
////public final class DebuggingSelection {
////	internal weak var owner: Selection?
////
////	public var target: ValueStorage<()?> {
////		get {
////			return	_target
////		}
////	}
////	public var session: ValueStorage<()?> {
////		get {
////			return	_session
////		}
////	}
////	public var stackFrame: ValueStorage<()?> {
////		get {
////			return	_stackFrame
////		}
////	}
////	public var localVariable: ValueStorage<()?> {
////		get {
////			return	_localVariable
////		}
////	}
////
////	private let	_target		=	MutableValueStorage<()?>(nil)
////	private let	_session	=	MutableValueStorage<()?>(nil)
////	private let	_stackFrame	=	MutableValueStorage<()?>(nil)
////	private let	_localVariable	=	MutableValueStorage<()?>(nil)
////}
////
////
////
////
////
////
////
////
////
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

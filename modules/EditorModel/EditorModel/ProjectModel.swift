//
//  ProjectModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import MulticastingStorage
import EditorCommon


///	A unit of build.
public class ProjectModel {
	weak var owner: WorkspaceModel?

	public init() {
		selection.owner		=	self
	}

	///

	public let	selection	=	ProjectSelection()
	public let	report		=	Report()
	public let	console		=	Console()

	public var rootURL: ValueStorage<NSURL?> {
		get {
			return	_rootURL
		}
	}

	///	A URL to `Cargo.toml` file.
	public var cargoFileURL: ValueStorage<NSURL?> {
		get {
			return	_cargoFileURL
		}
	}
	public var cargoFileContent: ValueStorage<CargoFileContent?> {
		get {
			return	_cargoFileContent
		}
	}

	///

	private let	_rootURL		=	MutableValueStorage<NSURL?>(nil)
	private let	_cargoFileURL		=	MutableValueStorage<NSURL?>(nil)
	private let	_cargoFileContent	=	MutableValueStorage<CargoFileContent?>(nil)

	private func _runResolutionOfCargoFileURL() {
//		assert(_rootURL.value != nil)
//
//		let	u1	=	_rootURL.value!
//		u1

		fatalErrorBecauseUnimplementedYet()
	}
	private func _runResolutionOfCatgoFileContent() {
		fatalErrorBecauseUnimplementedYet()

	}
}

public class ProjectSelection {
	weak var owner: ProjectModel?

	public var files: ArrayStorage<NSURL> {
		get {
			return	_files
		}
	}
	public var revealingFile: ValueStorage<NSURL?> {
		get {
			return	_revealingFile
		}
	}

	public func revealFile(file: NSURL) {
		fatalErrorBecauseUnimplementedYet()
	}

	public func selectFiles(files: [NSURL]) {
		fatalErrorBecauseUnimplementedYet()
	}
	public func deselectAllFiles() {
		fatalErrorBecauseUnimplementedYet()
	}

	///

	private let	_files			=	MutableArrayStorage<NSURL>([])
	private let	_revealingFile		=	MutableValueStorage<NSURL?>(nil)
}









public struct CargoFileContent {
	public struct Package {
		public var	name	:	String
		public var	version	:	String
		public var	authors	:	[String]
	}
}






//
//  ProjectModel.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon


///	A unit of build.
public class ProjectModel {

	public init() {
		selection.owner		=	self
	}

	///

	public var	rootURL		:	NSURL?

	public let	selection	=	ProjectSelection()
	public let	report		=	Report()
	public let	console		=	Console()
}

public class ProjectSelection {
	weak var owner: ProjectModel?

	public var files: ArrayStorage<NSURL> {
		get {
			return	_files
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
	private let	_revealingTarget	=	MutableValueStorage<NSURL?>(nil)
}
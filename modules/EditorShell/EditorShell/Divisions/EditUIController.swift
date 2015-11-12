//
//  EditUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon

class EditUIController: CommonViewController {

	var location: NSURL? {
		willSet {

		}
		didSet {

		}
	}

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}









	///

	private let _emptySign		=	SignboardView()
	private let _editTextFileUIC	=	EditTextFileUIController()

	private func _install() {
		_emptySign.headText	=	"No Editor"
		view.addSubview(_emptySign)
	}
	private func _deinstall() {
		_emptySign.removeFromSuperview()
	}
	private func _layout() {
		_emptySign.frame	=	view.bounds
	}

}














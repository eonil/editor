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

	weak var model: WorkspaceModel?






	///
















	///

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

	private enum _State {
		case Empty
		case Error(ErrorType)
		case Text(String)
	}
//	private enum _Error: ErrorType {
//		case Empty
//		case
//	}

	private let _signboard		=	SignboardView()
	private let _editTextFileUIC	=	EditTextFileUIController()
	private var _state		=	_State.Empty

	private func _install() {
		view.addSubview(_signboard)
		addChildViewController(_editTextFileUIC)
		view.addSubview(_editTextFileUIC.view)
		UIState.ForWorkspaceModel.Notification.register		(self, EditUIController._process)
	}
	private func _deinstall() {
		UIState.ForWorkspaceModel.Notification.deregister	(self)
		_editTextFileUIC.view.removeFromSuperview()
		_editTextFileUIC.removeFromParentViewController()
		_signboard.removeFromSuperview()
	}
	private func _layout() {
		_signboard.frame	=	view.bounds
	}

	private func _process(n: UIState.ForWorkspaceModel.Notification) {
		guard n.sender === model! else {
			return
		}
		_applyStateToOutput()
	}


	private func _applyStateToOutput() {
		UIState.ForWorkspaceModel.get(model!) {
			_editTextFileUIC.string		=	nil
			_state	=	{ [state = $0] in
				if let u = state.editingSelection {
					do {
						let	string		=	try NSString(contentsOfURL: u, encoding: NSUTF8StringEncoding)
						return	.Text(string as String)
					}
					catch let e {
						return	.Error(e)
					}
				}
				else {
					return	.Empty
				}
			}() as _State


			switch _state {
			case .Empty:
				_signboard.hidden		=	false
				_signboard.headText		=	"No Editor"
				_signboard.bodyText		=	nil
				_editTextFileUIC.view.hidden	=	true
				_editTextFileUIC.string		=	nil
			case .Error(let e):
				_signboard.hidden		=	false
				_signboard.headText		=	"Error"
				_signboard.bodyText		=	"\(e)"
				_editTextFileUIC.view.hidden	=	true
				_editTextFileUIC.string		=	nil
			case .Text(let s):
				_signboard.hidden		=	true
				_signboard.headText		=	nil
				_signboard.bodyText		=	nil
				_editTextFileUIC.view.hidden	=	false
				_editTextFileUIC.string		=	s
			}
		}
	}


}














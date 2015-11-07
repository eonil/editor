//
//  ContextTreeUI.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/11/08.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon



public class ContextTreeUI: CommonView {





	public weak var model: DebuggingModel?





	///

	public override func installSubcomponents() {
		super.installSubcomponents()
		_install()
		_layout()
	}
	public override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	public override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}







	///

	private let _contextView	=	ContextTreeView()

	private func _install() {
		_applyChanges()
		addSubview(_contextView)
		DebuggingModel.Event.Notification.register			(self, ContextTreeUI._process)
		DebuggingTargetModel.Event.Notification.register		(self, ContextTreeUI._process)
		DebuggingTargetExecutionModel.Event.Notification.register	(self, ContextTreeUI._process)
	}
	private func _deinstall() {
		DebuggingTargetExecutionModel.Event.Notification.deregister	(self)
		DebuggingTargetModel.Event.Notification.deregister		(self)
		DebuggingModel.Event.Notification.deregister			(self)
		_contextView.removeFromSuperview()
	}
	private func _layout() {
		_contextView.frame	=	bounds
	}







	private func _process(n: DebuggingModel.Event.Notification) {
		guard n.sender === model else {
			return
		}
		_applyChanges()
	}
	private func _process(n: DebuggingTargetModel.Event.Notification) {
		guard n.sender === model?.currentTarget else {
			return
		}
		_applyChanges()
	}
	private func _process(n: DebuggingTargetExecutionModel.Event.Notification) {
		guard n.sender === model?.currentTarget?.execution else {
			return
		}
		_applyChanges()
	}





	private func _applyChanges() {
		_contextView.reconfigure(model!.debugger)
	}




}









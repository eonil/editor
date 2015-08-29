//
//  ContextTreeUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper
import MulticastingStorage
import EditorCommon
import EditorModel
import EditorUICommon
import EditorDebugUI

class ContextTreeUIController: CommonUIController {

	weak var model: DebuggingModel? 

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

	private let	_treeView	=	ContextTreeView()
//	private let	_targetsAgent	=	_TargetArrayAgent()
	private let	_waitingQueue	=	dispatch_queue_create("ContextTreeUIController/DebuggerEventWaiter", DISPATCH_QUEUE_SERIAL)
	private var	_isRunning	=	false

	private func _install() {
		assert(model != nil)
		_treeView.reconfigure(model!.debugger)
		_treeView.onUserDidSelectFrame		=	{ [weak self] in
			self?._didSelectFrame()
		}
		_treeView.onUserWillDeselectFrame	=	{ [weak self] in
			self?._willDeselectFrame()
		}
		view.addSubview(_treeView)

		_isRunning	=	true
		_waitDebuggerEvents()
//		model!.targets.register(_targetsAgent)
	}
	private func _deinstall() {
		assert(model != nil)

		_isRunning	=	false

		_treeView.removeFromSuperview()
		_treeView.onUserWillDeselectFrame	=	nil
		_treeView.onUserDidSelectFrame		=	nil
		_treeView.reconfigure(nil)
	}
	private func _layout() {
		_treeView.frame	=	view.bounds
	}

	///

	private func _didSelectFrame() {
		model!.selection.selectFrame(_treeView.currentFrame!)
	}
	private func _willDeselectFrame() {
		model!.selection.deselectFrame()
	}

	///

	private func _waitDebuggerEvents() {
		guard _isRunning == true else {
			return
		}

		let	dbg	=	model!.debugger
		dispatch_async(_waitingQueue) { [weak self] in
			Debug.assertNonMainThread()
			if let e = dbg.listener.waitForEvent(1) {
				dispatchToMainQueueAsynchronously { [weak self] in
					Debug.assertMainThread()
					self?._processEvent(e)
					self?._waitDebuggerEvents()
				}
			}
			else {
				dispatchToMainQueueAsynchronously { [weak self] in
					Debug.assertMainThread()
					self?._waitDebuggerEvents()
				}
			}
		}
	}

	private func _processEvent(e: LLDBEvent) {
		Debug.assertMainThread()
		Debug.log(e)
		_treeView.reconfigure(model!.debugger)
		_waitDebuggerEvents()
	}
//	private func _didSetProcessState() {
//
//	}
}


private final class _TargetArrayAgent: ArrayStorageDelegate {
	weak var owner: ContextTreeUIController?
	private func willInsertRange(range: Range<Int>) {

	}
	private func didInsertRange(range: Range<Int>) {

	}
	private func willUpdateRange(range: Range<Int>) {

	}
	private func didUpdateRange(range: Range<Int>) {

	}
	private func willDeleteRange(range: Range<Int>) {

	}
	private func didDeleteRange(range: Range<Int>) {

	}
}


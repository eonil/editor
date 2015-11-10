//
//  DebugNavigatorUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/11.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel
import EditorUICommon

class DebuggingNavigatorUIController: CommonViewController {


	weak var model: DebuggingModel? {
		didSet {
			_frameStackTreeUIC.model	=	model
			_frameVariableTreeUIC.model	=	model
		}
	}




	///

	override func viewDidLoad() {
		super.viewDidLoad()

		let	stackItem			=	NSSplitViewItem(viewController: _frameStackTreeUIC)
		stackItem.minimumThickness		=	100
		stackItem.preferredThicknessFraction	=	0.5
		let	varItem				=	NSSplitViewItem(viewController: _frameVariableTreeUIC)
		varItem.minimumThickness		=	100
		varItem.preferredThicknessFraction	=	0.5

		_splitViewController.splitView.vertical	=	false
		_splitViewController.splitViewItems	=	[
			stackItem,
			varItem,
		]

		addChildViewController(_splitViewController)
		view.addSubview(_splitViewController.view)
	}
	override func viewDidLayout() {
		super.viewDidLayout()
		_splitViewController.view.frame		=	view.bounds
	}









	///

	private let	_splitViewController		=	NSSplitViewController()
	private let	_frameStackTreeUIC		=	ContextTreeUIController()
	private let	_frameVariableTreeUIC		=	VariableTreeUIController()
}









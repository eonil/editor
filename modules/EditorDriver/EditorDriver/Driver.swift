//
//  Driver.swift
//  EditorDriver
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import MulticastingStorage
import EditorModel
import EditorShell
import EditorUICommon



public class Driver {

	public static var theDriver: Driver {
		get {
			assert(_currentDriver != nil, "Current driver has not yet been set.")
			return	_currentDriver!
		}
	}
	private static var	_currentDriver: Driver?

	///

	public init() {
		assert(Driver._currentDriver == nil)
		Driver._currentDriver	=	self

		initializeModelModule()
	}
	deinit {
		terminateModelModule()

		assert(Driver._currentDriver === self)
		Driver._currentDriver	=	nil
	}

	///

	public var model: ApplicationModel {
		get {
			return	_model
		}
	}
	
	public func run() {
		Platform.initiate(_cocoaPlatform)
		UIState.initiate()

		_ui.model	=	_model
		_ui.run()
		_model.run()

		//	TODO:	Remove this on release...
		//		ADHOC booting.

		_model.openWorkspaceAtURL(NSURL(fileURLWithPath: "/Users/Eonil/Documents/Editor2Test/aaa"))
	}

	public func halt() {

		_model.halt()
		_ui.halt()
		_ui.model	=	nil

		UIState.terminate()
		Platform.terminate()
	}

	///

	private let	_cocoaPlatform		=	CocoaPlatform()

	private let	_ui			=	ApplicationUIController()
	private let	_model			=	ApplicationModel()

}




















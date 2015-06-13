//
//  WorkspaceMainWindowController.swift
//  Editor
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import AppKitExtras
import SignalGraph
import EditorCommon
import EditorUIComponents
import EditorWorkspaceNavigationFeature
import EditorIssueListingFeature
import EditorDebuggingFeature
import EditorModel





class WorkspaceMainWindowController: NSWindowController {
	init() {
		super.init(window: _makeMainWindow())
		_install()
		_connect()
	}
	@availability(*,unavailable)
	required init?(coder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	deinit {
		assert(_installed == false)
	}
	
	///	You MUST set this BEFORE adding this view to a window
	///	and should not change until this view to be removed from the window.
	weak var palette: UIPalette? {
		willSet {
			assert(_installed == false)
		}
		didSet {
			
		}
	}
	
	@availability(*,unavailable)
	override func loadWindow() {
		super.loadWindow()
	}
	@availability(*,unavailable)
	override func windowDidLoad() {
		super.windowDidLoad()
	}
	
	///

	private let 	_windowAgent	=	_OBJCWindowAgent()
	
	private var	_installed	=	false
	private var	_toolbarCon	:	ToolbarController?
	private var	_mainView	:	MainView?
	
	private var	_channelings	:	[Channeling]?
	
	private func _install() {
		func test1() -> NSView {
			let	v	=	SegmentOptionView()
			v.configuration	=	SegmentOptionView.Configuration(selectionMode: SegmentOptionView.SelectionMode.Any, options: [
				SegmentOptionView.Option(displayText: "Navigation", onSelect: {}, onDeselect: {}),
				SegmentOptionView.Option(displayText: "Editor", onSelect: {}, onDeselect: {}),
				SegmentOptionView.Option(displayText: "Inspector", onSelect: {}, onDeselect: {}),
				])
			v.sizeToFit()
			return	v
		}
		typealias	ToolItem	=	ToolbarController.ToolItem
		assert(_installed == false)
		_toolbarCon				=	ToolbarController(identifier: "MainWindowToolbar")
		_toolbarCon!.configuration		=	[
			ToolbarController.ToolItem.flexibleSpace(),
			_customViewToolItem("Panes", test1()),
		]
		_toolbarCon!.toolbar.displayMode	=	NSToolbarDisplayMode.IconAndLabel
		_mainView		=	MainView()
		window!.toolbar		=	_toolbarCon!.toolbar
		window!.contentView	=	_mainView!
		window!.titleVisibility	=	NSWindowTitleVisibility.Hidden
		_installed		=	true
		
		_mainView!.addSubview(test1())
	}
	private func _deinstall() {
		assert(_installed == true)
		window!.contentView	=	NSView()
		window!.toolbar		=	nil
		_mainView		=	nil
		_toolbarCon!.configuration	=	nil
		_toolbarCon		=	nil
		_installed		=	false
	}
	
	private func _connect() {
		assert(window!.delegate === nil)
		_windowAgent.owner	=	self
		window!.delegate	=	_windowAgent
		_channelings		=	[
//			Channeling(palette!.inspectorPaneDisplay, { [weak self] in self!._onInspectorPaneDisplaySignal($0) }),
		]
	}
	private func _disconnect() {
		assert(window!.delegate === _windowAgent)
		_channelings		=	nil
		window!.delegate	=	nil
		_windowAgent.owner	=	nil
	}
	
}

@objc
private class _OBJCWindowAgent: NSObject, NSWindowDelegate {
	weak var owner: WorkspaceMainWindowController?
	
	@objc
	func windowWillClose(notification: NSNotification) {
		assert(owner != nil)
		if let owner = owner {
			owner._disconnect()
			owner._deinstall()
		}
	}
}

private func _makeMainWindow() -> NSWindow {
	let	window		=	NSWindow()
	window.styleMask	=	NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
	
	let	USE_DARK_MODE	=	true
	if USE_DARK_MODE {
//		window.titlebarAppearsTransparent	=	true
		window.appearance			=	NSAppearance(named: NSAppearanceNameVibrantDark)
		window.invalidateShadow()
		
		func makeDark(b:NSButton, alpha:CGFloat) {
			let	f	=	CIFilter(name: "CIColorMonochrome")
			f.setDefaults()
//			f.setValue(CIColor(red: 0.5, green: 0.3, blue: 0.5, alpha: alpha), forKey: "inputColor")		//	I got this number accidentally, and I like this tone.
			f.setValue(CIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: alpha), forKey: "inputColor")
//
//			let	f1	=	CIFilter(name: "CIGammaAdjust")
//			f1.setDefaults()
//			f1.setValue(0.3, forKey: "inputPower")
//
//			let	f2	=	CIFilter(name: "CIColorInvert")
//			f2.setDefaults()
			
			b.contentFilters	=	[f]
		}
		
		makeDark(window.standardWindowButton(NSWindowButton.CloseButton)!, 1.0)
		makeDark(window.standardWindowButton(NSWindowButton.MiniaturizeButton)!, 1.0)
		makeDark(window.standardWindowButton(NSWindowButton.ZoomButton)!, 1.0)
	}
	return	window
}







//private func _plainButtonToolItem(label: String, handler: ()->()) -> ToolbarController.ToolItem {
//	return	ToolbarController.ToolItem(label: label, size: (CGSize.zeroSize, CGSize.zeroSize), view: nil, handler: handler, _itemIdentifier: _makeID())
//}
private func _customViewToolItem(label: String, view: NSView) -> ToolbarController.ToolItem {
	let	sz	=	(view.frame.size, view.frame.size)
	return	ToolbarController.ToolItem(identifier: _makeID(), label: label, size: sz, view: view, handler: {})
}

private func _makeID() -> String {
	Debug.assertMainThread()
	struct Local {
		static var	seed	=	0
	}
	Local.seed++
	return	"ToolbarController.ToolItem.ItemIdentifier.AUTOGENERATION#\(Local.seed)"
}





//func findTextField(v: NSView) -> [NSTextField] {
//	var	fs	=	[] as [NSTextField]
//	if let v1 = v as? NSTextField {
//		fs.append(v1)
//	}
//	for v1 in v.subviews {
//		fs.extend(findTextField(v1 as! NSView))
//	}
//	return	fs
//}
//







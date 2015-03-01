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
import EditorCommon
import EditorUIComponents
import EditorWorkspaceNavigationFeature
import EditorIssueListingFeature
import EditorDebuggingFeature









///	Manages main window for workspace management.
///
///	This manages only window and views and does not perform any back-end operations.
///	
final class WorkspaceMainWindowController: EditorCommonWindowController3 {
	var fileNavigationViewController: WorkspaceNavigationViewController {
		get {
			assert(internals != nil)
			return	internals!.fileNavigationViewController
		}
	}
	var codeEditingViewController: CodeEditingViewController {
		get {
			assert(internals != nil)
			return	internals!.codeEditingViewController
		}
	}
	var issueReportingViewController: IssueListingViewController {
		get {
			assert(internals != nil)
			return	internals!.issueReportingViewController
		}
	}
	var executionNavigationViewController: ExecutionStateTreeViewController {
		get {
			assert(internals != nil)
			return	internals!.executionNavigationViewController
		}
	}
	var variableInspectingViewController: VariableTreeViewController {
		get {
			assert(internals != nil)
			return	internals!.variableInspectingViewController
		}
	}
	
	override func instantiateWindow() -> NSWindow {
		return	makeMainWindow()
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		////
		
		internals	=	InternalController(owner: self)
	}
	
	private var	internals	=	nil as InternalController?
}


private func makeMainWindow() -> NSWindow {
	let	window	=	NSWindow()
	window.styleMask	=	NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
	
	let	USE_DARK_MODE	=	true
	if USE_DARK_MODE {
		//			window.titlebarAppearsTransparent	=	true
		window.appearance	=	NSAppearance(named: NSAppearanceNameVibrantDark)
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

































































///	MARK:
///	MARK:	InternalController

private final class InternalController {
	unowned var owner						:	WorkspaceMainWindowController
	
	let	fileNavigationViewController		=	WorkspaceNavigationViewController()
	let	codeEditingViewController			=	CodeEditingViewController()
	let	issueReportingViewController		=	IssueListingViewController()
	let	executionNavigationViewController	=	ExecutionStateTreeViewController()
	let	variableInspectingViewController	=	VariableTreeViewController()
	
	let	mainSplitViewController				=	NSSplitViewController()
	let	centerSplitViewController			=	NSSplitViewController()
	let	leftPaneViewController				=	MultipaneViewController()
	let	rightPaneViewController				=	MultipaneViewController()
	
	init(owner: WorkspaceMainWindowController) {
		self.owner	=	owner
		
		self.configureViews()
	}
	deinit {
		
	}
	
	var window:NSWindow {
		get {
			return	owner.window!
		}
	}
	func configureViews() {
		
		mainSplitViewController.splitView.vertical		=	true
		centerSplitViewController.splitView.vertical	=	false
		
		fileNavigationViewController.view.translatesAutoresizingMaskIntoConstraints			=	false
		issueReportingViewController.view.translatesAutoresizingMaskIntoConstraints			=	false
		executionNavigationViewController.view.translatesAutoresizingMaskIntoConstraints	=	false
		
		window.contentViewController	=	mainSplitViewController
		mainSplitViewController.addChildViewControllerAsASplitViewItem(leftPaneViewController)
		mainSplitViewController.addChildViewControllerAsASplitViewItem(centerSplitViewController)
		
		centerSplitViewController.addChildViewControllerAsASplitViewItem(codeEditingViewController)
		centerSplitViewController.addChildViewControllerAsASplitViewItem(variableInspectingViewController)
		leftPaneViewController.pages	=	[
			MultipaneViewController.Page(labelText: "Files", viewController: fileNavigationViewController),
			MultipaneViewController.Page(labelText: "Issues", viewController: issueReportingViewController),
			MultipaneViewController.Page(labelText: "Debug", viewController: executionNavigationViewController),
		]
		
		////
		
//		window.setFrame(CGRect(x: 0, y: 0, width: 100, height: 100), display: true)
		
		mainSplitViewController.view.addConstraints([
			NSLayoutConstraint(item: centerSplitViewController.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CONTENT_PANE_MIN_WIDTH).always,
			NSLayoutConstraint(item: centerSplitViewController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: CONTENT_PANE_MIN_HEIGHT).always,
			
			NSLayoutConstraint(item: leftPaneViewController.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: NAVIGATION_PANE_MIN_WIDTH).always,
			NSLayoutConstraint(item: variableInspectingViewController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: VARIABLE_INSPECTOR_MIN_HEIGHT).always,
			
			NSLayoutConstraint(item: leftPaneViewController.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: NAVIGATION_PANE_MIN_WIDTH).weak,
			NSLayoutConstraint(item: variableInspectingViewController.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: VARIABLE_INSPECTOR_MIN_HEIGHT).weak,
			])
	}
}


private extension NSLayoutConstraint {
	var always:NSLayoutConstraint {
		get {
			return	reprioritize(1000)
		}
	}
	var	strong:NSLayoutConstraint {
		get {
			return	reprioritize(750)
		}
	}
	var	weak:NSLayoutConstraint {
		get {
			return	reprioritize(250)
		}
	}
	private func reprioritize(p:NSLayoutPriority) -> NSLayoutConstraint {
		let	c	=	NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: self.multiplier, constant: self.constant)
		c.priority	=	p
		return	c
	}
}

private let	CONTENT_PANE_MIN_WIDTH			:	CGFloat		=	400
private let	CONTENT_PANE_MIN_HEIGHT			:	CGFloat		=	300

private let	NAVIGATION_PANE_MIN_WIDTH		:	CGFloat		=	200
private let	VARIABLE_INSPECTOR_MIN_HEIGHT	:	CGFloat		=	100
















































//
//
/////	MARK:
/////	MARK:	InternalController (IssueListingViewControllerDelegate)
//
//extension InternalController: WorkspaceBuildController {
//	
//}
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
//
//
//
//
//
/////	MARK:
/////	MARK:	InternalController (IssueListingViewControllerDelegate)
//
//extension InternalController: IssueListingViewControllerDelegate {
//	
//}
//












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

class WorkspaceMainWindowController: HygienicWindowController2 {
	override func instantiateContentViewController() -> NSViewController {
		return	SplitVC()
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		
		let	USE_DARK_MODE	=	true
		if USE_DARK_MODE {
			window!.appearance	=	NSAppearance(named: NSAppearanceNameVibrantDark)
			window!.invalidateShadow()
			
			func makeDark(b:NSButton) {
				b.alphaValue	=	0.5
			}
			makeDark(window!.standardWindowButton(NSWindowButton.CloseButton)!)
			makeDark(window!.standardWindowButton(NSWindowButton.MiniaturizeButton)!)
			makeDark(window!.standardWindowButton(NSWindowButton.ZoomButton)!)
		}
	}
}
















@objc
private class SplitVC: NSSplitViewController {
	private let	editingViewController		=	EditingVC()
	let	navigationViewController			=	NavVC()
//	let	utilityViewController				=	UtilityViewController()
	
	private var	_channels	=	[] as [AnyObject]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.splitView.vertical	=	true
		self.addChildViewControllerAsASplitViewItem(navigationViewController)
		self.addChildViewControllerAsASplitViewItem(editingViewController)
		//			self.addChildViewControllerAsASplitViewItem(utilityViewController)

		
		//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
		self.splitView.layoutConstraints	=	[
			editingViewController..width >= 400,
			navigationViewController..width >= 200,
			
			editingViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 3,
			navigationViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 2,
			//				utilityViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 1,
		]
		
		_channels	=	[
			channel(navigationViewController.issueListingViewController.userIsWantingToHighlightIssues, editingViewController.codeEditorViewController.highlightRangesOfIssues),
			channel(navigationViewController.issueListingViewController.userIsWantingToNavigateToIssue, editingViewController.codeEditorViewController.navigateRangeOfIssue),
			channel(navigationViewController.fileTreeViewController.userIsWantingToEditFileAtURL) { [unowned self] u in
				self.editingViewController.codeEditorViewController.URLRepresentation	=	u
			},
		]
	}
	override func viewDidAppear() {
		super.viewDidAppear()
	}
	
	
}



@objc
private class EditingVC: NSSplitViewController {
	let	commandScrollViewController		=	ScrollViewController()
	
	let	codeEditorViewController		=	CodeEditingViewController()
	let	commandConsoleViewController	=	CommandConsoleViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		commandScrollViewController.documentViewController	=	commandConsoleViewController
		
		self.splitView.vertical	=	false
		self.addChildViewControllerAsASplitViewItem(codeEditorViewController)
		self.addChildViewControllerAsASplitViewItem(commandScrollViewController)
		
		//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
		self.view.layoutConstraints	=	[
			codeEditorViewController..height >= 300,
			commandScrollViewController..height >= 100,
			codeEditorViewController..height >= 800 ~~ 3,
			commandScrollViewController..height >= 200 ~~ 2
		]
	}
}

@objc
private class NavVC: NSSplitViewController {
	let	fileTreeScrollViewController	=	ScrollViewController()
	let	issueScrollingViewController	=	ScrollViewController()
	
	let	fileTreeViewController			=	FileTreeViewController4()
	let	issueListingViewController		=	IssueListingViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fileTreeScrollViewController.documentViewController		=	fileTreeViewController
		issueScrollingViewController.documentViewController		=	issueListingViewController
		
		self.splitView.vertical	=	false
		self.addChildViewControllerAsASplitViewItem(fileTreeScrollViewController)
		self.addChildViewControllerAsASplitViewItem(issueScrollingViewController)
		
		//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
		self.view.layoutConstraints	=	[
			fileTreeScrollViewController..height >= 100,
			issueScrollingViewController..height >= 100,
			fileTreeScrollViewController..height >= 400 ~~ 3,
			issueScrollingViewController..height >= 200 ~~ 2,
		]
	}
}









private let	EDITOR_WIDTH_PREFEREED		=	600 as CGFloat
private let	EDITOR_WIDTH_MINIMUM		=	200 as CGFloat
private let	REPORTER_WIDTH_PREFERRED	=	300 as CGFloat
private let	REPORTER_WIDTH_MINIMUM		=	100 as CGFloat


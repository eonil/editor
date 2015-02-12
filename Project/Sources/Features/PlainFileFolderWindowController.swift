//
//  PlainFileFolderWindowController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorFileTreeNavigationFeature
import EditorIssueListingFeature

///	A window shows a plain folder with plain files.
///	This does not do anything special on the file and folders.
///	Everything is editable as a plain file.
///
///	This provides UI, but does not wire up event delegates.
///	So you need to handle them yourself.
///
///	-	Use `fileTreeViewController.delegate` to get notified for file tree UI.
///
class PlainFileFolderWindowController : HygienicWindowController2 {
	
	var	fileTreeViewController:FileTreeViewController4 {
		get {
			return	self.mainViewController.navigationViewController.fileTreeViewController
		}
	}
	var mainViewController:MainViewController {
		get {
			return	self.contentViewController as! MainViewController
		}
	}
	var codeEditingViewController:CodeEditingViewController {
		get {
			return	mainViewController.editingViewController.codeEditorViewController
		}
	}
	var	commandConsoleViewController:CommandConsoleViewController {
		get {
			return	mainViewController.editingViewController.commandConsoleViewController
		}
	}
	var issueListingViewController: IssueListingViewController {
		get {
			return	mainViewController.navigationViewController.issueListingViewController
		}
	}

	
	
	
	
//	override init() {
//		super.init()
//		self.loadWindow()
//		self.windowDidLoad()
//	}
//	required init?(coder: NSCoder) {
//		super.init(coder: coder)
//	}
//	override init(window: NSWindow?) {
//		super.init(window: window)
//	}
//
//	override func loadWindow() {
//		super.window			=	NSWindow()
//		self.window!.styleMask	|=	NSResizableWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
//	}
//	override func windowDidLoad() {
//		super.windowDidLoad()
//		self.contentViewController	=	mainViewController
//	}
	
	override func instantiateContentViewController() -> NSViewController {
//		let	c1				=	NSVisualEffectView()
//		c1.material			=	NSVisualEffectMaterial.AppearanceBased
//		c1.blendingMode		=	NSVisualEffectBlendingMode.BehindWindow
//		c1.state			=	NSVisualEffectState.FollowsWindowActiveState
//		c1.needsDisplay		=	true
//		
		return	MainViewController()
	}
	override func instantiateWindow() -> NSWindow {
		let	window	=	NSWindow()
		window.styleMask	=	NSResizableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask

		let	USE_DARK_MODE	=	true
		if USE_DARK_MODE {
//			window.titlebarAppearsTransparent	=	true
			window.appearance	=	NSAppearance(named: NSAppearanceNameVibrantDark)
			window.invalidateShadow()
			
			func makeDark(b:NSButton) {
				b.alphaValue	=	0.5
			}
			makeDark(window.standardWindowButton(NSWindowButton.CloseButton)!)
			makeDark(window.standardWindowButton(NSWindowButton.MiniaturizeButton)!)
			makeDark(window.standardWindowButton(NSWindowButton.ZoomButton)!)
		}
		return	window
	}
	
}























extension PlainFileFolderWindowController {
	
	class MainViewController : NSSplitViewController {
		private let	editingViewController		=	EditingViewController()
		let	navigationViewController			=	NavigationViewController()
//		let	utilityViewController				=	UtilityViewController()
		
//		private var	_channels	=	[] as [AnyObject]
		
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
//				utilityViewController..width >= 200,
//				codeEditingViewController..width >= 800 ~~ 100,
//				navigationViewController..width >= 300 ~~ 90,
//				utilityViewController..width >= 300 ~~ 11,
				
				editingViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 3,
				navigationViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 2,
//				utilityViewController..width >= NSScreen.mainScreen()!.frame.width ~~ 1,
			]
			
//			_channels	=	[
//				channel(navigationViewController.issueListingViewController.userIsWantingToHighlightIssues, editingViewController.codeEditorViewController.highlightRangesOfIssues),
//				channel(navigationViewController.issueListingViewController.userIsWantingToNavigateToIssue, editingViewController.codeEditorViewController.navigateRangeOfIssue),
//			]
		}
		override func viewDidAppear() {
			super.viewDidAppear()
		}
		
		
	}
	
	
	
	
	class EditingViewController : NSSplitViewController {
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
	
	class NavigationViewController : NSSplitViewController {
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
	
//	class UtilityViewController : NSSplitViewController {
//		let	commandConsoleViewController	=	CommandConsoleViewController()
//		
//		override func viewDidLoad() {
//			super.viewDidLoad()
//			
//			self.splitView.vertical	=	false
//			self.addChildViewControllerAsASplitViewItem(commandConsoleViewController)
//
//			//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
//			self.view.layoutConstraints	=	[
//				commandConsoleViewController..height >= 100,
////				commandConsoleViewController..height == 100 ~~ 1,
//			]
//		}
//	}

	
	
	



	
}









private let	EDITOR_WIDTH_PREFEREED		=	600 as CGFloat
private let	EDITOR_WIDTH_MINIMUM		=	200 as CGFloat
private let	REPORTER_WIDTH_PREFERRED	=	300 as CGFloat
private let	REPORTER_WIDTH_MINIMUM		=	100 as CGFloat


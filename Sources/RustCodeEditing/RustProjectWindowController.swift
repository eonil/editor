//
//  RustProjectWindowController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

import Foundation
import AppKit

class RustProjectWindowController : NSWindowController {
	let	mainSplitViewController	=	MainSplitViewController()
	
	override init() {
		super.init()
		self.loadWindow()
		self.windowDidLoad()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	override init(window: NSWindow?) {
		super.init(window: window)
	}

	override func loadWindow() {
		super.window			=	NSWindow()
		self.window!.styleMask	|=	NSResizableWindowMask | NSMiniaturizableWindowMask | NSClosableWindowMask
	}
	override func windowDidLoad() {
		super.windowDidLoad()
		self.contentViewController	=	mainSplitViewController
	}
}





extension RustProjectWindowController {
	
	class MainSplitViewController : NSSplitViewController {
		let	codeEditingViewController		=	CodeEditingViewController()
		let	sideSplitViewController			=	SideSplitViewController()
		
		private var	_channels	=	[] as [AnyObject]
		
		override func viewDidLoad() {
			super.viewDidLoad()
			
			self.splitView.vertical	=	true
			self.addChildViewController(sideSplitViewController)
			self.addChildViewController(codeEditingViewController)
			self.addSplitViewItem(NSSplitViewItem(viewController: sideSplitViewController))
			self.addSplitViewItem(NSSplitViewItem(viewController: codeEditingViewController))

			//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
			self.view.layoutConstraints	=	[
				codeEditingViewController..width >= EDITOR_WIDTH_MINIMUM ~~ 5,
				sideSplitViewController..width >= REPORTER_WIDTH_MINIMUM ~~ 4,
				codeEditingViewController..width >= EDITOR_WIDTH_PREFEREED ~~ 3,
//				codeEditingViewController..width >= CGFloat.max ~~ 2,
				sideSplitViewController..width == REPORTER_WIDTH_PREFERRED ~~ 1,
			]

			_channels	=	[
				channel(sideSplitViewController.issueListingViewController.userIsWantingToHighlightIssues, codeEditingViewController.highlightRangesOfIssues),
				channel(sideSplitViewController.issueListingViewController.userIsWantingToNavigateToIssue, codeEditingViewController.navigateRangeOfIssue),
			]
		}
		override func viewDidAppear() {
			super.viewDidAppear()
			
			sideSplitViewController.fileTreeViewController.pathRepresentation	=	"/Users/Eonil/Documents"
		}
		
		
	}
	
	
	
	
	
	
	class SideSplitViewController : NSSplitViewController {
		let	fileTreeScrollViewController	=	ScrollViewController()
		let	fileTreeViewController			=	FileTreeViewController()
		let	resultPrintingViewController	=	ResultPrintingViewController()
		let	issueListingViewController		=	IssueListingViewController()
		let	issueScrollingViewController	=	ScrollViewController()
		
		override func viewDidLoad() {
			super.viewDidLoad()
			
			fileTreeScrollViewController.documentViewController	=	fileTreeViewController
			
			self.splitView.vertical	=	false
			self.addChildViewController(fileTreeScrollViewController)
			self.addSplitViewItem(NSSplitViewItem(viewController: fileTreeScrollViewController))
			self.addChildViewController(resultPrintingViewController)
			self.addSplitViewItem(NSSplitViewItem(viewController: resultPrintingViewController))
			self.addChildViewController(issueScrollingViewController)
			self.addSplitViewItem(NSSplitViewItem(viewController: issueScrollingViewController))
			issueScrollingViewController.documentViewController	=	issueListingViewController

			//	The priority constant doesn't work in Xcode 6.1. I am not sure that is a bug or feature.
			self.view.layoutConstraints	=	[
				fileTreeScrollViewController..height >= 100,
				resultPrintingViewController..height >= 100,
				issueScrollingViewController..height >= 100,
				fileTreeScrollViewController..height >= 400 ~~ 3,
				issueScrollingViewController..height >= 100 ~~ 2,
				resultPrintingViewController..height == 100 ~~ 1,
			]
		}
	}

	class ResultPrintingViewController : TextScrollViewController {
		override func viewDidAppear() {
			super.viewDidAppear()
			self.textViewController.textView.font	=	Palette.current.codeFont
		}
	}



	
}









private let	EDITOR_WIDTH_PREFEREED		=	600 as CGFloat
private let	EDITOR_WIDTH_MINIMUM		=	200 as CGFloat
private let	REPORTER_WIDTH_PREFERRED	=	300 as CGFloat
private let	REPORTER_WIDTH_MINIMUM		=	100 as CGFloat


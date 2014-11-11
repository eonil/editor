//
//  RustSourceCodeFileDocument.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/11/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

class RustSourceCodeFileDocument : NSDocument {
	let	projectWindowController	=	RustProjectWindowController()
	let	programExecutionController	=	RustProgramExecutionController()
	
	override func makeWindowControllers() {
		super.makeWindowControllers()
		self.addWindowController(projectWindowController)
	}
	
	override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
		let	s1	=	projectWindowController.codeEditingViewController.textViewController.textView.string!
		let	d1	=	s1.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		return	d1
	}
	
	override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
		let	s1	=	NSString(data: data, encoding: NSUTF8StringEncoding)!
		projectWindowController.codeEditingViewController.textViewController.textView.string	=	s1
		let	p2	=	self.fileURL!.path!
		let	p3	=	p2.stringByDeletingLastPathComponent
		projectWindowController.mainViewController.navigationViewController.fileTreeViewController.pathRepresentation	=	p3
		return	true
	}
	
	
	
	
	
	
	
	
	
	override class func autosavesInPlace() -> Bool {
		return true
	}
}

extension RustSourceCodeFileDocument {
	
	@IBAction
	func menuProjectRun(sender:AnyObject?) {
		if let u1 = self.fileURL {
			self.saveDocument(self)
			let	srcFilePath1	=	u1.path!
			let	srcDirPath1		=	srcFilePath1.stringByDeletingLastPathComponent
			let	outFilePath1	=	srcDirPath1.stringByAppendingPathComponent("program.executable")
			let	conf1			=	RustProgramExecutionController.Configuration(sourceFilePaths: [srcFilePath1], outputFilePath: outFilePath1, extraArguments: ["-Z", "verbose"])
			//			let	s1	=	mainEditorWindowController.splitter.codeEditingViewController.textViewController.textView.string!
			let	r1	=	programExecutionController.execute(conf1)
			projectWindowController.commandConsoleViewController.textView.string	=	r1
			
			let	ss1		=	IssueReportParser().parse(r1, filePath: srcFilePath1)
			projectWindowController.mainViewController.navigationViewController.issueListingViewController.issues	=	ss1
			
		} else {
			NSAlert(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "This file has not been save yet. Cannot compile now."])).runModal()
		}
	}
	
}




//
//  MockPlatformWithPseudoFileSystem.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/31.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

class MockPlatformWithPseudoFileSystem: MockPlatform {
	/// Pseudo file system.
	var fileContentMappings	=	[NSURL: NSData]()
	override init() {
		super.init()
		testFileSystem.testDelegate.createFileAtURL			=	{ [weak self] (u: NSURL)->() in
			self!.fileContentMappings[u]	=	NSData()
		}
		testFileSystem.testDelegate.deleteFileAtURL			=	{ [weak self] (u: NSURL)->() in
			self!.fileContentMappings[u]	=	nil
		}
		testFileSystem.testDelegate.contentOfFileAtURLAtomically	=	{ [weak self] (u: NSURL)->NSData in
			
			precondition(self!.fileContentMappings[u] != nil, "File content does not exist for URL `\(u.absoluteString)` ")
			return	self!.fileContentMappings[u]!
		}
		testFileSystem.testDelegate.setContentOfFileAtURLAtomically	=	{ [weak self] (u: NSURL, data: NSData)->() in
			self!.fileContentMappings[u]	=	data
		}
	}
	deinit {
		testFileSystem.testDelegate.setContentOfFileAtURLAtomically	=	nil
		testFileSystem.testDelegate.contentOfFileAtURLAtomically	=	nil
		testFileSystem.testDelegate.deleteFileAtURL			=	nil
		testFileSystem.testDelegate.createFileAtURL			=	nil
	}
}
//
//  MockPlatform.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/30.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

class MockPlatform: PlatformProtocol {
	var fileSystem: PlatformFileSystemProtocol {
		get {
			return	testFileSystem
		}
	}

	let	testFileSystem	=	MockPlatformFileSystem()
}

class MockPlatformFileSystem: PlatformFileSystemProtocol {

	struct TestDelegate {
		var createFileAtURL: ((NSURL)->())?
		var deleteFileAtURL: ((NSURL)->())?
		var contentOfFileAtURLAtomically: ((NSURL)->NSData)?
		var setContentOfFileAtURLAtomically: ((NSURL, data: NSData)->())?
	}

	var testDelegate	=	TestDelegate()

	func createFileAtURL(u: NSURL) throws {
		testDelegate.createFileAtURL!(u)
	}
	func deleteFileAtURL(u: NSURL) throws {
		testDelegate.deleteFileAtURL!(u)
	}
	func contentOfFileAtURLAtomically(u: NSURL) throws -> NSData {
		return	testDelegate.contentOfFileAtURLAtomically!(u)
	}
	func replaceContentOfFileAtURLAtomically(u: NSURL, data: NSData) throws {
		testDelegate.setContentOfFileAtURLAtomically!(u, data: data)
	}
}
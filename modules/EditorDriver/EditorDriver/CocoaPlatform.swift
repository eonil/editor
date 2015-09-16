//
//  CocoaPlatform.swift
//  EditorDriver
//
//  Created by Hoon H. on 2015/09/01.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorModel

class CocoaPlatform: PlatformProtocol {

	var fileSystem: PlatformFileSystemProtocol {
		get {
			return	_fileSystem
		}
	}

	private let	_fileSystem	=	CocoaPlatformFileSystem()

}

class CocoaPlatformFileSystem: PlatformFileSystemProtocol {

	func createDirectoryAtURL(u: NSURL, recursively: Bool) throws {
		do {
			try NSFileManager.defaultManager().createDirectoryAtURL(u, withIntermediateDirectories: recursively, attributes: [:])
		}
		catch let error as NSError {
			if error.domain == NSCocoaErrorDomain {
				if error.code == NSFileWriteFileExistsError {
					throw PlatformFileSystemError.AlreadyExists
				}
			}
			throw error
		}
	}

	func deleteDirectoryAtURL(u: NSURL, recursively: Bool) throws {
		precondition(recursively == true)
		try NSFileManager.defaultManager().removeItemAtURL(u)
	}

	///

	func createFileAtURL(u: NSURL) throws {
		NSFileManager.defaultManager().createFileAtPath(u.path!, contents: nil, attributes: [:])
	}

	func deleteFileAtURL(u: NSURL) throws {
		try NSFileManager.defaultManager().removeItemAtPath(u.path!)
	}

	func contentOfFileAtURLAtomically(u: NSURL) throws -> NSData {
		return	NSData(contentsOfURL: u)!
	}

	func replaceContentOfFileAtURLAtomically(u: NSURL, data: NSData) throws {
		data.writeToURL(u, atomically: true)
	}

}
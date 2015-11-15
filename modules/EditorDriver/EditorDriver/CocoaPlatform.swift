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

	///

	func createFileAtURL(u: NSURL) throws {
		NSFileManager.defaultManager().createFileAtPath(u.path!, contents: nil, attributes: [:])
	}

	func deleteFileSystemNodeAtURL(u: NSURL) throws {
		try NSFileManager.defaultManager().removeItemAtURL(u)
	}
	func moveFile(fromURL fromURL: NSURL, toURL: NSURL) throws {
		try NSFileManager.defaultManager().moveItemAtURL(fromURL, toURL: toURL)
	}

	func trashFileSystemNodesAtURL(u: NSURL) throws {
		try NSFileManager.defaultManager().trashItemAtURL(u, resultingItemURL: nil)
	}


	func contentOfFileAtURLAtomically(u: NSURL) throws -> NSData {
		return	try NSData(contentsOfURL: u, options: [NSDataReadingOptions.DataReadingUncached])
	}

	func replaceContentOfFileAtURLAtomically(u: NSURL, data: NSData) throws {
		data.writeToURL(u, atomically: true)
	}

}

























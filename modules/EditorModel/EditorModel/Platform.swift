//
//  Platform.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/08/30.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

/// Provides platform features to model internals.
public final class Platform {
	public static var thePlatform: PlatformProtocol {
		get {
			assert(_thePlatform != nil, "You must `initiate` with a platform object before this object to be used by anyone.")
			return	_thePlatform!
		}
	}

	/// Initiates platform.
	///
	/// - Parameters:
	///	- implementation
	///		Provides actual implementation of platform features.
	/// 		You are responsible to keep the passing-in implementation
	///		object. This does not keep a strong reference to it.
	///
	public static func initiate(implementation: PlatformProtocol) {
		assert(_thePlatform === nil)
		_thePlatform	=	implementation
	}
	public static func terminate() {
		assert(_thePlatform !== nil)
		_thePlatform	=	nil
	}

	///

	private static weak var	_thePlatform	:	PlatformProtocol?

	///

	private init() {
	}
}

public protocol PlatformProtocol: class {
	var fileSystem: PlatformFileSystemProtocol { get }
}

public protocol PlatformFileSystemProtocol: class {

	/// Creates a directory at URL.
	/// The URL must be a file URL.
	func createDirectoryAtURL(u: NSURL, recursively: Bool) throws

	/// Deletes a directory at URL.
	/// The URL must be a file URL.
	func deleteDirectoryAtURL(u: NSURL, recursively: Bool) throws

	/// Creates a new empty file at the URL.
	/// The URL must be a file URL.
	func createFileAtURL(u: NSURL) throws
	/// Deletes an existing file at the URL.
	/// The URL must be a file URL.
	func deleteFileAtURL(u: NSURL) throws

	/// Moves an existing file at the URL.
	/// The URLs must be file URLs.
	func moveFile(fromURL fromURL: NSURL, toURL: NSURL) throws

	/// Gets whole file content from the URL.
	/// The URL must be a file URL.
	func contentOfFileAtURLAtomically(u: NSURL) throws -> NSData
	/// Replaces whole file content to the URL with supplied data 
	/// The URL must be a file URL.
	func replaceContentOfFileAtURLAtomically(u: NSURL, data: NSData) throws
}

public enum PlatformFileSystemError: ErrorType {
	case AlreadyExists
	case DoesNotExist
}























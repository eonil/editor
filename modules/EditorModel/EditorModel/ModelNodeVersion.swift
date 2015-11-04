////
////  ModelNodeVersion.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/11/05.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import EditorCommon
//
//
//
//public class ModelNodeVersion {
//
//	public internal(set) var state = VersionState() {
//		willSet {
//			_onWillChange.cast()
//		}
//		didSet {
//			_onDidChange.cast()
//		}
//	}
//
//	public var onWillChange: MulticastChannel<()> {
//		get {
//			return	_onWillChange
//		}
//	}
//	public var onDidChange: MulticastChannel<()> {
//		get {
//			return	_onDidChange
//		}
//	}
//
//
//
//
//	///
//
//	private let	_onWillChange	=	MulticastStation<()>()
//	private let	_onDidChange	=	MulticastStation<()>()
//
//}

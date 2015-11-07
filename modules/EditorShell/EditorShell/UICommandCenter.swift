////
////  UICommandCenter.swift
////  EditorShell
////
////  Created by Hoon H. on 2015/11/05.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//func executeUICommand(command: UICommand) throws {
//	try UICommandCenter.theCommandCenter.execute(command)
//}
//
//class UICommandCenter {
//	static let	theCommandCenter	=	UICommandCenter()
//
//	enum ExecutionError: ErrorType {
//		case InvalidStateToExecuteTheCommand
//		case InvalidStateButCanBeDoneLater(schedule: () -> ())
//	}
//
//
//
//
//
//	///
//
//	weak var server: UIServiceCenter?
//
//	/// Runs a UI command synchronously.
//	func execute(command: UICommand) throws {
//		guard server != nil else {
//			fatalError("Server unspecified.")
//		}
//		try server!.execute(command)
//	}
//
//
//
//
//	///
//
//	private init() {
//	}
//}
//
//protocol UIServiceCenter: class {
//	func execute(command: UICommand) throws
//}
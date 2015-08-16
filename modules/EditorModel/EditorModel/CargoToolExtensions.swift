////
////  CargoToolExtensions.swift
////  EditorModel
////
////  Created by Hoon H. on 2015/08/16.
////  Copyright © 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
//extension CargoTool {
//	static func runNewingAtURL(u: NSURL, handler: CargoTool->()) {
//		let	c	=	CargoTool(rootDirectoryURL: u)
//		c.state.registerDidSet(ObjectIdentifier(c)) {
//			handler(c)
//		}
//		c.runNew()
//	}
//}
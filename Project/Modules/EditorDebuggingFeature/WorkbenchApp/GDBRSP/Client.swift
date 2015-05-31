//
//  Client.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

struct Client {
	func sendInterrupt() {
		let	CODE	=	UInt8(0x03)
	}
	func sendPacket(p:Packet) {
		
	}
}




protocol Writable {
	func writeToChannel<C:SinkType where C.Element == UInt8>(inout channel:C)
}


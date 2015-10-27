//
//  Notification.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/24.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public struct Notification<O, N>: NotificationType {
	public init(_ sender: O, _ event: N) {
		self	=	Notification(sender: sender, event: event)
	}
	public init(sender: O, event: N) {
		self.sender		=	sender
		self.event		=	event
	}
	
	public var	sender: O
	public var	event: N
}


















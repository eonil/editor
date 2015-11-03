//
//  EventType.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/26.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public protocol EventType {
	typealias	Sender
}
public extension EventType {
	public typealias	Notification		=	EditorModel.Notification<Sender,Self>
}








public protocol BroadcastableEventType: EventType {
	typealias	Sender	:	BroadcastingModelType
}






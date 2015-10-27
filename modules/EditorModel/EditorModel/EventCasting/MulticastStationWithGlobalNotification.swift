//
//  MulticastStationWithGlobalNotification.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/26.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

class MulticastStationWithGlobalNotification<E: EventType where E.Sender: AnyObject>: MulticastStation<E> {
	weak var sender: E.Sender?
	override func cast(parameter: E) {
		super.cast(parameter)
		assert(_ms != nil)				// Global caster must be cached at this point.
		_ms!.cast(Notification(sender!, parameter))	// Global casting always follow local casting.
	}

	override init() {
		super.init()

		E.Notification.register(self, MulticastStationWithGlobalNotification._dummy)	// Ensure having a global caster.
		_ms	=	E.Notification.searchBroadcastingStation()!			// Cache it locally to avoid searching cost.
	}
	deinit {
		assert(E.Notification.searchBroadcastingStation() === _ms)	// Ensure the global caster is correct one.
		E.Notification.deregister(self)					// Release the global caster.
	}

	///

	private weak var	_ms	:	MulticastStation<Notification<E.Sender,E>>?

	private func _dummy(n: Notification<E.Sender,E>) {
		Debug.log("Global Notification = \(n)")
	}
}




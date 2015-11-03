//
//  MulticastStationWithGlobalNotification.swift
//  EditorModel
//
//  Created by Hoon H. on 2015/10/26.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import EditorCommon

/// How should I handle `sender`...?
/// Is this really a good design...?
class MulticastStationWithGlobalNotification<E: EventType where E.Sender: AnyObject>: MulticastStation<E> {
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

	func cast(parameter: E, withSender sender: E.Sender) {
		super.cast(parameter)
		assert(_ms != nil)				// Global caster must be cached at this point.
		_ms!.cast(Notification(sender, parameter))	// Global casting always follow local casting.
	}
	@available(*,unavailable)
	override func cast(parameter: E) {
		super.cast(parameter)
	}

//	weak var sender: E.Sender?
//	override func cast(parameter: E) {
//		guard let sender = sender else {
//			fatalError("You MUST set a `sender` to cast a value globally.")
//		}
//
//		super.cast(parameter)
//		assert(_ms != nil)				// Global caster must be cached at this point.
//		_ms!.cast(Notification(sender, parameter))	// Global casting always follow local casting.
//	}

	///

	private weak var	_ms	:	MulticastStation<Notification<E.Sender,E>>?

	private func _dummy(n: Notification<E.Sender,E>) {
		Debug.log("Global Notification = \(n)")
	}
}


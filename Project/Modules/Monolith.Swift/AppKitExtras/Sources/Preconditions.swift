//
//  Preconditions.swift
//  UIKitExtras
//
//  Created by Hoon H. on 11/26/14.
//
//

import Foundation
import AppKit


public func preconditionNoAutoresizingMasking(v:NSView?) {
	if let v1 = v {
		//	The feature `translatesAutoresizingMaskIntoConstraints` never works with auto-layout. Please turn it off.
		precondition(v1.translatesAutoresizingMaskIntoConstraints == false, "You cannot supply a view with autoresizing-mask set to `true` for this.")
	}
}

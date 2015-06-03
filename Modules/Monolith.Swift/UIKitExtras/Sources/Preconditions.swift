//
//  Preconditions.swift
//  UIKitExtras
//
//  Created by Hoon H. on 11/26/14.
//
//

import Foundation
import UIKit


public func preconditionNoAutoresizingMasking(v:UIView?) {
	if let v1 = v {
		precondition(v1.translatesAutoresizingMaskIntoConstraints() == false, "Views with autoresizing-mask set to `true` cannot be used for this feature.")
	}
}

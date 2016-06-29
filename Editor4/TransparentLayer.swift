//
//  TransparentLayer.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/03.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

final class TransparentLayer: CALayer {
	override init() {
		super.init()
		backgroundColor = TRANSPARENT_COLOR
	}
	override init(layer: AnyObject) {
		super.init(layer: layer)
		backgroundColor = TRANSPARENT_COLOR
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("IB/SB are unsupported.")
//		super.init(coder: aDecoder)
//		backgroundColor = TRANSPARENT_COLOR
	}
	override var backgroundColor: CGColor? {
		willSet {
			assert(newValue == nil || CGColorEqualToColor(newValue!, TRANSPARENT_COLOR),
				"Accepts only transparent color.")
		}
	}

    // I don't know why we cannot override this method...
//	override func copy() -> AnyObject {
//		return self
//	}
}

private let TRANSPARENT_COLOR = NSColor.clearColor().CGColor
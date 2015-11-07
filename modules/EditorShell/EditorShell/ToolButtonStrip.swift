//
//  ToolButtonStrip.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/07.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorUICommon



//class ToolButton: NSButton, IdeallySizableType {
//	var idealSize: CGSize = CGSize.zero
//}
class ToolButtonStrip: CommonView {



	var toolButtons: [NSButton] = [] {
		willSet {
			_deinstallToolButtons()
		}
		didSet {
			_installToolButtons()
			_layout()
		}
	}

	var interButtonGap: CGFloat = 0 {
		didSet {
			_layout()
		}
	}

	var idealSize: CGSize {
		get {
			let	buttonSZs	=	toolButtons.map { $0.sizeThatFits(CGSize.zero) }
			let	totalW		=	buttonSZs.map { $0.width }.reduce(0, combine: +) + (interButtonGap * CGFloat(buttonSZs.count - 1))
			let	maxH		=	buttonSZs.map { $0.height }.reduce(0, combine: max)
			return	CGSize(width: totalW, height: maxH).round
		}
	}






	///

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
	}
	override func deinstallSubcomponents() {
		_deinstall()
		super.deinstallSubcomponents()
	}
	override func layoutSubcomponents() {
		super.layoutSubcomponents()
		_layout()
	}





	///

	private func _install() {
		_installToolButtons()
	}
	private func _deinstall() {
		_deinstallToolButtons()
	}
	private func _layout() {
		let	idealSZ		=	idealSize
		let	startingX	=	round(bounds.midX - (idealSZ.width / 2))
		var	x		=	startingX
		for i in 0..<toolButtons.count {
			let	button			=	toolButtons[i]
			let	y			=	round(bounds.midY - (button.frame.size.height / 2))
			toolButtons[i].frame.origin	=	CGPoint(x: x, y: y)

			x	+=	button.frame.width
		}
	}



	private func _installToolButtons() {
		for b in toolButtons {
			addSubview(b)
		}
	}
	private func _deinstallToolButtons() {
		for b in toolButtons {
			b.removeFromSuperview()
		}
	}
}




//extension NSView {
//	/// Movement from parent's bounds center.
//	var translation: CGPoint {
//		get {
//
//		}
//	}
//}


//protocol IdeallySizableType {
//	var idealSize: CGSize { get }
//}









//
//  Line.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/08.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorUICommon

/// Draws thinnest clear line at specified position.
class Line: CommonView {

	enum Position {
		case MaxX
		case MinX
		case MinY
		case MaxY
	}

	var lineColor: NSColor = NSColor.blackColor() {
		didSet {
			_applyColorChange()
		}
	}
	var position: Position = .MinY {
		didSet {
			_layout()
		}
	}

	override func installSubcomponents() {
		super.installSubcomponents()
		_install()
		_layout()
		_applyColorChange()
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

	private let _lineView	=	CommonView()

	private func _install() {
		addSubview(_lineView)
	}
	private func _deinstall() {
		_lineView.removeFromSuperview()
	}
	private func _layout() {
		let	lineBox	=	{
			let	box	=	LayoutBox(bounds).autoshrinkingLayoutBox()
			switch position {
			case .MinX:	return	box.cutMinX(1).minX
			case .MinY:	return	box.cutMinY(1).minY
			case .MaxX:	return	box.cutMaxX(1).maxX
			case .MaxY:	return	box.cutMaxY(1).maxY
			}
		}() as LayoutBox
		lineBox.applyToView(_lineView)
	}
	private func _applyColorChange() {
		_lineView.layer!.backgroundColor	=	lineColor.CGColor
	}
}






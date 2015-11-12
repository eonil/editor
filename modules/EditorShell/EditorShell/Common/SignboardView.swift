//
//  SignboardView.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/11/12.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorCommon
import EditorUICommon

class SignboardView: CommonView {





	var headText: String? {
		didSet {
			_headLabel.objectValue	=	headText
		}
	}
	var bodyText: String? {
		didSet {
			_bodyLabel.objectValue	=	bodyText
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

	private let _headLabel		=	_instantiateHeadLabel()
	private let _bodyLabel		=	_instantiateBodyLabel()
	private let _contentBox		=	_instantiateContentBox()
	private var _constraints	:	[NSLayoutConstraint]?

	private func _install() {
		addSubview(_headLabel)
		addSubview(_bodyLabel)
		addLayoutGuide(_contentBox)

		_constraints	=	[
			_headLabel.topAnchor.constraintGreaterThanOrEqualToAnchor(topAnchor),
			_bodyLabel.bottomAnchor.constraintLessThanOrEqualToAnchor(bottomAnchor),
			_bodyLabel.topAnchor.constraintGreaterThanOrEqualToAnchor(_headLabel.bottomAnchor, constant: 10),
			_headLabel.centerXAnchor.constraintEqualToAnchor(_contentBox.centerXAnchor),
			_bodyLabel.centerXAnchor.constraintEqualToAnchor(_contentBox.centerXAnchor),
			_contentBox.topAnchor.constraintEqualToAnchor(_headLabel.topAnchor),
			_contentBox.bottomAnchor.constraintEqualToAnchor(_bodyLabel.bottomAnchor),
			_contentBox.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
			_contentBox.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
			]
		NSLayoutConstraint.activateConstraints(_constraints!)
	}
	private func _deinstall() {
		NSLayoutConstraint.deactivateConstraints(_constraints!)
		_constraints	=	nil

		removeLayoutGuide(_contentBox)
		_bodyLabel.removeFromSuperview()
		_headLabel.removeFromSuperview()
	}
	private func _layout() {
		_headLabel.preferredMaxLayoutWidth	=	bounds.width - 20
		_bodyLabel.preferredMaxLayoutWidth	=	bounds.width - 20
	}
}








private func _instantiateContentBox() -> NSLayoutGuide {
	let	v	=	NSLayoutGuide()
	v.identifier	=	"CONTENT"
	return	v
}
private func _instantiateBodyLabel() -> NSTextField {
	let	v	=	_instantiateLabel()
	v.identifier	=	"BODY"
	v.font		=	NSFont.systemFontOfSize(12, weight: 0)
	v.textColor	=	NSColor.disabledControlTextColor()
	return	v
}
private func _instantiateHeadLabel() -> NSTextField {
	let	v	=	_instantiateLabel()
	v.identifier	=	"HEAD"
	v.font		=	NSFont.systemFontOfSize(14, weight: 0)
	v.textColor	=	NSColor.disabledControlTextColor()
	return	v
}














private func _instantiateLabel() -> NSTextField {
	let	v	=	NSTextField()
	v.identifier	=	"BODY"
	v.translatesAutoresizingMaskIntoConstraints	=	false

	// You must set `editable` to `false` to make it to be resized by autolayout.
	v.editable		=	false
	v.bordered		=	false
	v.backgroundColor	=	nil
	v.alignment		=	.Center
	v.lineBreakMode		=	.ByWordWrapping
	return	v
}








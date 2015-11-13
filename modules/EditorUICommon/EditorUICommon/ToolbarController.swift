//
//  ToolbarController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Incomplete yet!
class ToolbarItemTemplate {
	init(label: String, paletteLabel: String) {
		self.label		=	label
		self.paletteLabel	=	paletteLabel

		_agent.owner		=	self
	}
	var enabled: Bool = false {
		didSet {
			_owner?._updateItemsForTemplate(self)
		}
	}
	var label: String {
		didSet {
			_owner?._updateItemsForTemplate(self)
		}
	}
	var paletteLabel: String {
		didSet {
			_owner?._updateItemsForTemplate(self)
		}
	}
	var eventHandler: (()->())?

//	var allowed: Bool = true {
//		didSet {
//
//		}
//	}

	private weak var 	_owner	:	ToolbarController?
	private let		_agent	=	_ToolItemAgent()

	private func _identityString() -> String {
		return	ObjectIdentifier(self).uintValue.description
	}
}
private final class _ToolItemAgent: NSObject {
	weak var owner: ToolbarItemTemplate?
	@objc
	func EDITOR_onSelect(_: AnyObject?) {
		owner!.eventHandler?()
	}
}

class ToolbarController {

	init(identifier: String) {
		_toolbar	=	NSToolbar(identifier: identifier)
	}
	deinit {
	}

	var templates: [ToolbarItemTemplate] = [] {
		willSet {
			assert(items.map({_is($0, oneOfTemplates: newValue)}).reduce(true, combine: _and), "Only templates that contained in `templates` proeprty can be used as `items`.")
			for tmpl in templates {
				assert(tmpl._owner === self)
				tmpl._owner	=	nil
			}
		}
		didSet {
			for tmpl in templates {
				assert(tmpl._owner === nil)
				tmpl._owner	=	self
			}
		}
	}
	var items: [ToolbarItemTemplate] = [] {
		willSet {
			assert(newValue.map({_is($0, oneOfTemplates: templates)}).reduce(true, combine: _and), "Only templates that contained in `templates` proeprty can be used as `items`.")
		}
		didSet {
		}
	}
	var toolbar: NSToolbar {
		get {
			return	_toolbar
		}
	}

	func run() {
		_installToolItems()
	}
	func halt() {
		_deinstallToolItems()
	}

	///

	private let	_toolbar	:	NSToolbar
	private let	_agent		=	_ToolbarAgent()

	private func _installToolItems() {
		_toolbar.delegate	=	_agent
	}
	private func _deinstallToolItems() {
		_toolbar.delegate	=	nil
	}

	///


	private func _updateItemsForTemplate(item: ToolbarItemTemplate) {

	}
	private func _findItemForID(id: String) -> ToolbarItemTemplate? {
		for tmpl in templates {
			if tmpl._identityString() == id {
				return	tmpl
			}
		}
		return	nil
	}
}

private final class _ToolbarAgent: NSObject, NSToolbarDelegate {
	weak var owner: ToolbarController?
	@objc
	private func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		if let tmpl = owner!._findItemForID(itemIdentifier) {
			let	item		=	NSToolbarItem(itemIdentifier: itemIdentifier)
			item.label		=	tmpl.label
			item.paletteLabel	=	tmpl.paletteLabel
			item.target		=	tmpl._agent
			item.action		=	"EDITOR_onSelect:"
			item.enabled		=	tmpl.enabled
			return	item
		}
		else {
			//	Unknown item.
			fatalError()
		}
	}
	@objc
	private func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [String] {
		return	owner!.items.map({$0._identityString()})
	}
	@objc
	private func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [String] {
		return	owner!.items.map({$0._identityString()})
	}
}






















private func _is(item: ToolbarItemTemplate, oneOfTemplates templates: [ToolbarItemTemplate]) -> Bool {
	for tmpl in templates {
		if tmpl === item {
			return	true
		}
	}
	return	false
}
private func _and(a: Bool, b: Bool) -> Bool {
	return	a && b
}








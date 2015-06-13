//
//  ToolbarController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/06/13.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

extension ToolbarController.ToolItem {
	private static func _systemToolItem(identifier: String) -> ToolbarController.ToolItem {
		return	ToolbarController.ToolItem(
			identifier: 	identifier,
			label:		"",
			size:		(CGSize.zeroSize, CGSize.zeroSize),
			view:		nil,
			handler:	{})
	}
	static func print() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarPrintItemIdentifier)
	}
	static func flexibleSpace() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarFlexibleSpaceItemIdentifier)
	}
	static func space() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarSpaceItemIdentifier)
	}
	static func separator() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarSeparatorItemIdentifier)
	}
	static func runColor() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarShowColorsItemIdentifier)
	}
	static func runFont() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarShowFontsItemIdentifier)
	}
	static func customize() -> ToolbarController.ToolItem {
		return	_systemToolItem(NSToolbarCustomizeToolbarItemIdentifier)
	}
}
class ToolbarController {
	struct ToolItem {
		var	identifier	:	String
		var	label		:	String
		var	size		:	(minimum: CGSize, maximum: CGSize)
		var	view		:	NSView?
		var	handler		:	()->()
	}
	
	typealias	Configuration	=	[ToolItem]
	
	init(identifier: String) {
		_toolbar	=	NSToolbar(identifier: identifier)
	}
	deinit {
		assert(_installed == false)
	}
	
	var toolbar: NSToolbar {
		get {
			assert(_installed == true)
			return	_toolbar
		}
	}
	
	var configuration: Configuration? {
		willSet {
			if configuration != nil {
				_disconnect()
				_deinstall()
			}
		}
		didSet {
			if configuration != nil {
				_install()
				_connect()
			}
		}
	}
	
	///
	
	private let	_toolbar	:	NSToolbar
	private let	_agent		=	_OBJCToolbarAgent()

	private var	_installed	=	false
	private var	_derivations	:	(identifierSequence: [String], mappings: [String: ToolItem])?
	
	private func _install() {
		func seq(items: [ToolItem]) -> [String] {
			return	items.map { $0.identifier }
		}
		func mappings(items: [ToolItem]) -> [String: ToolItem] {
			var	map	=	[:] as [String: ToolItem]
			for item in items {
				map[item.identifier]	=	item
			}
			return	map
		}
		_derivations		=	(seq(configuration!), mappings(configuration!))
		_installed		=	true
	}
	private func _deinstall() {
		_derivations		=	nil
		_installed		=	false
	}
	
	private func _connect() {
		_toolbar.delegate	=	_agent;
		_agent.owner		=	self
	}
	private func _disconnect() {
		_agent.owner		=	nil
		_toolbar.delegate	=	nil
	}
	
	@objc
	private class _Item: NSToolbarItem, NSCopying {
		let	item		:	ToolItem
		
		init(_ item: ToolItem) {
			self.item	=	item
			super.init(itemIdentifier: item.identifier)
			self.label	=	item.label
			self.view	=	item.view
			self.minSize	=	item.size.minimum
			self.maxSize	=	item.size.maximum
			self.target	=	self
			self.action	=	"handleOnClick:"
		}
		
		@objc
		private override func copyWithZone(zone: NSZone) -> AnyObject {
			return	_Item(item)
		}
		
		@objc
		private func handleOnClick(AnyObject?) {
			item.handler()
		}
	}
	
	@objc
	private class _OBJCToolbarAgent: NSObject, NSToolbarDelegate {
		weak var owner: ToolbarController?
		
		@objc
		private func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
			let	def	=	owner!._derivations!.mappings[itemIdentifier]!
			let	item	=	_Item(def)
			return	item
		}
		
		@objc
		private func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
			return	owner!._derivations!.identifierSequence
		}
		
		@objc
		private func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
			return	owner!._derivations!.identifierSequence
		}
	}
}









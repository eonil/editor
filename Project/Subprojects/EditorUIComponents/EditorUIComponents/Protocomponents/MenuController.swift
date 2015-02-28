//
//  MenuController.swift
//  Editor
//
//  Created by Hoon H. on 2015/02/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit









///	This is half-baked bread. Designed to be complemented in subclass.
///
///
public class MenuController {
	public static func menuOfController(c:MenuController) -> NSMenu {
		return	c._menu
	}
	
	public init(_ menu:NSMenu) {
		assert(menu.autoenablesItems == false, "You must set `autoenablesItems` to `false`.")
		_menu	=	menu
		
//		NSNotificationCenter.defaultCenter().addObserverForName(NSMenuDidSendActionNotification, object: nil, queue: nil) { [unowned self] (n:NSNotification!) -> Void in
//			let	m	=	n!.userInfo!["MenuItem"]! as! NSMenuItem
//			if m.menu === self._menu {
//				self.didClickMenuItem(m)
//			}
//		}
	}
	
//	var menu:NSMenu {
//		get {
//			return	_menu
//		}
//	}
//	
//	///	Intended to be overriden to provide a proper handler.
//	func didClickMenuItem(m:NSMenuItem) {
//	}
	
	private let	_menu: NSMenu
}

//@objc
//private final class MenuNotificationObserver {
//	weak var owner:MenuController?
//	func onMenuDidSendAction(selector:Selector) {
//		owner!.
//	}
//}


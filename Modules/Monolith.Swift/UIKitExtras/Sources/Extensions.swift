//
//  Extensions.swift
//  WeatherTable
//
//  Created by Hoon H. on 11/18/14.
//
//

import Foundation
import UIKit


/////////////////////////////////////////////////////////////////////
//	Place only extensions proven to be useful over most projects.
//	Because extensions can be broken by adding new function to
//	the SDK, it's important keeping it small to be defensive to
//	breaks by changes.
/////////////////////////////////////////////////////////////////////




public extension UISegmentedControl {
	public convenience
	init(titles:[String]) {
		self.init(items: titles)
	}
	public convenience
	init(images:[UIImage]) {
		self.init(items: images)
	}
}

public extension UIToolbar {
	public var	barButtonItems:[UIBarButtonItem] {
		get {
			return	self.items as! [UIBarButtonItem]
		}
		set(v) {
			self.items	=	v
		}
	}
}

public extension UIView {
	public convenience init(translatesAutoresizingMaskIntoConstraints:Bool) {
		self.init()
		setTranslatesAutoresizingMaskIntoConstraints(translatesAutoresizingMaskIntoConstraints)
	}
}

public extension UIView {
	public convenience init(backgroundColor:UIColor) {
		self.init()
		self.backgroundColor	=	backgroundColor
	}
}












public extension UIView {
	
	
	///	Gets and sets all layout-constraints at once.
	public var layoutConstraints:[NSLayoutConstraint] {
		get {
			return	self.constraints() as! [NSLayoutConstraint]
		}
		set(v) {			
			let	cs1	=	self.constraints()
			self.removeConstraints(cs1)
			assert(self.constraints().count == 0)
			self.addConstraints(v as [AnyObject])
		}
	}
	
	///	Removes all constraints about the specified view.
	public func removeConstraintsWithView(v:UIView) {
		let	a	=	layoutConstraints.filter({$0.firstItem === v || $0.secondItem === v})
		for c in a {
			removeConstraint(c)
		}
	}
	
}













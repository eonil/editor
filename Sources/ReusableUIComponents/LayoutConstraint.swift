//
//  LayoutConstraint.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation
import AppKit

struct LayoutConstraint {
//	struct Expression {
//		let	multiplier:CGFloat
//		let	constant:CGFloat
//	}
//	
//	static func	setWidthOfView(view: NSView, equalsToValue: CGFloat) -> NSLayoutConstraint {
//		return	NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: CGFloat, constant: CGFloat)
//	}
}

struct LayoutExpression {
	let	argument:LayoutArgument
	let	multiplier:CGFloat
	let	constant:CGFloat
}

typealias	LayoutArgument	=	(view: NSView, attribute:NSLayoutAttribute)

let	width	=	NSLayoutAttribute.Width
let	height	=	NSLayoutAttribute.Height

let	left	=	NSLayoutAttribute.Left
let	right	=	NSLayoutAttribute.Right
let	top		=	NSLayoutAttribute.Top
let	bottom	=	NSLayoutAttribute.Bottom

infix operator .. {
	precedence 255
}

infix operator ~~ {
precedence 1
}

func .. (left:NSView, right:NSLayoutAttribute) -> LayoutArgument {
	return	(left,right)
}
func .. (left:NSViewController, right:NSLayoutAttribute) -> LayoutArgument {
	return	(left.view,right)
}

func ~~ (left:NSLayoutConstraint, right:NSLayoutPriority) -> NSLayoutConstraint {
	let	c1	=	NSLayoutConstraint(item: left.firstItem, attribute: left.firstAttribute, relatedBy: left.relation, toItem: left.secondItem, attribute: left.secondAttribute, multiplier: left.multiplier, constant: left.constant)
	c1.priority	=	right
	return	c1
}


func * (left:LayoutArgument, right:CGFloat) -> LayoutExpression {
	return	LayoutExpression(argument: left, multiplier: right, constant: 0)
}

func + (left:LayoutExpression, right:CGFloat) -> LayoutExpression {
	return	LayoutExpression(argument: left.argument, multiplier: left.multiplier, constant: right)
}

func == (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.Equal, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}
func >= (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}
func <= (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}

func == (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}
func >= (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}
func <= (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}






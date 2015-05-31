//
//  LayoutConstraint.swift
//  WeatherTable
//
//  Created by Hoon H. on 11/18/14.
//
//

import Foundation

#if os(iOS)
	import UIKit
#endif

#if os(OSX)
	import AppKit
#endif









@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public struct LayoutExpression {
	public let	argument:LayoutArgument
	public let	multiplier:CGFloat
	public let	constant:CGFloat
}

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public typealias	LayoutArgument	=	(view: Anchor.View, attribute:NSLayoutAttribute)

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	width		=	NSLayoutAttribute.Width
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	height		=	NSLayoutAttribute.Height
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	centerX		=	NSLayoutAttribute.CenterX
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	centerY		=	NSLayoutAttribute.CenterY

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	left		=	NSLayoutAttribute.Left
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	right		=	NSLayoutAttribute.Right
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	top			=	NSLayoutAttribute.Top
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.") public let	bottom		=	NSLayoutAttribute.Bottom

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public let	baseline	=	NSLayoutAttribute.Baseline




infix operator .. {
	precedence 255			///	Precedence may be changed later.
}

infix operator ~~ {
	precedence 1			///	Precedence may be changed later.
}



@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func .. (left:Anchor.View, right:NSLayoutAttribute) -> LayoutArgument {
	return	(left,right)
}

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func ~~ (left:NSLayoutConstraint, right:Anchor.Priority) -> NSLayoutConstraint {
	let	c1	=	NSLayoutConstraint(item: left.firstItem, attribute: left.firstAttribute, relatedBy: left.relation, toItem: left.secondItem, attribute: left.secondAttribute, multiplier: left.multiplier, constant: left.constant)
	c1.priority	=	right
	return	c1
}


@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func * (left:LayoutArgument, right:CGFloat) -> LayoutExpression {
	return	LayoutExpression(argument: left, multiplier: right, constant: 0)
}

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func + (left:LayoutExpression, right:CGFloat) -> LayoutExpression {
	return	LayoutExpression(argument: left.argument, multiplier: left.multiplier, constant: right)
}

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func - (left:LayoutExpression, right:CGFloat) -> LayoutExpression {
	return	LayoutExpression(argument: left.argument, multiplier: left.multiplier, constant: -right)
}


@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func == (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.Equal, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func >= (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func <= (left:LayoutArgument, right:LayoutExpression) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: right.argument.view, attribute: right.argument.attribute, multiplier: right.multiplier, constant: right.constant)
}

@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func == (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func >= (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}
@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
public func <= (left:LayoutArgument, right:CGFloat) -> NSLayoutConstraint {
	assertForCorrectAutoresigingTranslationState(left.view)
	return	NSLayoutConstraint(item: left.view, attribute: left.attribute, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: right)
}




@availability(*,deprecated=0.0,message="Single constraint expression deprecated. Please migrate to anchor based one. See `Anchor` for details.")
private func assertForCorrectAutoresigingTranslationState(v:Anchor.View) {
	preconditionNoAutoresizingMasking(v)
}



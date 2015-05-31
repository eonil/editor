//
//  Strip.swift
//  CratesIOViewer
//
//  Created by Hoon H. on 11/23/14.
//
//

import Foundation

#if os(iOS)
import UIKit
#endif

#if os(OSX)
import AppKit
#endif








public struct LayoutStrip {
	
	#if	os(iOS)
	public typealias	Priority	=	UILayoutPriority
	public typealias	View		=	UIView
	#endif
	
	#if	os(OSX)
	public typealias	Priority	=	NSLayoutPriority
	public typealias	View		=	NSView
	#endif
	
	
	
	
	private var	views	:	[LayoutStrip.View]
	
	private var	flow	:	FlowDirection?
	private	var	gap		:	CGFloat
	
	private var	align	:	Anchor?
	private var	disp	:	CGFloat
	
	private var	p		:	Priority
	
	
	
	public init(_ views:[LayoutStrip.View]) {
		for v in views {
			preconditionNoAutoresizingMasking(v)
		}
		
		self.views	=	views
		self.gap	=	0
		self.disp	=	0
		self.p		=	REQUIRED
	}
	
	public var	first:LayoutStrip {
		get {
			precondition(views.count >= 1)
			
			var	l1		=	self
			l1.views	=	[l1.views.first!]
			return	l1
		}
	}
	public var	rest:LayoutStrip {
		get {
			precondition(views.count >= 1)
			
			var	l1		=	self
			l1.views	=	l1.views[0..<l1.views.count].array
			return	l1
		}
	}
	
	

}


public extension LayoutStrip.View {
	///	Adds all constraints resolved from the `LayoutStrip` for this view with custom priority.
	public func addConstraintsUsingStrip(s:LayoutStrip) {
		addConstraints(s.resolveCSForView(self))
	}
}
















public extension LayoutStrip {
	
	public func gapBy(gap:CGFloat) -> LayoutStrip {
		var	l1	=	self
		l1.gap	=	gap
		return	l1
	}
	
	///	Set displacement of alignment.
	///	If you set alignment to left-anchor with displacement +10
	///	then the view's left will be fixed superview's left + 10.
	public func displaceBy(displacement:CGFloat) -> LayoutStrip {
		var	l1	=	self
		l1.disp	=	displacement
		return	l1
	}

	///	The anchor must be 1D anchor.
	public func alignTo(a:Anchor) -> LayoutStrip {
		precondition(a.dimensions == 1)
		var	l1		=	self
		l1.align	=	a
		return	l1
	}
//	public func alignHorizontalCenter() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.HorizontalCenter
//		return	l1
//	}
//	public func alignVerticalCenter() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.VerticalCenter
//		return	l1
//	}
//	public func alignLeft() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.Left
//		return	l1
//	}
//	public func alignRight() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.Right
//		return	l1
//	}
//	public func alignTop() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.Top
//		return	l1
//	}
//	public func alignBottom() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.Bottom
//		return	l1
//	}
//	public func alignBaseline() -> LayoutStrip {
//		var	l1		=	self
//		l1.align	=	Alignment.Baseline
//		return	l1
//	}
	
	
	public func flowHorizontally() -> LayoutStrip {
		var	l2	=	self
		l2.flow	=	FlowDirection.Horizontal
		return	l2
	}
	
	public func flowVertically() -> LayoutStrip {
		var	l2	=	self
		l2.flow	=	FlowDirection.Vertical
		return	l2
	}
	
	public func prioritizeTo(p:Priority) -> LayoutStrip {
		var	l1	=	self
		l1.p	=	p
		return	l1
	}
}

public extension LayoutStrip {
	///	1.	Take `first` layout,
	///	2.	resolve it into constraints,
	///	3.	and adds them to `targetView`,
	///	4.	and returns `rest` layout.
	public func setFirstToViewAndRest(targetView:LayoutStrip.View) -> LayoutStrip {
		let	f	=	first
		targetView.addConstraintsUsingStrip(f)
		return	rest
	}
}







private enum FlowDirection {
	case Vertical
	case Horizontal
}

///	Based on UIKit/AppKit numeric coordinates.
///	Some values are invalid in specific flow mode.
private enum Alignment {
	case HorizontalCenter
	case VerticalCenter
	case Left
	case Right
	case Top
	case Bottom
	case Baseline
	
	var	stickingToXAxis:Bool {
		get {
			return	find([HorizontalCenter, Left, Right], self) != nil
		}
	}
	var	stickingToYAxis:Bool {
		get {
			return	find([VerticalCenter, Top, Bottom, Baseline], self) != nil
		}
	}
	var	attribute:NSLayoutAttribute {
		get {
			switch self {
			case .HorizontalCenter:		return	NSLayoutAttribute.CenterX
			case .VerticalCenter:		return	NSLayoutAttribute.CenterY
			case .Left:					return	NSLayoutAttribute.Left
			case .Right:				return	NSLayoutAttribute.Right
			case .Top:					return	NSLayoutAttribute.Top
			case .Bottom:				return	NSLayoutAttribute.Bottom
			case .Baseline:				return	NSLayoutAttribute.Baseline
			}
		}
	}
}





















private typealias	C	=	NSLayoutConstraint

private extension LayoutStrip {
	func resolveCSForView(targetView:LayoutStrip.View) -> [C] {
		let	cs1	=	(flow == nil) ? [] : resolveFlowCSBetweenViews(views, flow!, gap, p)
		let	cs2	=	(align == nil) ? [] : resolveAlignmentCS(views, align!, disp, p)
		return	cs1 + cs2
	}
}





private func resolveAlignmentCS(vs:[LayoutStrip.View], toAnchor:Anchor, withDisplacement:CGFloat, priority:LayoutStrip.Priority) -> [C] {
	func proc1(v:LayoutStrip.View) -> [C] {
		let	a1	=	toAnchor.forView(v)
		let	x1	=	a1 == toAnchor + CGSize(width: withDisplacement, height: withDisplacement)
		let	cs1	=	x1.constraints
		for c in cs1 {
			c.priority	=	priority
		}
		return	cs1
	}
	return	vs.map(proc1).reduce([], combine: +)
}
//private func resolveAlignmentCSBetweenViews(vs:[LayoutStrip.View], align:Alignment, toTargetView:LayoutStrip.View, withDisplacement:CGFloat) -> [C] {
//	let	a1	=	align.attribute
//	let	a2	=	vs.map {
//		C(item: $0, attribute: a1, relatedBy: NSLayoutRelation.Equal, toItem: toTargetView, attribute: a1, multiplier: 1, constant: withDisplacement)
//	}
//	return	a2
//}
private func resolveFlowCSBetweenViews(vs:[LayoutStrip.View], flow:FlowDirection, gap:CGFloat, p:LayoutStrip.Priority) -> [C] {
	if vs.count < 2 {
		return	[]
	}
	
	let	formerA		=	flow == FlowDirection.Horizontal ? NSLayoutAttribute.Right : NSLayoutAttribute.Bottom
	let	latterA		=	flow == FlowDirection.Horizontal ? NSLayoutAttribute.Left : NSLayoutAttribute.Top
	
	var	a1	=	[] as [C]
	let	n	=	vs.count-1
	
	a1.reserveCapacity(n)
	for i in 0..<n {
		let	v1	=	vs[i+0]
		let	v2	=	vs[i+1]
		let	c1	=	C(item: v2, attribute: latterA, relatedBy: NSLayoutRelation.Equal, toItem: v1, attribute: formerA, multiplier: 1, constant: gap)
		c1.priority	=	p
		a1.append(c1)
	}
	return	a1
}















//private let	UILayoutPriorityRequired			=	1000
//private let	UILayoutPriorityDefaultHigh			=	750
//private let	UILayoutPriorityFittingSizeLevel	=	50
private let	REQUIRED	=	1000	as LayoutStrip.Priority
private let	HIGH		=	750		as LayoutStrip.Priority
private	let	FITTING		=	50		as LayoutStrip.Priority
























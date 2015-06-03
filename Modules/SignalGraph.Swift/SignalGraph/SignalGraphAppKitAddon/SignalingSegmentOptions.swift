//
//  SignalingSegmentOptions.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph

//public enum Permission {
//	case Enable
//	case Disable
//}



public class SignalingSegmentOptions: NSSegmentedControl {
	public class Segment {
		public struct State {
			var	width			:	CGFloat?
			var	image			:	NSImage?
			var	label			:	String?
			var	menu			:	NSMenu?
			var	availability	:	Bool
		}
	}
	public enum Signal {
		case	Select(Segment)
		case	Deselect(Segment)
	}
	
	public let		segments	=	EditableArrayStorage<Segment>([])
	
	public init() {
		agent.owner		=	self
		super.target	=	agent
		super.action	=	"onAction:"
	}
	
	public var selection: EditableSetStorage<Segment> {
		
	}
	public var emitter: SignalEmitter<Signal> {
		get {
			return	disp
		}
	}
	
	@availability(*,unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@availability(*,unavailable)
	public override weak var target: AnyObject? {
		willSet {
			fatalError()
		}
	}
	@availability(*,unavailable)
	public override var action: Selector {
		willSet {
			fatalError()
		}
	}
	
	@availability(*,unavailable)
	public override func sendAction(theAction: Selector, to theTarget: AnyObject?) -> Bool {
		fatalError()
	}
	@availability(*,unavailable)
	public override func sendActionOn(mask: Int) -> Int {
		fatalError()
	}
	
	////
	
	private let	agent	=	Agent()
	private let	disp	=	SignalDispatcher<()>()
	
	private func onAction() {
		disp.signal()
	}
	
	@objc
	private final class Agent: NSObject {
		weak var owner: SignalingSegmentOptions?
		@objc
		func onAction(AnyObject?) {
			owner!.onAction()
		}
	}
}














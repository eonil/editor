//
//  SignalingButton.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/10.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph




///	A button that provides `Click` signal emission on clicking by user interaction.
///
///	You also can perform clicking by sending `Click` to sensor.
///
public class SignalingButton: NSButton {
	public enum Signal {
		case Click
	}
	public init() {
		agent.owner		=	self
		super.target	=	agent
		super.action	=	"onAction:"
		monit.handler	=	{ [weak self] s in self!.process(s) }
	}
	
	///	Send a signal to simulate clicking.
	public var sensor: SignalSensor<Signal> {
		get {
			return	monit
		}
	}
	
	///	Watch a signal to track clicking.
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
	@availability(*,unavailable)
	public override func performClick(sender: AnyObject?) {
		fatalError()
	}
	
	////
	
	private let	agent	=	Agent()
	private let	monit	=	SignalMonitor<Signal>()
	private let	disp	=	SignalDispatcher<Signal>()
	
	private func onAction() {
		disp.signal(Signal.Click)
	}
	
	@objc
	private final class Agent: NSObject {
		weak var owner: SignalingButton?
		@objc
		func onAction(AnyObject?) {
			owner!.onAction()
		}
	}
	
	private func process(s: Signal) {
		switch s {
		case .Click:	super.performClick(self)
		}
	}
}







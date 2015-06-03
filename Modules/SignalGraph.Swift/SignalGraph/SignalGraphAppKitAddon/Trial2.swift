////
////  Trial2.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/10.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import SignalGraph
//
//
//
//
//
//
//protocol ViewType {
//	
//}
//
//protocol ButtonType {
//	
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//public class View {
//	public init() {
//	}
//	
//	private let		appkitHost	=	NSView()
//}
//
//public class ContainerView: View {
//	public override init() {
//		subviews.emitter.register(subviewsM)
//		subviewsM.handler	=	{ [unowned self] s in self.process(s) }
//	}
//	
////		public private(set) weak var superview: View?public
//	public let	subviews	=	EditableArrayStorage<View>()
//	
//	////
//	
//	private let	subviewsM	=	SignalMonitor<ArraySignal<View>>()
//	
//	private func process(s: ArraySignal<View>) {
//		switch s {
//		case .Initiation(snapshot: let s):
//			for v in s {
//				appkitHost.addSubview(v.appkitHost)
//			}
//		case .Transition(snapshot: let s):
//			for m in s.mutations {
//				switch (m.past == nil, m.future == nil) {
//				case (true, false):
//					assert(m.future!.appkitHost.superview === nil)
//					appkitHost.insertSubview(m.future!.appkitHost, atIndex: m.identity)
//				case (false, false):
//					assert(appkitHost.subviews[m.identity] === m.past!.appkitHost)
//					appkitHost.replaceSubview(m.past!.appkitHost, with: m.future!.appkitHost)
//				case (false, true):
//					assert(m.past!.appkitHost.superview === appkitHost)
//					assert(appkitHost.subviews[m.identity] === m.past!)
//					m.past!.appkitHost.removeFromSuperview()
//				default:
//					fatalError()
//				}
//			}
//		case .Termination(snapshot: let s):
//			for v in s {
//				assert(v.appkitHost.superview === appkitHost)
//				v.appkitHost.removeFromSuperview()
//			}
//		}
//	}
//}
//
//public class Control: View {
//	public convenience override init() {
//		self.init(appkitControl: NSControl())
//	}
//	init(appkitControl: NSControl) {
//		super.init()
//		self.appkitControl	=	appkitControl
//		appkitHost.addSubview(appkitControl)
//	}
//	private let	appkitControl:	NSControl
//}
//
//public class Button: View {
//	public enum Signal {
//		case Action
//	}
//	public override init() {
//		super.init()
//		agent.owner			=	self
//		appkitButton.target	=	agent
//		appkitButton.action	=	"controlAction:"
//	}
//	
//	public var emitter: SignalEmitter<Signal> {
//		get {
//			return	disp
//		}
//	}
//	
//	////
//	
//	private let		appkitButton	=	NSButton()
//	private let		agent			=	OBJCAgent()
//	private let		disp			=	SignalDispatcher<Signal>()
//	
//	private func processAction() {
//		disp.signal(.Action)
//	}
//	
//	private final class OBJCAgent: NSObject {
//		weak var owner: Button?
//		@objc func controlAction(AnyObject?) {
//			owner!.processAction()
//		}
//	}
//}
//
//class TextField: View {
//	
//}
//
//class ScrollView: View {
//	
//}
//
//class TableView: View {
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//protocol ButtonTrait {
//	var	text: String? { get set }
//	var	font: NSFont { get set }
//	var	color: NSColor { get set }
//}
//
//
//
//
//
//
//
//
//
//
//extension NSView {
//	func insertSubview(v: NSView, atIndex i: Int) {
//		if i < subviews.count {
//			let	v1	=	subviews[i] as! NSView
//			addSubview(v, positioned: NSWindowOrderingMode.Above, relativeTo: v1)
//		} else {
//			addSubview(v)
//		}
//	}
//	func replaceSubviewAtIndex(i: Int, view: NSView) {
//		assert(view.superview == nil)
//		let	v0	=	subviews[i] as! NSView
//		replaceSubview(v0, with: view)
//	}
//}
//
//
//
//

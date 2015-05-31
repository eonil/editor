////
////  SignalGraph+AppKit.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/09.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import SignalGraph
//
//extension NSTextField {
//	
//}
//
//protocol ViewModelTrait {
//	typealias	Model
//	var data	:	Model? { get set }
//}
//
//protocol ViewHostTrait {
//	typealias	View
//	init()
//	var view	:	View { get }
//}
//
//protocol ViewComponentContainerTrait {
//	func addSubcomponent<C: ViewHostTrait>(c: C)
//}
//protocol ViewComponentTrait: ViewModelTrait, ViewHostTrait {
//}
//
//
//public class ButtonComponent: ViewHostTrait, ViewModelTrait {
//	public struct Data {
//		public var	title	:	String
//	}
//	
//	public required init() {
//	}
//	
//	public var data: Data? {
//		didSet {
//			
//		}
//	}
//	
//	public let view	=	NSButton()
//}
//
//class TextViewComponent: ViewHostTrait, ViewModelTrait {
//	struct Data {
//		var	font	:	NSFont
//		var	text	:	String
//	}
//	
//	required init() {
//	}
//	var data	:	Data? {
//		didSet {
//		}
//	}
//	let	view	=	NSTextView()
//	
//}
//
//class TextFieldComponent: ViewHostTrait, ViewModelTrait {
//	struct Data {
//		var	font	:	NSFont
//		var	text	:	String?
//	}
//	
//	required init() {
//	}
//	
//	var	data	:	Data?
//	let	view	=	NSTextField()
//}
//
//class ViewComponent: ViewComponentContainerTrait {
//	typealias	Data	=	()
//	
//	required init() {
//	}
//	
//	func addSubcomponent<C : ViewHostTrait>(c: C) {
//		
//	}
//	
//	let	subcomponents	=	EditableArrayStorage<AnyObject>([])
//	
//	var	data	:	Data?
//	let	view	=	NSView()
//}
//
//class Signaling<C where C: ViewHostTrait, C: ViewModelTrait> {
//	init() {
//		monitor.handler	=	{ [weak self] s in
//			self!.process(s)
//		}
//	}
//	var sensor: SignalSensor<ValueSignal<C.Model>> {
//		get {
//			return	monitor
//		}
//	}
//	
//	////
//	
//	private let	monitor		=	SignalMonitor<ValueSignal<C.Model>>()
//	private var	component	=	C()
//	
//	private func process(s: ValueSignal<C.Model>) {
//		switch s {
//		case .Initiation(let s):
//			component.data	=	s()
//			
//		case .Transition(let s):
//			component.data	=	s()
//			
//		case .Termination(let s):
//			component.data	=	nil
//		}
//	}
//}
//
//
//
//
//
//
//
//

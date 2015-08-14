//
//  CommonUIController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import EditorModel

///	Shell Propagation
///	-----------------
///	`shell` will automatically be propagated to child view controllers and
///	`view`. Because the `view` is `CommonUIView`, it will propagate shell 
///	object to all of its subviews.
///
public class CommonUIController: NSViewController, ModelConsumerNodeType {

	///	The designated initializer.
	public init() {
		super.init(nibName: nil, bundle: nil)!

		let	v	=	_InstallationEventRoutingView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))	//	Initial frame size must be non-zero size. Otherwise AppKit will be broken.
		v.owner		=	self
		view		=	v
	}
	@available(*,unavailable)
	public override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	@available(*,unavailable)
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	///

	public weak var model: Model? {
		get {
			return	_modelConsumerNode.model
		}
		set {
			_modelConsumerNode.model	=	newValue
		}
//		willSet {
//			if let _ = shell {
//				for vc in childViewControllers {
//					assertAndReportFailure(vc is CommonUIController, "Only `CommonUIController` type can be a child of `CommonUIController`.")
//					if let vc = vc as? CommonUIController {
//						vc.shell	=	nil
//					}
//				}
//			}
//		}
//		didSet {
//			if let shell = shell {
//				for vc in childViewControllers {
//					assertAndReportFailure(vc is CommonUIController, "Only `CommonUIController` type can be a child of `CommonUIController`.")
//					if let vc = vc as? CommonUIController {
//						vc.shell	=	shell
//					}
//				}
//			}
//		}
	}
	public func registerShellConsumer(consumer: ModelConsumerProtocol) {
		_modelConsumerNode.registerShellConsumer(consumer)
	}
	public func deregisterShellConsumer(consumer: ModelConsumerProtocol) {
		_modelConsumerNode.deregisterShellConsumer(consumer)
	}

	///

	public func installSubcomponents() {

	}
	public func deinstallSubcomponents() {

	}
	public func layoutSubcomponents() {

	}

	///

//	override func loadView() {
//		let	v	=	_InstallationEventRoutingView(frame: CGRect.zeroRect)
//		v.owner		=	self
//		super.view	=	v
//	}
	public override func viewDidLoad() {
		super.viewDidLoad()
//		view.addSubview(_installationEventRoutingView)
	}


	///

	private let	_modelConsumerNode	=	ModelConsumerNode()

	private func _install() {
		installSubcomponents()
	}
	private func _deinstall() {
		deinstallSubcomponents()
	}
	private func _layout() {
		layoutSubcomponents()
	}
}

final class _InstallationEventRoutingView: CommonUIView {
	weak var owner: CommonUIController?
	override func installSubcomponents() {
		super.installSubcomponents()
		owner!._install()
	}
	override func deinstallSubcomponents() {
		owner!._deinstall()
		super.deinstallSubcomponents()
	}
	override func layoutSubcomponents() {
		super.layoutSubcomponents()
		owner!._layout()
	}
}














//
//  CommonViewController.swift
//  EditorShell
//
//  Created by Hoon H. on 2015/08/14.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides a common feature set for a view-controller.
///
/// Shell Propagation
/// -----------------
/// `shell` will automatically be propagated to child view controllers and
/// `view`. Because the `view` is `CommonView`, it will propagate shell
/// object to all of its subviews.
///
public class CommonViewController: NSViewController {

	/// The designated initializer.
	public init() {
		super.init(nibName: nil, bundle: nil)!

		let	v	=	_InstallationEventRoutingView(frame: CGRect(x: 0, y: 0, width: 1024, height: 1024))	//	Initial frame size must be non-zero size. Otherwise AppKit will be broken.
		v.owner		=	self
		view		=	v

		if _calledViewDidLoadOnceFlag == false {
			viewDidLoad()
		}
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

	public func installSubcomponents() {

	}
	public func deinstallSubcomponents() {

	}
	public func layoutSubcomponents() {

	}

	///

	@available(*, unavailable, message="This property is not supported.")
	public override var representedObject: AnyObject? {
		get {
			fatalError("This property is not supported.")
		}
		set {
			fatalError("This property is not supported.")
		}
	}
//	override func loadView() {
//		let	v	=	_InstallationEventRoutingView(frame: CGRect.zeroRect)
//		v.owner		=	self
//		super.view	=	v
//	}
	public override func viewDidLoad() {
		super.viewDidLoad()
		assert(_calledViewDidLoadOnceFlag == false)
		_calledViewDidLoadOnceFlag	=	true
//		view.addSubview(_installationEventRoutingView)
	}


	///

	private var _calledViewDidLoadOnceFlag	=	false

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

final class _InstallationEventRoutingView: CommonView {
	weak var owner: CommonViewController?
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














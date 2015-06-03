//
//  SubcomponentHostingStaticTableViewController.swift
//  CratesIOCatalogue
//
//  Created by Hoon H. on 11/25/14.
//
//

import Foundation
import UIKit

public class SubcomponentHostingStaticTableViewController: StaticTableViewController, SubcomponentHostType {
	private lazy var _hostingManager:SubcomponentHostingManager! = SubcomponentHostingManager(host: self)
	
	public var hostingManager:SubcomponentHostingManager {
		get {
			return	_hostingManager
		}
	}
	
	public func subcomponents() -> [Subcomponent] {
		return	[]
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		for c in subcomponents() {
			hostingManager.addSubcomponent(c)
		}
		hostingManager.viewDidLoad()
	}
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		hostingManager.viewWillAppear(animated)
	}
	public override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		hostingManager.viewDidAppear(animated)
	}
	public override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		hostingManager.viewWillDisappear(animated)
	}
	public override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		hostingManager.viewDidDisappear(animated)
	}
	public override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		hostingManager.viewWillLayoutSubviews()
	}
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		hostingManager.viewDidLayoutSubviews()
	}
//	public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//		hostingManager.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//	}
	public override func willMoveToParentViewController(parent: UIViewController?) {
		super.willMoveToParentViewController(parent)
		hostingManager.didMoveToParentViewController(parent)
	}
	public override func didMoveToParentViewController(parent: UIViewController?) {
		super.didMoveToParentViewController(parent)
		hostingManager.didMoveToParentViewController(parent)
	}
}
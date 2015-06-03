//
//  Subcomponent.swift
//  CratesIOCatalogue
//
//  Created by Hoon H. on 11/25/14.
//
//

import Foundation
import UIKit

///	Default implementation of `SubcomponentType`.
///	Provides empty stub function for all event handlers.
public class Subcomponent {
	
	public init() {
	}
	
	///	All events are sent only while a host is set by the manager.
	///	You can safely assume the host is always available as long as
	///	you don't set it yourself manually. Just don't set this
	///	yourself.
	public var host:UIViewController? {
		didSet {
		}
	}
	
	public func viewDidLoad() {
	}
	public func viewWillAppear(animated: Bool) {
	}
	public func viewDidAppear(animated: Bool) {
	}
	public func viewWillDisappear(animated: Bool) {
	}
	public func viewDidDisappear(animated: Bool) {
	}
	public func viewWillLayoutSubviews() {
	}
	public func viewDidLayoutSubviews() {
	}
//	public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//	}
	public func willMoveToParentViewController(parent: UIViewController?) {
	}
	public func didMoveToParentViewController(parent: UIViewController?) {
	}
}

//protocol SubcomponentType: class {
//	typealias	HostViewController: UIViewController
//
//	///	All events are sent only while a host is set by the manager.
//	///	You can safely assume the host is always available as long as
//	///	you don't set it yourself manually. Just don't set this 
//	///	yourself.
//	weak var host:HostViewController? { get set }
//	
//	func viewDidLoad()
//	
//	func viewWillAppear(animated:Bool)
//	func viewDidAppear(animated:Bool)
//	func viewWillDisappear(animated:Bool)
//	func viewDidDisappear(animated:Bool)
//	
//	func viewWillLayoutSubviews()
//	func viewDidLayoutSubviews()
////	func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
//
//	func willMoveToParentViewController(parent: UIViewController?)
//	func didMoveToParentViewController(parent: UIViewController?)
//}

public protocol SubcomponentHostType: class {
	var hostingManager:SubcomponentHostingManager { get }
	
	///	Provides all subcomponents.
	///	This property will be access to fill subcomponents at first when
	///	the view controller loaded.
	///	Be consistent on return. In other words, always return same objects.
	///
	///	You don't have to retain returning objects. `SubcomponentHostingManager`
	///	will retain them. Anyway it's also fine to retain some of them yourself.
	///	Hosting manager will release subcomponents when the hosting view 
	///	controller dies, and does not perform any special care on lifetime 
	///	management.
	func subcomponents() -> [Subcomponent]
}

///	Registered subcomponent will basically be handled in adding time order
///	except these events. These events will be sent in reverse order.
///
///		viewWillDisappear
///		viewDidDisappear
///		viewDidLayoutSubviews
///		didMoveToParentViewController
///
///	It is a good practice to make your component to be order-free.

public final class SubcomponentHostingManager {
	private let	host	:	UIViewController
	private var	cs		=	[] as [Subcomponent]
	
	public init(host:UIViewController) {
		self.host	=	host
	}
	public func addSubcomponent(c:Subcomponent) {
		precondition(c.host == nil)
		
		cs.append(c)
		c.host	=	host
	}
	public func removeSubcomponent(c:Subcomponent) {
		precondition(c.host === host)
		
		c.host	=	nil
		let	cs1	=	cs.filter({$0 !== c})
		precondition(cs1.count + 1 == cs.count)
		cs	=	cs1
	}

	public func viewDidLoad() {
		for c in cs {
			c.viewDidLoad()
		}
	}
	public func viewWillAppear(animated:Bool) {
		for c in cs {
			c.viewWillAppear(animated)
		}
	}
	public func viewDidAppear(animated:Bool) {
		for c in cs {
			c.viewDidAppear(animated)
		}
	}
	public func viewWillDisappear(animated:Bool) {
		for c in cs.reverse() {
			c.viewWillDisappear(animated)
		}
	}
	public func viewDidDisappear(animated:Bool) {
		for c in cs.reverse() {
			c.viewWillDisappear(animated)
		}
	}
	
	public func viewWillLayoutSubviews() {
		for c in cs {
			c.viewWillLayoutSubviews()
		}
	}
	public func viewDidLayoutSubviews() {
		for c in cs.reverse() {
			c.viewDidLayoutSubviews()
		}
	}
//	public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//		for c in cs {
//			c.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//		}
//	}
	public func willMoveToParentViewController(parent: UIViewController?) {
		for c in cs {
			c.willMoveToParentViewController(parent)
		}
	}
	public func didMoveToParentViewController(parent: UIViewController?) {
		for c in cs.reverse() {
			c.didMoveToParentViewController(parent)
		}
	}
}















public class SubcomponentHostingViewController: UIViewController, SubcomponentHostType {
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
public class SubcomponentHostingTableViewController: UITableViewController, SubcomponentHostType {
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





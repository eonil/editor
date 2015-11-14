//
//  PaneSplitViewController.swift
//  EditorUICommon
//
//  Created by Hoon H. on 2015/11/14.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit





public class PaneSplitViewController: NSSplitViewController {

	public override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		let	v					=	PaneSplitView()
		v.translatesAutoresizingMaskIntoConstraints	=	false
		v.vertical					=	true
		v.dividerStyle					=	.Thin
		splitView					=	v
	}
	public required init?(coder: NSCoder) {
		fatalError()
	}







	///

	public var paneSplitView: PaneSplitView {
		get {
			return	splitView as! PaneSplitView
		}
	}




	///

	public  override func viewDidLoad() {
		super.viewDidLoad()
	}
}


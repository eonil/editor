//
//  TextScrollViewController.swift
//  RustCodeEditor
//
//  Created by Hoon H. on 11/10/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


class TextScrollViewController : ScrollViewController {
	let	textViewController	=	TextViewController()
	
	override init() {
		super.init()
		self.documentViewController		=	textViewController
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.documentViewController		=	textViewController
	}
	override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.documentViewController		=	textViewController
	}
}

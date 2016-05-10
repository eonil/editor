//
//  RenderableViewController.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/10.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import AppKit

/// Provides pre-configured to receive Shell rendering signals.
/// 
/// This class is intended to be subclassed.
/// `render` method will be called for every action signal.
/// Subclass responsible to filter out unwanted signals.
///
class RenderableViewController: NSViewController, Renderable {

    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Shell.register(self)
    }
    @available(*,unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    deinit {
        Shell.deregister(self)
    }

    ////////////////////////////////////////////////////////////////

    func render() {
        
    }
}
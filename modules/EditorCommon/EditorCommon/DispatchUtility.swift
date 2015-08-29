//
//  DispatchUtility.swift
//  EditorCommon
//
//  Created by Hoon H. on 2015/08/15.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation

public func dispatchToMainQueueAsynchronously(function: ()->()) {
	dispatch_async(dispatch_get_main_queue(), function)
}

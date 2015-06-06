//
//  SignalGraphExtensions.swift
//  EditorMenuUI
//
//  Created by Hoon H. on 2015/06/03.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import SignalGraph

extension ValueSignal {
	var state: T? {
		get {
			switch self {
			case .Initiation(let s):	return	s()
			case .Transition(let s):	return	s()
			case .Termination(let _):	return	nil
			}
		}
	}
}
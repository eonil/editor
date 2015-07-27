//
//  SignalGraphExtensions.swift
//  EditorMenuUI
//
//  Created by Hoon H. on 2015/07/15.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import SignalGraph

extension StateSignal {
	var isDidBegin: Bool {
		get {
			switch self {
			case .DidBegin(_):
				return	true
			default:
				return	false
			}
		}
	}
	var isWillEnd: Bool {
		get {
			switch self {
			case .WillEnd(_):
				return	true
			default:
				return	false
			}
		}
	}
}
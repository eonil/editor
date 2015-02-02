//
//  Operators.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/02/02.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation





infix operator ||| {
}

func ||| <T> (left:T?, right:T) -> T {
	if let v = left {
		return	v
	} else {
		return	right
	}
}
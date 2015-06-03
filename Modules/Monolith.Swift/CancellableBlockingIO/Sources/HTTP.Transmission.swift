//
//  HTTP.Transmission.swift
//  EonilCancellableBlockingIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation

extension HTTP {
	
	///	Generic HTTP transmission feature.
	///	This needs dedicated HTTP implementation and I don't want to do it.
	struct Transmission {
		
		
		
		func initiate() -> Initiation {
			return	Initiation.Error
		}
		func progress() -> Progress {
			return	Progress.Done
		}
		func complete() -> Completion {
			return	Completion.Error
		}
		
		
		
		
		
		
		enum Initiation {
			case Error
			case Ready
		}
		enum Progress {
			case Continue
			case Done
		}
		enum Completion {
			case Error
			case Ready
		}
	}
}
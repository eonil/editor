//
//  Resolution.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

public struct Resolution<T> {
	public static func success(v:T) -> Resolution {
		return	Resolution(state: State<T>.Success({v}))
	}
	public static func failure(e:NSError) -> Resolution {
		return	Resolution(state: State<T>.Failure(e))
	}
	
	public var ok:Bool {
		get {
			switch state {
			case .Success(_):	return	true
			case .Failure(_):	return	false
			}
		}
	}
	
	public var value:T? {
		get {
			switch state {
			case .Success(let s):	return	s()
			default:				return	nil
			}
		}
	}
	public var error:NSError? {
		get {
			switch state {
			case .Failure(let s):	return	s
			default:				return	nil
			}
		}
	}
	
	////
	
	private let	state:State<T>
	
	private init(state:State<T>) {
		self.state	=	state
	}
}







private enum State<T> {
	case Success(()->T)
	case Failure(NSError)
}
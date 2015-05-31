//
//  Resolution.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/12.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation

public enum Resolution<T> {
	case Success(()->T)
	case Failure(NSError)
	
	public static func success(v:T) -> Resolution {
		return	Success({v})
	}
	public static func failure(e:NSError) -> Resolution {
		return	Failure(e)
	}
	
	public var ok:Bool {
		get {
			switch self {
			case .Success(_):	return	true
			case .Failure(_):	return	false
			}
		}
	}
	
	public var value:T? {
		get {
			switch self {
			case .Success(let s):	return	s()
			default:				return	nil
			}
		}
	}
	public var error:NSError? {
		get {
			switch self {
			case .Failure(let s):	return	s
			default:				return	nil
			}
		}
	}
	
	////
	
//	private let	state:State<T>
//	
//	private init(state:State<T>) {
//		self.state	=	state
//	}
}






//
//private enum State<T> {
//	case Success(()->T)
//	case Failure(NSError)
//}


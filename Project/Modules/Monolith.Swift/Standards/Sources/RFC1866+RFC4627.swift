//
//  RFC1866+RFC4627.swift
//  Standards
//
//  Created by Hoon H. on 11/21/14.
//
//

import Foundation


///	MARK:
///	Move to `RFC1866+RFC4627.swift` when compiler bug to be fixed.

public extension RFC1866.Form.URLEncoded {
	///	Supports only string -> string flat JSON object.
	public static func encode(parameters:JSON.Object) -> String? {
		var	ps2	=	[:] as [String:String]
		for p1 in parameters {
			if p1.1.string == nil {
				return	Error.trap("Input string contains non-string (possibly complex) value, and it cannot be used to form a query-string.")
			}
			ps2[p1.0]	=	p1.1.string!
		}
		return	encode(ps2)
	}
}






//
//  RFC1866.swift
//  Standards
//
//  Created by Hoon H. on 11/21/14.
//
//

import Foundation


///	https://tools.ietf.org/rfc/rfc1866.txt
///	https://tools.ietf.org/html/rfc1866
public struct RFC1866 {
	
	///	https://tools.ietf.org/html/rfc1866#section-8.2
	public struct Form {
		
		///	Represents HTML form fields in URL encoded strings.
		///	*URL encoded* means it is escaped by URL encoding rules, 
		///	and nothing related to URL standard (RFC 3986) itself.
		public struct URLEncoded {
			public static func encode(parameters:[String:String]) -> String {
				var	r1	=	[] as [(String,String)]
				for (k, v) in parameters {
					r1	+=	[(k, v)]
				}
				return	encode(r1)
			}
			///	Returning string is URL-encoded string.
			public static func encode(parameters:[(String, String)]) -> String {
				let	ue		=	Utility.URLEncode
				let	nvs1	=	parameters.map({ (n, v) in return ue(n) + "=" + ue(v) }) as [String]
				let	s1		=	join("&", nvs1)
				return	s1
			}
			///	Returns `nil` if any error has been found.
			///
			///	Note: input expression must be URL-encoded string.
			public static func decode(expression:String) -> [(String, String)]? {
				var	r1	=	[] as [(String,String)]
				let	ps1	=	split(expression, maxSplit: Int.max, allowEmptySlices: true, isSeparator: { c in c == "&" })
				for p1 in ps1 {
					let	ns1	=	split(p1, maxSplit: Int.max, allowEmptySlices: true, isSeparator: { c in c == "=" })
					if ns1.count != 2 {
						return	nil
					}
					let	ud	=	Utility.URLDecode
					let	n1	=	ud(ns1[0])
					let	v1	=	ud(ns1[1])
					
					if n1 == nil { return nil }
					if v1 == nil { return nil }
					
					r1		+=	[(n1!, v1!)]
				}
				return	r1
			}
			
			private struct Utility {
				static func URLEncode(s1:String) -> String {
					//	[Specification] says just
					//
					//	>	... non-alphanumeric characters are replaced by `%HH' ...
					//	
					//	This is vague, and I couldn't find proper definition. It is unclear
					//	which are the *alpha-numeric*, and is it fine to escape them too.
					//	So I just follows most safe conventions. Exclude Roman alphabet and
					//	number characters from the escape.
					//
					//	Added more characters according to this document.
					//	http://stackoverflow.com/questions/3208555/does-httputility-urlencode-match-the-spec-for-x-www-form-urlencoded
					//	But I am still not sure which characters are strictly allowed.
					
					let	cs	=	NSCharacterSet(charactersInString: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890" + "()*-._!")
					return	s1.stringByAddingPercentEncodingWithAllowedCharacters(cs)!		//	Must be succeeded always.
				}
				static func URLDecode(s1:String) -> String? {
					return	s1.stringByRemovingPercentEncoding
				}
			}
		}
	}
	
}






























extension RFC1866 {
	struct Test {
		static func run() {
			func assert(@autoclosure c:()->Bool) {
				if c() == false {
					fatalError("Test assertion failure!")
				}
			}
			func tx(c:()->()) {
				c()
			}
			
			///	Happy cases.
			tx {
				tx {
					let	sample1	=	[("aaa", "bbb"), ("ccc", "ddd")]
					let	result1	=	Form.URLEncoded.encode(sample1)
					
					//	`result` can have many solutions by the internal implementations.
					//	assert(result1 == "aaa=bbb&ccc=ddd")
					
					let	result2	=	Form.URLEncoded.decode(result1)
					assert(result2 != nil)
					assert(result2!.count == 2)
					assert(result2![0].0 == "aaa")
					assert(result2![0].1 == "bbb")
					assert(result2![1].0 == "ccc")
					assert(result2![1].1 == "ddd")
				}
				tx {
					let	sample1	=	[("aaa", ""), ("", "ddd")]
					let	result1	=	Form.URLEncoded.encode(sample1)
					
					//	`result` can have many solutions by the internal implementations.
					//	assert(result1 == "aaa=&=ddd")
					
					let	result2	=	Form.URLEncoded.decode(result1)
					assert(result2 != nil)
					assert(result2!.count == 2)
					assert(result2![0].0 == "aaa")
					assert(result2![0].1 == "")
					assert(result2![1].0 == "")
					assert(result2![1].1 == "ddd")
				}
				tx {
					let	sample1	=	[("?&=", "aaa"), ("bbb", "?&=")]
					let	result1	=	Form.URLEncoded.encode(sample1)
					
					//	`result` can have many solutions by the internal implementations.
					//	assert(result1 == "%3F%26%3D=aaa&bbb=%3F%26%3D")
					
					let	result2	=	Form.URLEncoded.decode(result1)
					assert(result2 != nil)
					assert(result2!.count == 2)
					assert(result2![0].0 == "?&=")
					assert(result2![0].1 == "aaa")
					assert(result2![1].0 == "bbb")
					assert(result2![1].1 == "?&=")
				}
			}
			
			
			///	Evil cases.
			tx {
			}
			
		}
	}
}


























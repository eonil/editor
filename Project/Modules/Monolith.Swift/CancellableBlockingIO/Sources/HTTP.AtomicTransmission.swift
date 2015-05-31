//
//  HTTPAtomicDataTransmission.swift
//  EonilBlockingAsynchronousIO
//
//  Created by Hoon H. on 11/7/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation




private let	DEFAULT_TIMEOUT		=	15 as NSTimeInterval







extension HTTP {
	public struct AtomicTransmission {
		public typealias	Error	=	DebugPrintable
		
		public typealias Header	=	(
			name:String,
			value:String
		)
		
		public struct Request {
			public var	security:Bool
			public var	method:String
			public var	host:String
			public var	port:Int
			public var	path:String					///<	Will be encoded using RFC 3986. So do not passed encoded one.
			public var	headers:[Header]
			public var	body:NSData?
			
			public init(security:Bool, method:String, host:String, port:Int, path:String, headers:[HTTP.AtomicTransmission.Header], body:NSData?) {
				self.security	=	security
				self.method		=	method
				self.host		=	host
				self.port		=	port
				self.path		=	path
				self.headers	=	headers
				self.body		=	body
			}
		}
		public struct Response {
			public var	status:Int
			public var	headers:[Header]
			
			///	Body can be missing if the request does not need to provide 
			///	output as a successful request. `nil` on this parameter does 
			///	not mean it request failed. If you got a this object, then
			///	that means request itself finished successfully.
			public var	body:NSData?
		}
		
//		public enum Initiate {
//			case Launch(Request)
//		}
		public enum Complete {
			case Cancel					///<	Operation stopped actively by programmer command.
			case Abort(Error)			///<	Operation stopped passively without programmer command.
			case Done(Response)			///<	Operation normally finished.
		}
	}
}

public extension HTTP.AtomicTransmission.Request {
	///	Creates with these default parameters.
	///
	///		self.security	=	false
	///		self.method		=	"GET"
	///		self.port		=	80
	///		self.headers	=	[]
	///		self.body		=	nil
	///
	public init(host:String, path:String) {
		self.security	=	false
		self.method		=	"GET"
		self.host		=	host
		self.port		=	80
		self.path		=	path
		self.headers	=	[]
		self.body		=	nil
	}
}

extension HTTP.AtomicTransmission.Request: DebugPrintable {
	public var debugDescription:String {
		get {
			return	"Request(securit: \(security), method: \(method.debugDescription), host: \(host.debugDescription), port: \(port), path: \(path.debugDescription), headers: \(headers.debugDescription), body: \(body?.length) bytes)"
		}
	}
}

extension HTTP.AtomicTransmission.Response: DebugPrintable {
	public var debugDescription:String {
		get {
			return	"Response(status: \(status), headers: \(headers.debugDescription), body: \(body?.length) bytes)"
		}
	}
}

extension HTTP.AtomicTransmission.Complete: DebugPrintable {
	public var debugDescription:String {
		get {
			switch self {
			case .Cancel:		return	"Cancel"
			case .Abort(let s):	return	"Abort(\(s.debugDescription))"
			case .Done(let s):	return	"Done(\(s.debugDescription))"
			}
		}
	}
}








public extension HTTP.AtomicTransmission {
	
	///	Uploads and downloads all data at once.
	///	This blocks the caller until the operation finishes.
	public static func execute(parameters:Request, cancellation:Trigger) -> Complete {
		if cancellation.state {
			return	Complete.Cancel
		}
		
		////
		
		Debug.log("AtomicTransmission started.")
		
		let	addr1	=	NSURL(scheme: (parameters.security ? "https" : "http"), host: parameters.host, path: parameters.path)!
		let	reqe1	=	NSMutableURLRequest(URL: addr1, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: DEFAULT_TIMEOUT)
		reqe1.HTTPMethod	=	parameters.method
		for h1 in parameters.headers {
			reqe1.addValue(h1.value, forHTTPHeaderField: h1.name)
		}
		reqe1.HTTPBody		=	parameters.body
		
		var	tran1	=	Transfer<Complete>()
		let	task1	=	NSURLSession.sharedSession().dataTaskWithRequest(reqe1, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
			if let err2 = error {
				Debug.log("AtomicTransmission error discovered.")
				if err2.code == NSURLErrorCancelled {
					Debug.log("AtomicTransmission error by cancel.")
					tran1.signal(Complete.Cancel)
					return
				} else {
					Debug.log("AtomicTransmission error is \(err2.localizedDescription.debugDescription).")
					tran1.signal(Complete.Abort(err2.localizedDescription))
					return
				}
			}
			
			let	r1	=	response as! NSHTTPURLResponse
			var	hs1	=	[] as [Header]
			for h1 in r1.allHeaderFields {
				hs1.append((name: h1.0 as! String, value: h1.1 as! String))
			}
			let	r2	=	Response(status: r1.statusCode, headers: hs1, body: data!)
			tran1.signal(Complete.Done(r2))
			
			Debug.log("AtomicTransmission finished successfully.")
		})
		
		let watc1	=	cancellation.watch {
			Debug.log("AtomicTransmission detected cancellation trigerring.")
			task1.cancel()
		}
		
		task1.resume()
		return	tran1.wait()
	}
	
}












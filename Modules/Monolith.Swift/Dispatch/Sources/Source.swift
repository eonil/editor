//
//  Source.swift
//  EonilDispatch
//
//  Created by Hoon H. on 11/12/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation



///	This object owns the descriptor.
///	Which means closes the descriptor when deinitialised.
public class FileDescriptor : Handle {
//	///	This object does not own the handle.
//	///	You need to keep it alive while everything done.
//	public convenience init(handle:NSFileHandle) {
//		self.init(UInt(handle.fileDescriptor))		///	TODO:	Check safety of this operation. Make it crash on any issue.
//	}
	public convenience init(path:String) {
		let	p2	=	path.fileSystemRepresentation()
		let	fd1	=	open(path.fileSystemRepresentation(), O_EVTONLY)
		if fd1 == -1 {
			fatalError("Couldn't create a file-descriptor for the path `\(path)`.")
		}
		self.init(UInt(fd1))		///	TODO:	Check safety of this operation. Make it crash on any issue.
	}
	override init(_ raw:UInt) {
		super.init(raw)
	}
	deinit {
		if close(Int32(raw)) != 0 {
			fatalError("Failed to close a file-descriptor `\(raw)`.")
		}
	}
}

public class Handle {
	let	raw:UInt
	
	init(_ raw:UInt) {
		self.raw	=	raw
	}
}









public class VNodeSource : Source {
	public init(file:FileDescriptor, flag:VNodeFlags, queue:Queue) {
		super.init(type: SourceType.VNode, handle: file, mask: flag.mapToObjC(), queue: queue)
	}
}

public class Source : Object {
	var rawSource:dispatch_source_t {
		get {
			return	raw as dispatch_source_t
		}
	}
	
	init(type: SourceType, handle: Handle, mask: UInt, queue:Queue) {
		super.init(dispatch_source_create(type.mapToObjC(), handle.raw, mask, queue.raw))
	}
	
	public var	eventHandler:()->() = NOOP {
		didSet {
			dispatch_source_set_event_handler(rawSource, eventHandler)
		}
	}
	
	public var	cancelHandler:()->() = NOOP {
		didSet {
			dispatch_source_set_cancel_handler(rawSource, cancelHandler)
		}
	}
	
//	func setEventHandler(f:()->()) {
//		dispatch_source_set_event_handler(raw, f)
//	}
//	func setCancelHandler(f:()->()) {
//		dispatch_source_set_cancel_handler(raw, f)
//	}
	public func cancel() {
		dispatch_source_cancel(raw)
	}
	
}

//#define DISPATCH_SOURCE_TYPE_DATA_ADD
//#define DISPATCH_SOURCE_TYPE_DATA_OR
//#define DISPATCH_SOURCE_TYPE_MACH_RECV
//#define DISPATCH_SOURCE_TYPE_MACH_SEND
//#define DISPATCH_SOURCE_TYPE_PROC
//#define DISPATCH_SOURCE_TYPE_READ
//#define DISPATCH_SOURCE_TYPE_SIGNAL
//#define DISPATCH_SOURCE_TYPE_TIMER
//#define DISPATCH_SOURCE_TYPE_VNODE
//#define DISPATCH_SOURCE_TYPE_WRITE
//#define DISPATCH_SOURCE_TYPE_MEMORYPRESSURE

///	TODO:	Incomplete. Finish this later.
public enum SourceType {
	case VNode
	case MemoryPressure
	
	func mapToObjC() -> dispatch_source_type_t {
		switch self {
			case VNode:				return	DISPATCH_SOURCE_TYPE_VNODE
			case MemoryPressure:	return	DISPATCH_SOURCE_TYPE_MEMORYPRESSURE
		}
	}
}






//	#define DISPATCH_VNODE_DELETE    0x1
//	#define DISPATCH_VNODE_WRITE     0x2
//	#define DISPATCH_VNODE_EXTEND    0x4
//	#define DISPATCH_VNODE_ATTRIB    0x8
//	#define DISPATCH_VNODE_LINK      0x10
//	#define DISPATCH_VNODE_RENAME    0x20
//	#define DISPATCH_VNODE_REVOKE    0x40
public struct VNodeFlags {
	public static let Delete		=	VNodeFlags(rawValue: DISPATCH_VNODE_DELETE)
	public static let Write			=	VNodeFlags(rawValue: DISPATCH_VNODE_WRITE)
	public static let Extend		=	VNodeFlags(rawValue: DISPATCH_VNODE_EXTEND)
	public static let Attrib		=	VNodeFlags(rawValue: DISPATCH_VNODE_ATTRIB)
	public static let Link			=	VNodeFlags(rawValue: DISPATCH_VNODE_LINK)
	public static let Rename		=	VNodeFlags(rawValue: DISPATCH_VNODE_RENAME)
	public static let Revoke		=	VNodeFlags(rawValue: DISPATCH_VNODE_REVOKE)
	
	public let	rawValue:dispatch_source_vnode_flags_t
	
	func mapToObjC() -> dispatch_source_vnode_flags_t {
		return	self.rawValue
	}
}
public func | (left:VNodeFlags, right:VNodeFlags) -> VNodeFlags {
	return	VNodeFlags(rawValue: left.rawValue | right.rawValue)
}
extension VNodeFlags : Printable {
	public var description:String {
		get {
			switch self.mapToObjC() {
			case DISPATCH_VNODE_DELETE:		return	"DELETE"
			case DISPATCH_VNODE_WRITE:		return	"WRITE"
			case DISPATCH_VNODE_EXTEND:		return	"EXTEND"
			case DISPATCH_VNODE_ATTRIB:		return	"ATTRIB"
			case DISPATCH_VNODE_LINK:		return	"LINK"
			case DISPATCH_VNODE_RENAME:		return	"RENAME"
			case DISPATCH_VNODE_REVOKE:		return	"REVOKE"
			default:						return	"????"
			}
		}
	}
}


//public enum VNodeFlags : dispatch_source_vnode_flags_t, RawOptionSetType {
//	case Delete		=	0x1
//	case Write		=	0x2
//	case Extend		=	0x4
//	case Attrib		=	0x8
//	case Link		=	0x10
//	case Rename		=	0x20
//	case Revoke		=	0x40
//	
//	func mapToObjC() -> dispatch_source_vnode_flags_t {
//		return	self.rawValue
//	}
//}
//
//public func | (left:VNodeFlags, right:VNodeFlags) -> VNodeFlags {
//	return	VNodeFlags(rawValue: left.rawValue | right.rawValue)!
//}







func NOOP() {
}
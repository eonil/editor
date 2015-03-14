//
//  StringStreamProcessing.swift
//  Precompilation
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation




























//
//	These types cannot follow `GeneratorType` because the concept is "on-demand"
//	rather than being notified.
//







///	You push `String` and be notified on any line discovery.
///
///	If last input does not finish with newline character it will not be notified,
///	and you can get it from `incompleteLineContent`.
///
///	Set `onLine` function to get notified.
///
public struct LineDispatcher {
	public var	onLine			=	{ _ in () } as (line:String)->()
	public init() {
	}
	public mutating func push(s:String) {
		let	NEWLINE	=	"\n" as Character
		let	ps		=	split(s, maxSplit: 1, allowEmptySlices: true, isSeparator: { c in c == NEWLINE })
		
		_buffer.extend(ps[0])
		if ps.count == 2 {
			onLine(line: _buffer + "\n")
			_buffer	=	ps[1]
		}
	}
	
	private var	_buffer:String	=	""
}

extension LineDispatcher {
	///	Line content currently on progress but not yet finished.
	public var incompleteLineContent:String {
		get {
			return	_buffer
		}
	}
	public mutating func dispatchIncompleteLine() {
		onLine(line: _buffer)
		_buffer	=	""
	}
}











///	You push `NSData` and be notified on any string discovery.
///
///	If last input does not build a valid "Unicode Scalar Value", 
///	then it will not be notified until it to be completed by pushing
///	more input code units. You can get this using `incompleteCodeUnits`.
///
///	Set `onString` function to get notified.
///
public final class UTF8StringDispatcher {
	public var	onString	=	{ s in return () } as (String)->()
	public init() {
	}
	deinit {
//		assert(g.u8s.count == 0, "If you cannot ")
	}
	
	public var incompleteCodeUnits:ArraySlice<UTF8.CodeUnit> {
		get {
			return	g.u8s[g.idx..<g.u8s.endIndex]
		}
	}
	
//	public func reset() {
//		g	=	InfinitePagingUTF8CodeUnitGenerator()
//	}
	public func push(d:NSData) {
		let	p	=	UnsafeBufferPointer<UTF8.CodeUnit>(start: UnsafePointer<UTF8.CodeUnit>(d.bytes), count: d.length)
		g.u8s.splice(p, atIndex: g.u8s.count)
		
		var	ude	=	UTF8()
		var	ok	=	true
		while ok {
			var	g1	=	g
			let	r	=	ude.decode(&g1)
			switch r {
			case .Result(let us):
				let	s	=	String(us)
				onString(s)
				g		=	g1
				
			case .EmptyInput:
				ok		=	false
				
			case .Error:
				fatalError("Unrecognizable UTF-8 input data.")
			}
		}
		
		g.compact()
	}
	
	
	////
	
	private var	g			=	InfinitePagingUTF8CodeUnitGenerator()
	
	private struct InfinitePagingUTF8CodeUnitGenerator: GeneratorType {
		let	PAGE	=	4096
		var	u8s		=	[] as [UTF8.CodeUnit]
		var	idx		=	0
		
		init() {
			u8s.reserveCapacity(PAGE)
		}
		
		
		mutating func compact() {
			if u8s.count > PAGE {
				u8s.removeRange(0..<PAGE)
				idx	-=	PAGE
			}
		}
		mutating func next() -> UTF8.CodeUnit? {
			if idx == u8s.count {
				return	nil
			} else {
				let	b	=	u8s[idx]
				idx++
				return	b
			}
		}
	}
}





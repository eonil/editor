//
//  Packet.swift
//  EditorDebuggingFeature
//
//  Created by Hoon H. on 2015/01/19.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation


///
///
///	Sending Procedure
///	-----------------
///	1.	Escape data with `}`.
///	2.	Apply RLE compression on data. (optional)
///	3.	Write `Packet`.
///
///	Receiving Prcedure
///	------------------
///	1.	Read `Packet`.
///	2.	Apply RLE decompression on data. (required)
///	3.	Unescape data `}`.
///
///
struct Packet: Writable {
	typealias	Checksum	=	SingleByteHex
	
	///	`Packet` will apply escape on this data. Do not pre-escape this.
	var	data	=	[] as [UInt8]
	
	func checksum() -> Checksum {
		return	data.reduce(0, combine: +).toLowercaseHex()
	}
	func writeToChannel<C:SinkType where C.Element == UInt8>(inout channel: C) {
		let	data1	=	escapeDataForPacket(data)
		let	chks	=	checksum()
		
		assert(find(data1, U8U("#")) == nil)
		assert(find(data1, U8U("$")) == nil)
		
		channel.put(U8U("$"))
		data1.map { u in channel.put(u) }
		channel.put(U8U("#"))
		channel.put(chks.0)
		channel.put(chks.1)
	}
}





struct PacketParser {
	var	phase		=	Phase.Ready
	var	body		=	[] as [U8U]
	var	checksum	=	[] as [U8U]
	
	func done() -> Bool {
		return	phase == Phase.OK || phase == Phase.Error
	}
	func data() -> [U8U]? {
		if phase == Phase.OK {
			return	unescapePacketData(RunLengthEncoding.decode(body))
		}
		return	nil
	}
	mutating func push(u:U8U, allowReset:Bool = false) {
		if allowReset {
			if u == U8U("$") {
				self	=	PacketParser()
			}
		}
		
		////
		
		switch phase {
		case .Ready:
			precondition(u == U8U("$"))
			phase	=	Phase.Body
			
		case .Body:
			if u != U8U("#") {
				body.append(u)
			} else {
				phase	=	Phase.Checksum
			}
			
		case .Checksum:
			if checksum.count < 2 {
				checksum.append(u)
			} else {
				let	chks	=	UInt8(lowercaseHex: (checksum[0], checksum[1]))
				let	ok		=	body.reduce(0, combine: +) == chks
				phase		=	ok ? Phase.OK : Phase.Error
			}
			
		case .OK, .Error:
			fatalError("This parser already done.")
		}
		
	}
	
	enum Phase {
		case Ready
		case Body
		case Checksum
		case OK
		case Error
	}
}















































func escapeDataForPacket(data:[UInt8]) -> [UInt8] {
	var	data1	=	[] as [UInt8]
	for u in data {
		if u == U8U("#") || u == U8U("$") || u == U8U("}") {
			data1.append(U8U("}"))
			data1.append(u ^ U8U(0x20))
		} else {
			data1.append(u)
		}
	}
	return	data1
}










func unescapePacketData(data:[UInt8]) -> [UInt8] {
	return	[UInt8](packetDataUnescapingGenerator(data.generate()))
}
func packetDataUnescapingGenerator<G:GeneratorType where G.Element == UInt8>(g:G) -> GeneratorOf<UInt8> {
	var	g1	=	g
	return	GeneratorOf {
		while let u = g1.next() {
			if u == U8U("}") {
				let	u1	=	g1.next()!
				let	u2	=	u1 ^ U8U(0x20)
				return	u2
			} else {
				return	u
			}
		}
		return	nil
	}
}











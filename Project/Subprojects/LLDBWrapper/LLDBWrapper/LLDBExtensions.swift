//
//  LLDBExtensions.swift
//  LLDBWrapper
//
//  Created by Hoon H. on 2015/01/28.
//
//

import Foundation
import LLDBWrapper













///	MARK:
///	MARK:	Drivers


public extension LLDBDebugger {
	public var	allTargets:[LLDBTarget] {
		get {
			return	(0..<self.numberOfTargets).map { i in self.targetAtIndex(i) }
		}
	}
}


public extension LLDBTarget {
	public var	allModules:[LLDBModule] {
		get {
			return	(0..<self.numberOfModules).map { i in self.moduleAtIndex(i) }
		}
	}
	public var allBreakpoints:[LLDBBreakpoint] {
		get {
			return	(0..<self.numberOfBreakpoints).map { i in self.breakpointAtIndex(i) }
		}
	}
	public func createBreakpointByLocationWithFilePath(file:String, lineNumber:UInt32) -> LLDBBreakpoint {
		let	fs	=	LLDBFileSpec(path: file, resolve: true)
		return	self.createBreakpointByLocationWithFileSpec(fs, lineNumber: lineNumber)
	}
}

































///	MARK:
///	MARK:	Execution States

public extension LLDBProcess {
	public var	allThreads:[LLDBThread] {
		get {
			return	(0..<self.numberOfThreads).map { i in self.threadAtIndex(i) }
		}
	}
	public func writeToStandardInput(source:NSData) -> Int {
		let	sz				=	source.length
		let	sz1				=	size_t(sz)
		let	written_len		=	self.putStandardInput(UnsafePointer<CChar>(source.bytes), length: sz1)
		let	written_len1	=	Int(written_len)
		return	written_len1
	}
//	///	Crashes if source data couldn't be fully written.
//	func writeToStandardInput(source:String) {
//		let	d	=	source.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
//		let	len	=	writeToStandardInput(d)
//		precondition(len == d.length, "Couldn't write all string to STDIN.")
	//	}
	public func readFromStandardOutput() -> NSData {
		let	len			=	8192
		let	d			=	NSMutableData()
		d.length		=	len
		let	read_len	=	self.getStandardOutput(UnsafeMutablePointer<CChar>(d.mutableBytes), length: size_t(len))
		let	read_len1	=	Int(read_len)
		let	d1			=	d.subdataWithRange(NSRange(location: 0, length: read_len1))
		return	d1
	}
	public func readFromStandardError() -> NSData {
		let	len			=	8192
		let	d			=	NSMutableData()
		d.length		=	len
		let	read_len	=	self.getStandardError(UnsafeMutablePointer<CChar>(d.mutableBytes), length: size_t(len))
		let	read_len1	=	Int(read_len)
		let	d1			=	d.subdataWithRange(NSRange(location: 0, length: read_len1))
		return	d1
	}
	
	public func readMemory(range:Range<LLDBAddressType>) -> (data:NSData, error:LLDBError?) {
		let	len		=	range.endIndex - range.startIndex
		let	d		=	NSMutableData()
		var	e		=	 nil as LLDBError?
		d.length	=	Int(len)

		let	avail	=	self.readMemory(range.startIndex, buffer: d.mutableBytes, size: size_t(len), error: &e)
		let	avail1	=	Int(avail)
		let	d1		=	d.subdataWithRange(NSRange(location: 0, length: avail1))
		return	(d1, e)
	}
	public func writeMemory(range:Range<LLDBAddressType>, data:NSData) -> (length:Int, error:LLDBError?) {
		let	sz		=	range.endIndex - range.startIndex
		let	sz1		=	size_t(sz)
		var	e		=	nil as LLDBError?
		
		let	avail	=	self.writeMemory(range.startIndex, buffer: data.bytes, size: sz1, error: &e)
		let	avail1	=	Int(avail)
		return	(avail1, e)
	}
	
	public class func allRestartedReasonsForEvent(event:LLDBEvent) -> [String] {
		return	(0..<self.numberOfRestartedReasonsFromEvent(event)).map { i in self.restartedReasonAtIndexFromEvent(event, index: i) }
	}
	public var numberOfSupportedHardwareWatchpoints:(number:Int, error:LLDBError?) {
		get {
			var	e	=	nil as LLDBError?
			let	r	=	self.numberOfSupportedHardwareWatchpoints(&e)
			let	r1	=	Int(r)
			return	(r1,e)
		}
	}
	
	public func loadImage(imageSpec:LLDBFileSpec) -> (Int, LLDBError?) {
		var	e	=	nil as LLDBError?
		let	r	=	self.loadImage(imageSpec, error: &e)
		let	r1	=	Int(r)
		return	(r1, e)
	}
	
//	var	allExtendedBacktraceTypes:[String] {
//		get {
//			return	(0..<numberOfExtendedBacktraceTypes).map { i in self.extendedBacktraceTypeAtIndex(i) }
//		}
//	}
}

public extension LLDBProcess {
	typealias	BroadcastBit	=	LLDbProcessBroadcastBit
}
//	Values are explicitly assigned at C++ level, so it seems safe to copy them here.
public struct LLDbProcessBroadcastBit: RawOptionSetType {
	public typealias RawValue			=	UInt32
	
	public static let allZeros			=	LLDbProcessBroadcastBit(rawValue: 0)
	public static let StateChanged		=	LLDbProcessBroadcastBit(rawValue: 1 << 0)
	public static let Interrupt			=	LLDbProcessBroadcastBit(rawValue: 1 << 1)
	public static let STDOUT			=	LLDbProcessBroadcastBit(rawValue: 1 << 2)
	public static let STDERR			=	LLDbProcessBroadcastBit(rawValue: 1 << 3)
	public static let ProfileData		=	LLDbProcessBroadcastBit(rawValue: 1 << 4)
	
	public let	rawValue:RawValue
	
	public init(rawValue:RawValue) {
		self.rawValue	=	rawValue
	}
	public init(nilLiteral:()) {
		self.rawValue	=	0
	}
}



public extension LLDBThread {
//	///	Returns collection of all valid frames.
//	///	Number of returned frames may be different
//	///	because `frameAtIndex` may return `nil`,
//	public var frames:[LLDBFrame] {
//		get {
//		}
//	}
	public var	allFrames:[LLDBFrame?] {
		get {
			return	(0..<self.numberOfFrames).map { i in self.frameAtIndex(i) }
		}
	}
	public var	allStopReasonData:[UInt64] {
		get {
			return	(0..<self.stopReasonDataCount).map { i in self.stopReasonDataAtIndex(UInt32(i)) }
		}
	}
	public func returnFromFrame(frame:LLDBFrame) -> (returnValue:LLDBValue, error:LLDBError?) {
		var	v	=	nil as LLDBValue?
		let	e	=	self.returnFromFrame(frame, returnValue: &v);
		return	(v!,e)
	}
}

//public extension LLDBThread {
//	typealias	BroadcastBit	=	LLDbThreadBroadcastBit
//}
////	Values are explicitly assigned at C++ level, so it seems safe to copy them here.
//public struct LLDbThreadBroadcastBit: RawOptionSetType {
//	public typealias RawValue	=	UInt32
//	
//	public static let allZeros					=	LLDbThreadBroadcastBit(rawValue: 0)
//	public static let StackChanged				=	LLDbThreadBroadcastBit(rawValue: 1 << 0)
//	public static let ThreadSuspended			=	LLDbThreadBroadcastBit(rawValue: 1 << 1)
//	public static let ThreadResumed				=	LLDbThreadBroadcastBit(rawValue: 1 << 2)
//	public static let SelectedFrameChanged		=	LLDbThreadBroadcastBit(rawValue: 1 << 3)
//	public static let ThreadSelected			=	LLDbThreadBroadcastBit(rawValue: 1 << 4)
//	
//	public let	rawValue:RawValue
//	
//	public init(rawValue:RawValue) {
//		self.rawValue	=	rawValue
//	}
//	public init(nilLiteral:()) {
//		self.rawValue	=	0
//	}
//}













extension LLDBValueList: CollectionType {
	public var count:Int {
		get {
			return	Int(size)
		}
	}
	public var startIndex:Int {
		get {
			return	0
		}
	}
	public var endIndex:Int {
		get {
			return	count
		}
	}
	public subscript(index:Int) -> LLDBValue {
		get {
			return	valueAtIndex(UInt32(index))
		}
	}
	public func generate() -> GeneratorOf<LLDBValue> {
		var	idx	=	0
		return	GeneratorOf { [weak self] in
			idx++
			if idx == self!.count {
				return	nil
			} else {
				return	self![idx]
			}
		}
	}
	public var	allValues:[LLDBValue?] {
		get {
			return	(0..<self.count).map { i in self[i] }
		}
	}
	public var allAvailableValues:[LLDBValue] {
		get {
			return	allValues.filter({ v in v != nil }).map({ v in v! })
		}
	}
}



public extension LLDBValue {
	public var	allChildren:[LLDBValue?] {
		get {
			return	(0..<self.numberOfChildren).map { i in self.childAtIndex(i) }
		}
	}
	public var allAvailableChildren:[LLDBValue] {
		get {
			return	allChildren.filter({ v in v != nil }).map({ v in v! })
		}
	}
}































///	MARK:
///	MARK:	Code Database

public extension LLDBModule {
	public var	allSymbols:[LLDBSymbol] {
		get {
			return	(0..<self.numberOfSymbols).map { i in self.symbolAtIndex(i) }
		}
	}
}


extension LLDBInstructionList: CollectionType {
	public var count:Int {
		get {
			return	Int(size)
		}
	}
	public var startIndex:Int {
		get {
			return	0
		}
	}
	public var endIndex:Int {
		get {
			return	Int(count)
		}
	}
	public subscript(index:Int) -> LLDBInstruction {
		get {
			return	instructionAtIndex(UInt32(index))
		}
	}
	public func generate() -> GeneratorOf<LLDBInstruction> {
		var	idx	=	0
		return	GeneratorOf { [weak self] in
			idx++
			if idx == self!.count {
				return	nil
			} else {
				return	self![idx]
			}
		}
	}
	public var	allInstructions:[LLDBInstruction] {
		get {
			return	(0..<self.count).map { i in self[i] }
		}
	}
}






























///	MARK:
///	MARK:	Source Tracking

public extension LLDBCompileUnit {
	public var	allLineEntries:[LLDBLineEntry] {
		get {
			return	(0..<self.numberOfLineEntries).map { i in self.lineEntryAtIndex(i) }
		}
	}
	public var	allSupportFiles:[LLDBFileSpec] {
		get {
			return	(0..<self.numberOfSupportFiles).map { i in self.supportFileAtIndex(i) }
		}
	}
}
































///	MARK:
///	MARK:	Event Listening Related

public extension LLDBBroadcaster {
//	func broadcastEventByType2(eventType:UInt32) {
//		self.broadcastEventByType(eventType, unique: false);
//	}
	
//	func addListener<T:RawOptionSetType where T.RawValue == UInt32>(listener: LLDBListener, eventMask: T) {
//		self.addListener(listener, eventMask: eventMask.rawValue)
//	}
}
public extension LLDBProcess {
	/// Return the event bits that were granted to the listener
	func addListener(listener: LLDBListener, eventMask: LLDBProcess.BroadcastBit) -> LLDBProcess.BroadcastBit {
		return	LLDBProcess.BroadcastBit(rawValue: self.broadcaster.addListener(listener, eventMask: eventMask.rawValue))
	}
	func removeListener(listener: LLDBListener, eventMask: LLDBProcess.BroadcastBit) -> Bool {
		return	self.broadcaster.removeListener(listener, eventMask: eventMask.rawValue)
	}
}
//public extension LLDBThread {
//	func addListener(listener: LLDBListener, eventMask: LLDBThread.BroadcastBit) {
//		self.broadcaster.addListener(listener, eventMask: eventMask.rawValue)
//	}
//	func removeListener(listener: LLDBListener, eventMask: LLDBThread.BroadcastBit) {
//		self.broadcaster.removeListener(listener, eventMask: eventMask.rawValue)
//	}
//}

public extension LLDBListener {
	func waitForEvent(seconds:Int) -> LLDBEvent? {
		let	s	=	UInt32(seconds)
		var	e	=	nil as LLDBEvent?
		let	ok	=	self.waitForEvent(s, event: &e)
		if ok {
			return	e
		} else {
			return	nil
		}
	}
}

















///	MARK:
///	MARK:	Infrastructure Utilities

public extension LLDBData {
	public var	data:NSData {
		get {
			let	d		=	NSMutableData()
			var	e		=	nil as LLDBError?
			d.length	=	Int(self.byteSize)
			let	sz1		=	self.readRawDataWithOffset(LLDBOffsetType(0), buffer: d.mutableBytes, size: self.byteSize, error: &e)
			precondition(e == nil, "An error `\(e)` occured while reading from this object.")
			precondition(sz1 == UInt(d.length))
			precondition(sz1 == self.byteSize)
			return	d
		}
		set(v) {
			var	e		=	nil as LLDBError?
			self.setDataWithBuffer(v.bytes, size: size_t(v.length), endian: self.byteOrder, addressSize: self.addressByteSize, error: &e)
			
			precondition(e == nil, "An error `\(e)` occured while writing to this object.")
		}
	}
}








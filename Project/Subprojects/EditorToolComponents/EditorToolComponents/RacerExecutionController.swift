//
//  RacerExecutionController.swift
//  Editor
//
//  Created by Hoon H. on 12/8/14.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Foundation


///	Racer binary will be shippped within application bundle.
///
///	Future
///	------
///	If racer becomes better, I think I will integrate it in-process.
///	Otherwise I think I have to write a new autocompletion library...
///	In either case, this needs better syntax parser by Rust compiler team.
public class RacerExecutionController {
	
	public init() {
	}
	
	///	Executes Racer (Rust autocompletion program) in remote process synchronously.
	///	Once started process cannot be stopped. (cannot be cancelled)
	///	If you request a new resolution before previous execution has not been finished,
	///	this will spawn a new process. If you request many resolutions, this may
	///	spawn very many processes. I do not optimise this because this is intended
	///	to be an ad-hoc autocompletion. Also, Racer itself is not very matured.
	///
	///	Safe to be called from any thread simultaneously.
	public func resolve(fullyQualifiedName:String) -> [Match] {
		return	runCompletionWithFullyQualifiedName(fullyQualifiedName)
	}
	
	

	///	Racer prints result like this.
	///
	///		MATCH vec,1,0,/Users/Eonil/Unix/rustsrc/src/libcollections/vec.rs,Module,/Users/Eonil/Unix/rustsrc/src/libcollections/vec.rs
	///
	///	`MATCH` will be stripped away.
	///	`vec`			->	`matchString`.
	///	`1`				->	`lineNumber`.
	///	`0`				->	`characterNumber`.
	///	`.../vec.rs`	->	`filePath`.
	///	`Module`		->	`mtype`.
	///	`.../vec.rs`	->	`constext`.
	public struct Match {
		public let	matchString:String
		public let	lineNumber:Int
		public let	characterNumber:Int
		public let	filePath:String
		public let	mtype:String
		public let	constext:String
		
//		public init(matchString:String, lineNumber:Int, characterNumber:Int, filePath:String, mtype:String, constext:String) {
//			self.matchString		=	matchString
//			self.lineNumber			=	lineNumber
//			self.characterNumber	=	characterNumber
//			self.filePath			=	filePath
//			self.mtype				=	mtype
//			self.constext			=	constext
//		}
	}
}







//private struct Racer {
//	static func complete(lineNumber:Int, charNumber:Int, fileName:String) -> [Match] {
//		
//	}
//	static func runProcess(arguments:[String]) -> String {
//		
//	}
//}

private typealias	M	=	RacerExecutionController.Match

extension M {
	init(expression:String) {
		assert(expression.hasPrefix("MATCH "))
		let	x2	=	expression.substringFromIndex("MATCH ".endIndex)
		let	cs	=	x2.componentsSeparatedByString(",")
		
		self.matchString		=	cs[0]
		self.lineNumber			=	cs[1].toInt()!
		self.characterNumber	=	cs[2].toInt()!
		self.filePath			=	cs[3]
		self.mtype				=	cs[4]
		self.constext			=	cs[5]
	}
}

private func runCompletionWithLocation(lineNumber:Int, charNumber:Int, fileName:String) -> [M] {
	let	p	=	NSBundle.mainBundle().pathForResource("Tools/racer", ofType: nil)!
	let	al	=	["complete", lineNumber.description, charNumber.description, fileName]
	let	s	=	run2(p, al)
	let	lns	=	s.componentsSeparatedByString("\n")
	let	ms	=	lns.map({ a in M(expression: a) })
	return	ms
}
private func runCompletionWithFullyQualifiedName(expression:String) -> [M] {
	let	p	=	NSBundle.mainBundle().pathForResource("Tools/racer", ofType: nil)!
	let	al	=	["complete", expression]
	let	s	=	run2(p, al)
	let	lns	=	s.componentsSeparatedByString("\n").filter({ a in return a != "" })
	let	ms	=	lns.map({ a in M(expression: a) })
	return	ms
}

private func run2(pathToProgram:String, argumentExpressions:[String]) -> String {
	let	t1	=	NSTask()
	
	///	TODO:
	///	Currently, this app just invokes Rust binaries installed on current system at specific location.
	///	This need to be patched.
	///	And this app need to carry the whole Rust binaries to be a complete solution. Just like Xcode.
	///	I am not sure which one would be better.
	let	e1	=	[
		"RUST_SRC_PATH"	:		"~/Unix/rustsrc/src".stringByExpandingTildeInPath,
		"DYLD_LIBRARY_PATH":	"~/Unix/rust/lib".stringByExpandingTildeInPath,
	]
	
	t1.launchPath			=	pathToProgram
	t1.arguments			=	argumentExpressions
	t1.environment			=	e1
	
	let	in1				=	NSPipe()
	let	out1			=	NSPipe()
	let	err1			=	NSPipe()
	t1.standardInput	=	in1
	t1.standardError	=	err1
	t1.standardOutput	=	out1
	
	t1.launch()
	t1.waitUntilExit()
	
	assert(t1.running == false)
//	Debug.log(pathToProgram)
//	Debug.log(t1.terminationStatus)
//	Debug.log(t1.terminationReason)
	assert(t1.terminationStatus == 0)
	
	let	err3	=	err1.fileHandleForReading.readUTF8StringToEndOfFile()
	let	out3	=	out1.fileHandleForReading.readUTF8StringToEndOfFile()
	let	all		=	out3
//	Debug.log(err3)
//	Debug.log(all)
	return	all
}

private extension NSFileHandle {
	func writeUTF8String(s:String) {
		let	d1	=	s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
		self.writeData(d1)
	}
	func readUTF8StringToEndOfFile() -> String {
		let	d1	=	self.readDataToEndOfFile()
		let	s1	=	NSString(data: d1, encoding: NSUTF8StringEncoding)!
		return	s1 as! String
	}
}















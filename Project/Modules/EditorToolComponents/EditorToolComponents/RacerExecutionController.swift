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
	
	public func resolve(file: String, line: Int, column: Int) -> [Match] {
		return	runCompletionWithLocation(line, column, file)
	}
	
}





private typealias	Match	=	RacerExecutionController.Match

extension Match {
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

private func runCompletionWithLocation(lineNumber:Int, charNumber:Int, fileName:String) -> [Match] {
	let	p	=	pathForRacerProgram()
	let	args	=	["complete", lineNumber.description, charNumber.description, fileName]
	let	envs	=	environmentForRacerExecution()
	let	r	=	runExternalProgramSynchronously(p, args, envs)
	return	parseRacerOutput(r)
}
private func runCompletionWithFullyQualifiedName(expression:String) -> [Match] {
	let	p	=	pathForRacerProgram()
	let	args	=	["complete", expression]
	let	envs	=	environmentForRacerExecution()
	let	r	=	runExternalProgramSynchronously(p, args, envs)
	return	parseRacerOutput(r)
}

private func parseRacerOutput(output: String) -> [Match] {
	let	lns	=	output.componentsSeparatedByString("\n").filter({ a in return a != "" })
	let	ms	=	lns.map({ a in Match(expression: a) })
	return	ms
}
private func environmentForRacerExecution() -> [String: String] {
	///	TODO:	Currently, Rust and Racer locations are hard-coded.
	///		This need to be pathced.
	return	[
		"RUST_SRC_PATH"		:	"~/Unix/rustsrc/src".stringByExpandingTildeInPath,
		"DYLD_LIBRARY_PATH"	:	"~/Unix/rust/lib".stringByExpandingTildeInPath,
	]
}

private func pathForRacerProgram() -> String {
	@objc
	final class DummyBundleMarker {
	}

	let	b	=	NSBundle(forClass: DummyBundleMarker.self)
	let	p	=	b.pathForResource("bin/racer", ofType: nil)!
	return	p
}














///	MARK:	-






///	Runs an external program and retusn std-out result.
private func runExternalProgramSynchronously(pathToProgram: String, argumentExpressions: [String], environmentExpressions: [String: String]) -> String {
		
	let	t1		=	NSTask()
	t1.launchPath		=	pathToProgram
	t1.arguments		=	argumentExpressions
	t1.environment		=	environmentExpressions
	
	let	in1		=	NSPipe()
	let	out1		=	NSPipe()
	let	err1		=	NSPipe()
	t1.standardInput	=	in1
	t1.standardError	=	err1
	t1.standardOutput	=	out1
	
	t1.launch()
	t1.waitUntilExit()
	assert(t1.running == false)
	assert(t1.terminationStatus == 0)
	
	let	err3	=	err1.fileHandleForReading.readUTF8StringToEndOfFile()
	let	out3	=	out1.fileHandleForReading.readUTF8StringToEndOfFile()
	let	all	=	out3
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







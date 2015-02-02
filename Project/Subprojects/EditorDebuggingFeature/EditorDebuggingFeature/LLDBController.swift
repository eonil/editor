////
////  LLDBController.swift
////  EditorDebuggingFeature
////
////  Created by Hoon H. on 2015/01/19.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import PrecompilationOfExternalToolSupport
//
//class LLDBController {
//	init() {
//	}
//	
//	func launch(workingDirectoryURL:NSURL) {
//		k.launch(workingDirectoryURL)
//		k.run("____ID_TO_OBJ_MAP = {}")
//		k.run("THE_DBG = None")
//	}
//	func createDebugger() {
//		k.run("THE_DBG = lldb.SBDebugger.Create()")
//		let	idexpr	=	("print(id(THE_DBG))")
//		
//		dbg	=	Debugger(controller: self, IDExpression: idexpr)
//	}
//	func destroyDebugger() {
//		k.run("lldb.SBDebugger.Destory(THE_DBG)")
//		k.run("THE_DBG = None")
//		dbg	=	nil
//	}
//	
//	var	debuffer:Debugger {
//		get {
//			return	dbg!
//		}
//	}
//	
//	////
//	
//	private let	k	=	SynchronousPythonLLDBShellKernelController()
//	private var	dbg	=	nil as Debugger?
//	
//	private func run
//}
//
//class PythonProxyObject {
//	private let	controller:LLDBController
//	private let	idexpr:String
//	
//	init(controller:LLDBController, IDExpression:String) {
//		self.controller	=	controller
//		self.idexpr		=	IDExpression
//	}
//	
//	private var	kernel:SynchronousPythonLLDBShellKernelController {
//		get {
//			return	controller.k
//		}
//	}
//	
//	private func run(command:String) -> String {
//		return	kernel.run(command)
//	}
//}
//
//class Debugger: PythonProxyObject {
//	func createTargetWithFileAndArch(filename:String, archname:Arch) -> Target {
//		run("temp = THE_DBG.CreateTargetWithFileAndArch(\(encodeAsPythonStringLiteralExpression(filename)), \(archname.rawValue))")
//		let	idexpr	=	run("print(id(temp))")
//	}
//	func deleteTarget(target:Target) {
//		
//	}
//}
//
//enum Arch: String {
//	case Default		=	"LLDB_ARCH_DEFAULT"
//	case Default32Bit	=	"LLDB_ARCH_DEFAULT_32BIT"
//	case Default64Bit	=	"LLDB_ARCH_DEFAULT_64BIT"
//}
//
//private func encodeAsPythonStringLiteralExpression(s:String) -> String {
//	let	s1	=	s.stringByReplacingOccurrencesOfString("\"", withString: "\\\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
//	return	"\"\(s1)\""
//}
//
//
//
//
//class Target: PythonProxyObject {
//	
//}
//
//
//
//
//
//
//
//
//
//
//
//
//struct RemotePythonUtility {
//	func run(program:String) -> String {
//		
//	}
//	func call(target:AnyObject?, methodName:String, arguments:[AnyObject?]) -> AnyObject? {
//		let	target1		=	toPythonExpression(target)
//		let	args1		=	arguments.map { (o:AnyObject?)->String in
//			return	self.toPythonExpression(o)
//		}
//		let	args2		=	join(", ", args1)
//		run("____temp = \(target1).\(methodName)(\(args2))")
//		run("if ____temp == None:")
//	}
//	
//	func toSwiftObject(pythonExpression x:String) -> AnyObject? {
//		if x == "None" {
//			return	nil
//		}
//		if
//	}
//	func toPythonExpression(o:AnyObject?) -> String {
//		if o == nil {
//			return	"None"
//		}
//		if let p = o! as? PythonProxyObject {
//			return	"____ID_TO_OBJ_MAP[\(p.idexpr)]"
//		}
//		if let v = o! as? Int {
//			return	v.description
//		}
//		if let v = o! as? String {
//			return	v
//		}
//		fatalError("Unsupported data type.")
//	}
//}
//
//
//
//
//
//
//
//
//
//
/////	Python LLDB Shell Kernel is a small python script that interacts
/////	via stdin/stdout. The kernel Accepts single-line command, and
/////	produces at least single-line result. All input/output are fully 
/////	regularised as lines. (that means all transmissions are separated
/////	by new-line character)
/////
/////	Kernel may return more than one line by type of command. In that 
/////	case, each command need to manage that extra lines.
//class SynchronousPythonLLDBShellKernelController {
//	init() {
//		t.standardInput		=	inPipe
//		t.standardOutput	=	outPipe
//		t.standardError		=	errPipe
//	}
//	
//	func launch(workingDirectoryURL:NSURL) {
//		t.currentDirectoryPath	=	workingDirectoryURL.path!
//		t.launchPath			=	"/bin/bash"			//	TODO:	Need to use `sh` for regularity. But `sh` doesn't work for `cargo`, so temporarily fallback to `bash`.
//		t.arguments				=	["--login", "-s"]
//		t.launch()
//		
//		let	pp		=	"/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/Python"
//		inPipe.fileHandleForWriting.writeUTF8String("export PYTHONPATH=\(pp)\n")
//		
//		let	b		=	NSBundle(forClass: self.dynamicType)
//		let	dbgpy	=	b.pathForResource("kernel", ofType: "py")!
//		
//		inPipe.fileHandleForWriting.writeUTF8String("exec python \(dbgpy)\n")
//		
//	}
//	
//	func run(command:String) -> String {
//		sendLine(command)
//		return	receiveLine()
//	}
//	
//	func sendLine(s:String) {
//		assert(find(s, "\n") == nil)
//		inPipe.fileHandleForWriting.writeUTF8String("\(s)\n")
//	}
//	func receiveLine() -> String {
//		return	outPipe.fileHandleForWriting.readUTF8StringToNewLineCharacter()
//	}
//	
//	private let	t		=	NSTask()
//	private let	inPipe	=	NSPipe()
//	private let	outPipe	=	NSPipe()
//	private let	errPipe	=	NSPipe()
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////protocol PythonLLDBKernelControllerDelegate: class {
////	///	`line` includes ending new-line character.
////	func PythonLLDBKernelControllerDidReadLineFromStandardOutput(line:String)
////	///	`line` includes ending new-line character.
////	func PythonLLDBKernelControllerDidReadLineFromStandardError(line:String)
////	///	`ok` is `false` for any errors.
////	func PythonLLDBKernelControllerDidTerminate(ok:Bool)
////}
////class PythonLLDBKernelController {
////	weak var delegate:PythonLLDBKernelControllerDelegate?
////
////	init() {
////		sh.delegate	=	self
////		
////		err.onLine	=	{ s in
////			println("ERROR: \(s)")
////		}
////		
////		out.onLine	=	{ s in
////			println("OUT: \(s)")
////		}
////	}
////	func launch(workingDirectoryURL:NSURL) {
////		sh.launch(workingDirectoryURL: workingDirectoryURL)
////		
////		let	pp		=	"/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/Python"
////		sh.writeToStandardInput("export PYTHONPATH=\(pp)\n")
////		
////		let	b		=	NSBundle(forClass: self.dynamicType)
////		let	dbgpy	=	b.pathForResource("kernel", ofType: "py")!
////	
////		sh.writeToStandardInput("exec python \(dbgpy)\n")
////		execute("import lldb")
////	}
////	func execute(s:String) {
////		sh.writeToStandardInput("\(s)\n")
////		println(s)
////	}
////	
////	////
////	
////	private let	sh	=	ShellTaskExecutionController()
////	private var	out	=	LineDispatcher()
////	private var	err	=	LineDispatcher()
////}
////
////extension PythonLLDBKernelController: ShellTaskExecutionControllerDelegate {
////	
////	func shellTaskExecutableControllerDidReadFromStandardError(s: String) {
////		err.push(s)
////	}
////	func shellTaskExecutableControllerDidReadFromStandardOutput(s: String) {
////		out.push(s)
////	}
////	func shellTaskExecutableControllerRemoteProcessDidTerminate(#exitCode: Int32, reason: NSTaskTerminationReason) {
////		println("TERM: \(exitCode), \(reason)")
////		abort()
////	}
////}
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
////
//////protocol PythonLLDBKernelControllerDelegate: class {
//////	///	`line` includes ending new-line character.
//////	func PythonLLDBKernelControllerDidReadLineFromStandardOutput(line:String)
//////	///	`line` includes ending new-line character.
//////	func PythonLLDBKernelControllerDidReadLineFromStandardError(line:String)
//////	///	`ok` is `false` for any errors.
//////	func PythonLLDBKernelControllerDidTerminate(ok:Bool)
//////}
//////public class PythonLLDBKernelController {
//////	weak var delegate:PythonLLDBKernelControllerDelegate?
//////
//////	public init() {
//////		sh.delegate	=	self
//////		
//////		err.onLine	=	{ s in
//////			println("ERROR: \(s)")
//////		}
//////		
//////		out.onLine	=	{ s in
//////			println("OUT: \(s)")
//////		}
//////	}
//////	public func launch(workingDirectoryURL:NSURL) {
//////		let	b		=	NSBundle(forClass: MarkerClass.self)
//////		let	dbgpy	=	b.pathForResource("dbg", ofType: "py")!
//////		sh.launch(workingDirectoryURL: workingDirectoryURL, launchPath: "/usr/bin/python", arguments: [dbgpy])
////////		sh.writeToStandardInput("print \"aa\"\n\n\n")
//////	}
//////	
//////	////
//////	
//////	private let	sh	=	TaskExecutionController()
//////	private var	out	=	UTF8StringLineDispatcher()
//////	private var	err	=	UTF8StringLineDispatcher()
//////}
//////
//////extension PythonLLDBKernelController: TaskExecutionControllerDelegate {
//////	public func taskExecutableControllerDidReadFromStandardError(data: NSData) {
//////		err.push(data)
//////	}
//////	public func taskExecutableControllerDidReadFromStandardOutput(data: NSData) {
//////		out.push(data)
//////	}
//////	public func taskExecutableControllerRemoteProcessDidTerminate(#exitCode: Int32, reason: NSTaskTerminationReason) {
//////		println("TERM: \(exitCode), \(reason)")
//////	}
//////}
//////
//////
//////
//////
//////
//////
//////
//////
//////
//////struct UTF8StringLineDispatcher {
//////	var onLine:(line:String)->() {
//////		get {
//////			return	lp.onLine
//////		}
//////		set(v) {
//////			lp.onLine	=	v
//////		}
//////	}
//////	var	sp	=	UTF8StringDispatcher()
//////	var	lp	=	LineDispatcher()
//////	
//////	init() {
//////		sp.onString	=	{ s in
//////			self.lp.push(s)
//////		}
//////	}
//////	func push(data:NSData) {
//////		sp.push(data)
//////	}
//////}
////
////
////

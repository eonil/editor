//
//  ContextTree.swift
//  EditorDebugUI
//
//  Created by Hoon H. on 2015/08/29.
//  Copyright © 2015 Eonil. All rights reserved.
//

import Foundation
import LLDBWrapper

/// A snapshot of an execution context tree state.
///
/// This is designed as a snapshot because debugging states
/// are always a kind of snapshot. (you don't have access to a live mutating data)
///
/// This evaluates all tree nodes eagerly at once. No lazy evaluation.
///
class ContextTree {
	/// Refreshes whole tree from the debbugger state.
	///
	/// This tries to re-use existing object as many as possible
	/// to support pointer based equality behavior of outline-view.
	func reconfigure(data: LLDBDebugger?) {
		let	newDataList	=	data?.allTargets.filter{ $0.process != nil }.map{ $0.process! } ?? []
		self.processes		=	newListWithReusingNodeForSameDataID(processes, newDataList: newDataList, instantiate: _instantiateProcessNode)
	}

	///
	
	private(set) var processes	=	[ProcessNode]()
}

class ContextNode {
	private(set) var icon: NSImage?
	private(set) var text: String?
}

class ProcessNode: ContextNode, DataNode {
	private(set) var	data		:	LLDBProcess?
	private(set) var	threads		=	[ThreadNode]()

	func reconfigure(data: LLDBProcess?) {
		self.data	=	data
		self.threads	=	newListWithReusingNodeForSameDataID(threads, newDataList: data?.allThreads ?? [], instantiate: _instantiateThreadNode)

		self.text	=	"Process: PID=\(data?.processID)"
	}
}

class ThreadNode: ContextNode, DataNode {
	private(set) var	data		:	LLDBThread?
	private(set) var	frames		=	[FrameNode]()

	func reconfigure(data: LLDBThread?) {
		self.data	=	data
		self.frames	=	newListWithReusingNodeForSameDataID(frames, newDataList: data?.allFrames.filter{$0 != nil}.map{$0!} ?? [], instantiate: _instantiateFrameNode)

		self.text	=	"Thread: TID=\(data?.threadID), name=\(data?.name)"
	}
}

class FrameNode: ContextNode, DataNode {
	private(set) var	data		:	LLDBFrame?

	func reconfigure(data: LLDBFrame?) {
		self.data	=	data

		self.text	=	"Frame: FID=\(data?.frameID), function=`\(data?.functionName)`"
	}
}






























private func _instantiateProcessNode() -> ProcessNode {
	return	ProcessNode()
}
private func _instantiateThreadNode() -> ThreadNode {
	return	ThreadNode()
}
private func _instantiateFrameNode() -> FrameNode {
	return	FrameNode()
}








extension LLDBProcess: LocallyIdentifiable {
	func getID() -> LLDBProcessIDType {
		return	self.processID
	}
}
extension LLDBThread: LocallyIdentifiable {
	func getID() -> LLDBThreadIDType {
		return	self.threadID
	}
}
extension LLDBFrame: LocallyIdentifiable {
	func getID() -> UInt32 {
		return	self.frameID
	}
}


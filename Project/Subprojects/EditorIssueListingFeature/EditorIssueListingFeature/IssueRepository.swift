//
//  IssueRepository.swift
//  EditorIssueListingFeature
//
//  Created by Hoon H. on 2015/01/18.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit



typealias	GroupAddingRecord	=	(node:IssueGroupNode, index:Int)
typealias	ItemAddingRecord	=	(node:IssueItemNode, index:Int)

struct IssueAddingRecordList {
	var	groups	=	[] as [GroupAddingRecord]
	var	items	=	[] as [ItemAddingRecord]
}

///	Issues are sorted by insertion time.
final class IssueRepository {
	var numberOfGroupNodes:Int {
		get {
			return	_groups.count
		}
	}
	func groupNodeAtIndex(index:Int) -> IssueGroupNode {
		return	_groups[index]
	}
	func reset() {
		_removeAllGroupingInformations()
		
	}
	///	Returns `(node, index)` tuple. The `index` is index of the item node in its group node.
	///	Pushing is always done in ascending order. So returning index is always incremental.
	func push(issues:[Issue]) -> IssueAddingRecordList {
		var	r	=	IssueAddingRecordList()
		
		let	ms	=	issues.map { [unowned self](s:Issue)->ItemAddingRecord in
			let	c	=	self._groups.count
			let	g	=	self._getGroupForURL(s.origin?.URL, records: &r.groups)
			let	m	=	g.push(s)
			return	m
		}
		r.items	=	ms
		return	r
	}
	func groupNodeForOrigin(u:NSURL) -> IssueGroupNode? {
		let	g	=	_findGroupForOrigin(u)
		return	g
	}
	
	
	
	////
	
	private var	_groups				=	[] as [IssueGroupNode]
	private var	_missing_group		=	IssueGroupNode(origin: nil)			///	A special group for origin-less (missing) issues.
	private var	_origin_mapping		=	[:] as [NSURL:Int]					///	Maps issue origin URL -> issue group index.
	
	private func _removeAllGroupingInformations() {
		_groups.removeAll(keepCapacity: false)
		_origin_mapping.removeAll(keepCapacity: false)
		_missing_group	=	IssueGroupNode(origin: nil)
	}
	private func _getGroupForURL(u:NSURL?, inout records:[GroupAddingRecord]) -> IssueGroupNode {
		if u == nil {
			return	_missing_group
		}
		if let idx = _origin_mapping[u!] {
			let	g	=	_groups[idx]
			return	g
		} else {
			let	g	=	IssueGroupNode(origin: u!)
			let	idx	=	_groups.count
			_groups.append(g)
			_origin_mapping[u!]	=	idx
			records.append(GroupAddingRecord(g, idx))
			return	g
		}
	}
	private func _findGroupForOrigin(u:NSURL?) -> IssueGroupNode? {
		if u == nil {
			return	_missing_group
		}
		if let idx = _origin_mapping[u!] {
			return	_groups[idx]
		}
		return	nil
	}
}






















final class IssueGroupNode {
	init(origin:NSURL?) {
		_origin	=	origin
		_items	=	[]
	}
	
	var origin:NSURL? {
		get {
			return	_origin
		}
	}
	var numberOfItemNodes:Int {
		get {
			return	_items.count
		}
	}
	func itemNodeAtIndex(index:Int) -> IssueItemNode {
		return	_items[index]
	}
	var iconForUI:NSImage {
		get {
			return	_origin == nil ? IconUtility.iconForCodeUsingIconServices(kUnknownFSObjectIcon) : IconUtility.iconForURL(_origin!)
		}
	}
	var textForUI:String {
		get {
			return	_origin == nil ? "(no file)" : _origin!.lastPathComponent!
		}
	}
	
//	func indexOfItemNode(n:IssueItemNode) -> Int? {
//		for i in 0..<_items.count {
//			let	idx	=	_items.count - i - 1
//			let	m	=	_items[idx]
//			if m === n {
//				return	idx
//			}
//			return	nil
//		}
//	}
	func reset() {
		_items.removeAll(keepCapacity: false)
	}
	
	func push(s:Issue) -> (node:IssueItemNode, index:Int) {
		let	m	=	IssueItemNode(groupNode: self, data: s)
		let	idx	=	_items.count
		_items.append(m)
		return	(m, idx)
	}
	
	////
	
	private let	_origin	:	NSURL?
	private var _items	:	[IssueItemNode]
}







final class IssueItemNode {
	init(groupNode:IssueGroupNode, data:Issue) {
		self.groupNode	=	groupNode
		self.data		=	data
	}
	
	let	data:Issue
	let	groupNode:IssueGroupNode
	
	var iconForUI:NSImage {
		get {
			switch data.severity {
			case .Information:
				return	IconUtility.iconForCodeUsingIconServices(kAlertNoteIcon)
				
			case .Warning:
				return	IconUtility.iconForCodeUsingIconServices(kAlertCautionIcon)
				
			case .Error:
				return	IconUtility.iconForCodeUsingIconServices(kAlertStopIcon)
			}
		}
	}
	var textForUI:String {
		get {
			return	data.message
		}
	}
}













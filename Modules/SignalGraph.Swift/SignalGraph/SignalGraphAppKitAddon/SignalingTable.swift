////
////  SignalingTable.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/14.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import SignalGraph
//
//
//
//class SignalingTable {
//	struct Column {
//	}
//	struct Row {
//	}
//	
//	var	columns: EditableArrayStorage<Column> {
//		get {
//			
//		}
//	}
//	var rows: EditableArrayStorage<Row> {
//		get {
//			
//		}
//	}
//	var	rowSelectionEmitter: SignalEmitter<Row> {
//		
//	}
//	var	columnSelectionEmitter: SignalEmitter<Column> {
//		
//	}
//	
//	var	rowClickEmitter: SignalSensor<Row> {
//		
//	}
//	var	rowDoubleClickEmitter: SignalSensor<Row> {
//		
//	}
//	var	columnClickEmitter: SignalSensor<Row> {
//		
//	}
//	
//	private let	tableView		=	NSTableView()
//	private let	tableAgent		=	Agent()
//	
//	private final class Agent: NSObject, NSTableViewDataSource, NSTableViewDelegate {
//		weak var oner			:	SignalingTable?
//		
//		@objc
//		func numberOfRowsInTableView(tableView: NSTableView) -> Int {
//			
//		}
//	}
//}
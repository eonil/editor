////
////  ArraySignal+NSTableView.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/24.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//import AppKit
//import SignalGraph
//
/////	Applies mutations of the signal to a table view.
/////	This will just make the table view to insert/update/delete some rows,
/////	and you still need to proide a proper delegate for the table view.
/////
/////	This reloads all columns in the row.
/////
//public func applyArraySignal<T>(signal: ArraySignal<T>, to tableView: NSTableView) {
//	switch signal {
//	case .Initiation(snapshot: let s):
//		tableView.reloadData()
//		
//	case .Transition(transaction: let s):
//		let	all_column_idxs	=	NSIndexSet(indexesInRange: NSRange(location: 0, length: tableView.tableColumns.count))
//		tableView.beginUpdates()
//		for m in s.mutations {
//			switch (m.past, m.future) {
//			case (_, nil):
//				tableView.insertRowsAtIndexes(NSIndexSet(index: m.identity), withAnimation: NSTableViewAnimationOptions.EffectFade)
//				
//			case (nil, _):
//				tableView.removeRowsAtIndexes(NSIndexSet(index: m.identity), withAnimation: NSTableViewAnimationOptions.EffectFade)
//				
//			case (_, _):
//				tableView.reloadDataForRowIndexes(NSIndexSet(index: m.identity), columnIndexes: all_column_idxs)
//				
//			default:
//				fatalError("Unsupported mutation state representation found in the signal.")
//			}
//		}
//		tableView.endUpdates()
//		
//	case .Termination(snapshot: let s):
//		break
////		tableView.reloadData()
//		
//	}
//}
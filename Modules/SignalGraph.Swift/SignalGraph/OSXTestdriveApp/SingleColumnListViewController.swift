//
//  ListViewController.swift
//  SignalGraph
//
//  Created by Hoon H. on 2015/05/20.
//  Copyright (c) 2015 Eonil. All rights reserved.
//

import Foundation
import AppKit
import SignalGraph


public protocol DataPresentable {
	typealias	Data
	var		data	:	Data? { get set }
}

///	Readonly single-column list display.
///
///	:param:		T
///			Type of array item.
///
///	:param:		V
///			Type of view for column to represent an array item.
///
public class SingleColumnListViewController<T,V: NSView where V: DataPresentable, V.Data == T> {
	public init() {
		agent.count			=	{ [weak self] () in self!.copy?.count ?? 0 }
		agent.reconfigureView		=	{ [weak self] view, row in (view as! V).data = self!.copy![row] }
		agent.instantiateView		=	{ return V() }

		scroll.hasVerticalScroller	=	true
		scroll.documentView		=	table
		
		table.headerView		=	nil
		table.addTableColumn(NSTableColumn())
		table.setDataSource(agent)
		table.setDelegate(agent)
		
		monitor.handler			=	{ [weak self] in self!.processSignal($0) }
	}
	
	public var sensor: SignalSensor<ArraySignal<T>> {
		get {
			return	monitor
		}
	}
	
	public var view: NSView {
		get {
			return	scroll
		}
	}
	
	///	MARK:	-
	
	private let 	scroll	=	NSScrollView()
	private let	table	=	NSTableView()
	private let	agent	=	TableAgent()
	
	private let	monitor	=	SignalMonitor<ArraySignal<T>>()
	private var	copy	:	[T]?
	
	private func processSignal(s: ArraySignal<T>) {
		s.apply(&copy)
		
		switch s {
		case .Initiation(snapshot: let s):
			table.setDataSource(agent)
			table.setDelegate(agent)
			table.reloadData()
			
		case .Transition(transaction: let s):
			let	all_column_idxs	=	NSIndexSet(indexesInRange: NSRange(location: 0, length: table.tableColumns.count))
			table.beginUpdates()
			for m in s.mutations {
				switch (m.past, m.future) {
				case (nil, _):
					table.insertRowsAtIndexes(NSIndexSet(index: m.identity), withAnimation: NSTableViewAnimationOptions.EffectFade)
					
				case (_, nil):
					table.removeRowsAtIndexes(NSIndexSet(index: m.identity), withAnimation: NSTableViewAnimationOptions.EffectFade)
					
				case (_, _):
					table.reloadDataForRowIndexes(NSIndexSet(index: m.identity), columnIndexes: all_column_idxs)
					
				default:
					fatalError("Unsupported mutation state representation found in the signal.")
				}
			}
			table.endUpdates()
			
		case .Termination(snapshot: let s):
			table.setDelegate(nil)
			table.setDataSource(nil)
			table.reloadData()
		}
	}	
}



@objc
private final class TableAgent: NSObject, NSTableViewDataSource, NSTableViewDelegate {
	var	count		:	(()->Int)?
	var	reconfigureView	:	((view: NSView, row: Int) -> ())?
	var	instantiateView	:	(() -> NSView)?
	
	///	MARK:	-
	
	@objc
	private func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return	count!()
	}
	
	@objc
	private func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		func reuseOld() -> NSView? {
			return	tableView.makeViewWithIdentifier(CELL_IDENTIFIER, owner: nil) as? NSView
		}
		
		let	v	=	reuseOld() ?? makeNew()
		reconfigureView!(view: v, row: row)
		return	v
	}
	
	private func makeNew() -> NSView {
		let	v	=	instantiateView!()
		v.identifier	=	CELL_IDENTIFIER
		return	v
	}
}

private let	CELL_IDENTIFIER	=	"CELL"




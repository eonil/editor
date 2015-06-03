//
//  StaticTableViewCells.swift
//  CratesIOViewer
//
//  Created by Hoon H. on 11/23/14.
//
//

import Foundation
import UIKit



public class StaticTableRowWithFunctions: StaticTableRow {
	public var	willSelectFunction		=	{$0} as (StaticTableRow?)->(StaticTableRow?)
	public var	willDeselectFunction	=	{$0} as (StaticTableRow?)->(StaticTableRow?)
	
	public var	didSelectFunction		=	{} as ()->()
	public var	didDeselectFunction		=	{} as ()->()
	
	
	public override func willSelect() -> StaticTableRow? {
		return	willSelectFunction(super.willSelect())
	}
	public override func didSelect() {
		didSelectFunction()
		super.didSelect()
	}
	public override func willDeselect() -> StaticTableRow? {
		return	willDeselectFunction(super.willDeselect())
	}
	public override func didDeselect() {
		didDeselectFunction()
		super.didDeselect()
	}
}

public extension StaticTableSection {
	public func appendRowWithFunctions(label:String) -> StaticTableRowWithFunctions {
		let	c1	=	UITableViewCell()
		c1.textLabel!.text	=	label
		return	appendRowWithFunctions(c1)
	}
	public func appendRowWithFunctions(cell:UITableViewCell) -> StaticTableRowWithFunctions {
		let	r1	=	StaticTableRowWithFunctions(cell: cell)
		appendRow(r1)
		return	r1
	}
}

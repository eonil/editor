//
//  StaticTableViewController.swift
//  CratesIOViewer
//
//  Created by Hoon H. on 11/22/14.
//
//

import Foundation
import UIKit


//private let	UILayoutPriorityRequired			=	1000
//private let	UILayoutPriorityDefaultHigh			=	750
//private let	UILayoutPriorityFittingSizeLevel	=	50
private let	REQUIRED	=	1000	as Float
private let	HIGH		=	750		as Float
private	let	FITTING		=	50		as Float


///	This class is designed for very small amount of cells.
///	Keeps all cells in memory.
public class StaticTableViewController: UITableViewController {
	public typealias	Table	=	StaticTable
	public typealias	Section	=	StaticTableSection
	public typealias	Row		=	StaticTableRow
	
	private var	_table	=	nil as Table?

	deinit {
		if let t = _table {
			unownTable(t)
		}
	}
	
	private func ownTable(targetTable:Table) {
		precondition(table.hostTableViewController == nil, "Supplied table object alread bound to another table view controller.")
		table.hostTableViewController	=	self
		tableView?.tableHeaderView	=	table.header
		tableView?.tableFooterView	=	table.footer
		tableView?.reloadData()
	}
	private func unownTable(targetTable:Table) {
		assert(table.hostTableViewController == self)
		table.hostTableViewController	=	nil
		tableView?.tableHeaderView	=	nil
		tableView?.tableFooterView	=	nil
	}

	///	Table must be always non-nil value.
	public final var table:Table {
		get {
			if _table == nil {
				_table	=	Table()
				ownTable(_table!)
			}
			return	_table!
		}
		set(v) {
			if _table != nil {
				unownTable(_table!)
			}
			_table	=	v
			ownTable(_table!)
		}
//		willSet {
//			assert(table.hostTableViewController == self)
//			table.hostTableViewController	=	nil
//			
//			tableView?.tableHeaderView	=	nil
//			tableView?.tableFooterView	=	nil
//		}
//		didSet {
//			precondition(table.hostTableViewController == nil, "Supplied table object alread bound to another table view controller.")
//			table.hostTableViewController	=	self
//			tableView?.tableHeaderView	=	table.header
//			tableView?.tableFooterView	=	table.footer
//			tableView?.reloadData()
//		}
	}
	
	
	
	public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return	table.sections.count ||| 0
	}
	public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return	table.sections[section].rows.count
	}
	public override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let	sz	=	tableView.bounds.size
		let	sz1	=	CGSize(width: sz.width, height: 0)
		return	table.sections[section].header?.heightAsCellInTableView(tableView) ||| 0
	}
	public override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		let	sz	=	tableView.bounds.size
		let	sz1	=	CGSize(width: sz.width, height: 0)
		return	table.sections[section].footer?.heightAsCellInTableView(tableView) ||| 0
	}
	public override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return	table.sections[section].header
	}
	public override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return	table.sections[section].footer
	}
	
	public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return	table.rowAtIndexPath(indexPath).cell.heightAsCellInTableView(tableView)
	}
	public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return	table.rowAtIndexPath(indexPath).cell
	}
	
	public override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		return	table.rowAtIndexPath(indexPath).willSelect()?.indexPath
	}
	public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		table.rowAtIndexPath(indexPath).didSelect()
	}
	public override func tableView(tableView: UITableView, willDeselectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
		return	table.rowAtIndexPath(indexPath).willDeselect()?.indexPath
	}
	public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		table.rowAtIndexPath(indexPath).didDeselect()
	}
}

private extension UIView {
	func heightForMaximumWidth(width:CGFloat) -> CGFloat {
		assert(width >= 0)
		let		sz1	=	systemLayoutSizeFittingSize(CGSize(width: width, height: 0), withHorizontalFittingPriority: HIGH, verticalFittingPriority: FITTING)
		return	sz1.height
//		let		sz2	=	intrinsicContentSize()
//		return	max(sz1.height, sz2.height)
	}
	func heightAsCellInTableView(tableView:UITableView) -> CGFloat {
		return	heightForMaximumWidth(tableView.bounds.size.width)
	}
}
















///	If you need to modify multiple elements at once, then the best practice is
///	making a new table and replacing whole table with it instead replacing each elements.
public class StaticTable {
	public typealias	Section		=	StaticTableSection
	public typealias	Row			=	StaticTableRow
	
	private var	_sections	=	[] as [Section]
	
	public init() {
	}
	deinit {
		for s in _sections {
			s.table	=	nil
		}
	}

	///	There's no effective way to set the header's size automatically using auto-layout.
	///	You must set its frame manually BEFORE passing it into this property.
	public var	header:UIView? {
		didSet {
			assertView____SHOULD____SupportTranslationOfAutoresizingLayout(header)
//			if let v = header {
//				v.frame		=	CGRect(origin: CGPointZero, size: v.systemLayoutSizeFittingSize(CGSizeZero))
//			}
			hostTableViewController?.tableView?.tableHeaderView	=	header
		}
	}
	///	There's no effective way to set the footer's size automatically using auto-layout.
	///	You must set its frame manually BEFORE passing it into this property.
	public var	footer:UIView? {
		didSet {
			assertView____SHOULD____SupportTranslationOfAutoresizingLayout(footer)
//			if let v = header {
//				v.frame		=	CGRect(origin: CGPointZero, size: v.systemLayoutSizeFittingSize(CGSizeZero))
//			}
			hostTableViewController?.tableView?.tableFooterView	=	footer
		}
	}
	
	public var	sections:[Section] {
		get {
			return	_sections
		}
		set(v) {
			for s in _sections {
				assert(s.table === self, "Old sections must still be bound to this table.")
				s.table	=	nil
			}
			_sections	=	v
			for s in _sections {
				assert(s.table === self, "New sections must not be bound to any section.")
				s.table	=	nil
			}
			reloadSelf()
		}
	}
	
	public func setSections(sections:[Section], animation:UITableViewRowAnimation) {
		if let t = hostTableViewController?.tableView {
			_sections	=	[]
			t.deleteSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: sections.count)), withRowAnimation: animation)
			
			_sections	=	sections
			t.insertSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: sections.count)), withRowAnimation: animation)
		}
	}
	public func insertSection(s:Section, atIndex:Int, animation:UITableViewRowAnimation) {
		precondition(s.table == nil, "Supplied section must not be bound to a table.")
		assert(hostTableViewController?.tableView == nil || _sections.count == hostTableViewController?.tableView?.numberOfSections())
		
		_sections.insert(s, atIndex: atIndex)
		s.table	=	self
		
		hostTableViewController?.tableView?.insertSections(NSIndexSet(intArray: [atIndex]), withRowAnimation: animation)
	}
	public func replaceSectionAtIndex(index:Int, withSection:Section, animation:UITableViewRowAnimation) {
		precondition(withSection.table == nil, "Supplied section must not be bound to a table.")
		assert(sections[index].table === self)
		
		if sections[index] !== withSection {
			let	old				=	sections[index]
			old.table			=	nil
			
			_sections[index]	=	withSection
			withSection.table	=	self
			
			withSection.reloadSelfInTable(animation: animation)
		}
	}
	public func deleteSectionAtIndex(index:Int, animation:UITableViewRowAnimation) {
		assert(sections[index].table === self)
		
		sections[index].table	=	nil
		_sections.removeAtIndex(index)
		hostTableViewController?.tableView?.deleteSections(NSIndexSet(intArray: [index]), withRowAnimation: animation)
	}
	private func reloadSelf() {
		hostTableViewController?.tableView?.reloadData()
	}
	private func reloadSectionsAtIndexes(indexes:[Int], animation:UITableViewRowAnimation) {
		hostTableViewController?.tableView?.reloadSections(NSIndexSet(intArray: indexes), withRowAnimation: animation)
	}
	
	private weak var hostTableViewController:UITableViewController? {
		didSet {
		}
	}
}




public class StaticTableSection {
	public typealias	Table		=	StaticTable
	public typealias	Row			=	StaticTableRow
	
	private var	_rows		=	[] as [Row]
	private var	_header		:	UIView?
	private var	_footer		:	UIView?
	
	public init() {
	}
	deinit {
		for r in _rows {
			r.section	=	nil
		}
	}
	
	///	Height will be resolved using auto-layout. (`systemLayoutSizeFittingSize`)
	public var header:UIView? {
		get {
			return	_header
		}
		set(v) {
			setHeaderWithAnimation(v, animation: UITableViewRowAnimation.None)
		}
	}
	
	///	Height will be resolved using auto-layout. (`systemLayoutSizeFittingSize`)
	public var footer:UIView? {
		get {
			return	_footer
		}
		set(v) {
			setFooterWithAnimation(v, animation: UITableViewRowAnimation.None)
		}
	}
	public var rows:[StaticTableRow] {
		get {
			return	_rows
		}
		set(v) {
			setRows(v, animation: UITableViewRowAnimation.None)
		}
	}
	
	public func setHeaderWithAnimation(v:UIView?, animation:UITableViewRowAnimation) {
		assertView____SHOULD____SupportTranslationOfAutoresizingLayout(v)

		_header	=	v
		if table != nil {
			reloadSelfInTable(animation: animation)
		}
	}
	public func setFooterWithAnimation(v:UIView?, animation:UITableViewRowAnimation) {
		assertView____SHOULD____SupportTranslationOfAutoresizingLayout(v)

		_footer	=	v
		if table != nil {
			reloadSelfInTable(animation: animation)
		}
	}
	public func setRows(rows:[Row], animation:UITableViewRowAnimation) {
		for r in _rows {
			assert(r.section === self, "Old rows must still be bound to this section.")
			r.section	=	nil
		}
		_rows	=	rows
		for r in _rows {
			assert(r.section === nil, "New rows must not be bound to any section.")
			r.section	=	self
		}
		reloadSelfInTable(animation: animation)
	}
	public func insertRow(r:Row, atIndex:Int, animation:UITableViewRowAnimation) {
		precondition(r.section == nil, "Supplied row must not be bound to a section.")
		
		r.section	=	self
		_rows.insert(r, atIndex: atIndex)
		table?.hostTableViewController?.tableView?.insertRowsAtIndexPaths([NSIndexPath(forRow: atIndex, inSection: indexInTable!)], withRowAnimation: animation)
	}
	public func replaceRowAtIndex(index:Int, withRow:Row, animation:UITableViewRowAnimation) {
		precondition(withRow.section == nil, "Supplied row must not be bound to a section.")
		assert(rows[index].section === self)
		
		if rows[index] !== withRow {
			let	old			=	rows[index]
			old.section		=	nil
			
			withRow.section	=	self
			_rows[index]	=	withRow
			
			withRow.reloadSelfInSection(animation: animation)
		}
	}
	public func deleteRowAtIndex(index:Int, animation:UITableViewRowAnimation) {
		assert(rows[index].section === self)
		
		rows[index].section	=	nil
		_rows.removeAtIndex(index)
		
		table?.hostTableViewController?.tableView?.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: indexInTable!)], withRowAnimation: animation)
	}
	public func deleteAllRowsWithAnimation(animation:UITableViewRowAnimation) {
		for r in rows {
			r.section	=	nil
		}
		_rows.removeAll(keepCapacity: false)
		reloadSelfInTable(animation: animation)
	}
	public func reloadSelfWithAnimation(animation:UITableViewRowAnimation) {
		reloadSelfInTable(animation: animation)
	}
	
	private weak var table:Table? {
		didSet {
		}
	}
	private var indexInTable:Int? {
		get {
			if let t = table {
				for i in 0..<t.sections.count {
					if t.sections[i] === self {
						return	i
					}
				}
			}
			return	nil
		}
	}
	private func reloadSelfInTable(#animation:UITableViewRowAnimation) {
		table?.reloadSectionsAtIndexes([indexInTable!], animation: animation)
	}
	private func reloadRowsAtIndexes(indexes:[Int], animation:UITableViewRowAnimation) {
		if let sidx = indexInTable {
			var	idxps	=	[] as [NSIndexPath]
			for idx in indexes {
				idxps.append(NSIndexPath(forRow: idx, inSection: indexInTable!))
			}
			table?.hostTableViewController?.tableView?.reloadRowsAtIndexPaths(idxps, withRowAnimation: animation)
		}
	}
}

public class StaticTableRow {
	public typealias	Table		=	StaticTable
	public typealias	Section		=	StaticTableSection
	
	private var	_cell		:	UITableViewCell
	
	public init(cell:UITableViewCell) {
		_cell	=	cell
	}
	
	public var	cell:UITableViewCell {
		get {
			return	_cell
		}
	}
	
	///	Return another row object if you want to override.
	public func willSelect() -> StaticTableRow? {
		return	self
	}
	public func didSelect() {
	}
	
	///	Return another row object if you want to override.
	public func willDeselect() -> StaticTableRow? {
		return	self
	}
	public func didDeselect() {
	}
	
	public func setCell(cell:UITableViewCell, animation:UITableViewRowAnimation) {
		_cell	=	cell
		reloadSelfInSection(animation: UITableViewRowAnimation.None)
	}
	
	private weak var section:Section? {
		didSet {
		}
	}
	private var indexInSection:Int? {
		get {
			if let s = section {
				for i in 0..<s.rows.count {
					if s.rows[i] === self {
						return	i
					}
				}
			}
			return	nil
		}
	}
	private func reloadSelfInSection(#animation:UITableViewRowAnimation) {
		section?.reloadRowsAtIndexes([indexInSection!], animation: animation)
	}
}




















public extension StaticTable {
	public func rowAtIndexPath(indexPath:NSIndexPath) -> Row {
		return	sections[indexPath.section].rows[indexPath.row]
	}
	
	public func appendSection(section:Section, animation:UITableViewRowAnimation) {
		insertSection(section, atIndex: sections.count, animation: animation)
	}
	public func appendSection(section:Section) {
		insertSection(section, atIndex: sections.count, animation: UITableViewRowAnimation.None)
	}
	
	public func insertSectionAtIndex(index:Int, animation:UITableViewRowAnimation) {
		insertSection(Section(), atIndex: index, animation: animation)
	}
	public func appendSectionWithAnimation(animation:UITableViewRowAnimation) -> Section {
		insertSectionAtIndex(sections.count, animation: animation)
		return	sections.last!
	}
	public func appendSection() -> Section {
		appendSectionWithAnimation(UITableViewRowAnimation.None)
		return	sections.last!
	}
	public func deleteSectionAtIndex(index:Int) {
		deleteSectionAtIndex(index, animation: UITableViewRowAnimation.None)
	}
	public func deleteLastSection() {
		deleteSectionAtIndex(sections.count-1)
	}
}
public extension StaticTableSection {
	public func appendRow(row:Row, animation:UITableViewRowAnimation) {
		insertRow(row, atIndex: rows.count, animation: animation)
	}
	public func appendRow(row:Row) {
		appendRow(row, animation: UITableViewRowAnimation.None)
	}
	
	public func insertRowAtIndex(index:Int, animation:UITableViewRowAnimation) {
		insertRow(Row(cell: UITableViewCell()), atIndex: index, animation: animation)
	}
	public func appendRowWithAnimation(animation:UITableViewRowAnimation) -> Row {
		insertRowAtIndex(rows.count, animation: animation)
		return	rows.last!
	}
	public func appendRow() -> Row {
		appendRowWithAnimation(UITableViewRowAnimation.None)
		return	rows.last!
	}
	public func deleteRowAtIndex(index:Int) {
		deleteRowAtIndex(index, animation: UITableViewRowAnimation.None)
	}
	public func deleteLastRow() {
		deleteRowAtIndex(rows.count-1)
	}
	public func deleteAllRows() {
		deleteAllRowsWithAnimation(UITableViewRowAnimation.None)
	}
}
public extension StaticTableRow {
	public var indexPath:NSIndexPath? {
		get {
			if section == nil { return nil }
			return	NSIndexPath(forRow: indexInSection!, inSection: section!.indexInTable!)
		}
	}
}





















private extension NSIndexSet {
	convenience init(intArray:[Int]) {
		let	s1	=	NSMutableIndexSet()
		for v in intArray {
			s1.addIndex(v)
		}
		self.init(indexSet: s1)
	}
	var intArray:[Int] {
		get {
			var	a1	=	[] as [Int]
			self.enumerateIndexesUsingBlock { (index:Int, _) -> Void in
				a1.append(index)
			}
			return	a1
		}
	}
}






private func assertView____SHOULD____SupportTranslationOfAutoresizingLayout(v:UIView?) {
	assert(v == nil || v!.translatesAutoresizingMaskIntoConstraints() == true, "Layout of table/section header/footer view are controlled by `UITableView`, then it should support translation of autoresizing masks.")
}


























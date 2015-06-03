////
////  ArrayDiffset.swift
////  SignalGraph
////
////  Created by Hoon H. on 2015/05/05.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//
////#if os(iOS)
//	import UIKit
//
//	
//	
//	
//	
//	
//	///	UIKit `UITableView` and `UICollectionView` needs specially
//	///	designed dataset when performing batched CRUD operations.
//	///	This type provides prebuilt algorithm to solve that dataset.
//	struct ArrayDiffsetForUIKit {
//		var	deleteIndexes	:	[Int]	=	[]
//		var	updateIndexes	:	[Int]	=	[]
//		var	insertIndexes	:	[Int]	=	[]
//	}
//	
//	extension ArraySignal {
//		func diffsetForUIKit() -> ArrayDiffsetForUIKit {
//			return	ArrayDiffsetForUIKit()
//		}
//	}
//	
//	extension UITableView {
//		func apply(transaction: ArrayDiffsetForUIKit) {
//			//	TODO:	Not tested. Test this.
//			
//			
//		}
//	}
//	extension UICollectionView {
//		func apply(transactionDiffset: ArrayDiffsetForUIKit, asSection: Int) {
//			//	TODO:	Not tested. Test this.
//			performBatchUpdates({ [weak self] in
//				self?.deleteItemsAtIndexPaths(transactionDiffset.deleteIndexes.map(asIndexPath(asSection)))
//				self?.reloadItemsAtIndexPaths(transactionDiffset.updateIndexes.map(asIndexPath(asSection)))
//				self?.insertItemsAtIndexPaths(transactionDiffset.insertIndexes.map(asIndexPath(asSection)))
//			}) { finished in
//			}
//		}
//	}
//	
//	private func resolveDiffset<T>(t: CollectionTransaction<Array<T>.Index,T>) -> ArrayDiffsetForUIKit {
//		typealias	OP	=	SparseArrayOperation
//		var	sa	=	SparseArray(count: 0)
//		for m in t.mutations {
//			switch (m.past != nil, m.future != nil) {
//			case (false, true):
//				//	Insert.
//				sa.insert(m.index)
//			case (true, true):
//				//	Update.
//				sa.update(m.index)
//			case (true, false):
//				//	Delete.
//				sa.delete(m.index)
//			default:
//				fatalError("Unsupported combination.")
//			}
//		}
//	}
//	
//	private func asIndexPath(section: Int)(item: Int) -> NSIndexPath {
//		return	NSIndexPath(forItem: item, inSection: section)
//	}
//	private func asIndexPath(entry: (section: Int, item: Int)) -> NSIndexPath {
//		return	NSIndexPath(forItem: entry.item, inSection: entry.section)
//	}
//
//	
//
//	enum SparseArrayOperation {
//		case Insert
//		case Update
//		case Delete
//		case Move
//	}
//	private struct SparseArray {
//		typealias	OP	=	SparseArrayOperation
//		
//		var	items	:	[(Int,OP)]
//		
//		init(count: Int) {
//			
//		}
//		func insert(index: Int) {
//			
//		}
//		func delete(index: Int) {
//			
//		}
//		func update(index: Int) {
//			
//		}
//		func move(index: Int) {
//			
//		}
//	}
//
//	
//	
//	
//	
//
//	
////#endif

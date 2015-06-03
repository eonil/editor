////
////  ArrayReportingController.swift
////  Editor
////
////  Created by Hoon H. on 2015/01/12.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
/////	Stores issues.
//final class MutationReportingArrayController<T>: MutableCollectionType {
//	typealias	Index	=	Array<T>.Index
//	
//	var	array:[T] {
//		get {
//			
//		}
//		set(v) {
//			let	r1	=	wholeRange
//			_values	=	v
//			let	r2	=	wholeRange
//			
//			func makeReport() {
//				if r1.endIndex < r2.endIndex {
//					//	Increased.
//					return	[
//						ArrayMutationReport(operation: ArrayMutationOperation.Replace, range: r1),
//						ArrayMutationReport(operation: ArrayMutationOperation.Add, range: r1.endIndex..<r2.endIndex),
//					]
//				} else {
//					//	Decreased.
//					return	[
//						ArrayMutationReport(operation: ArrayMutationOperation.Replace, range: r1.startIndex..<r2.endIndex),
//						ArrayMutationReport(operation: ArrayMutationOperation.Remove, range: r2.endIndex..<r1.endIndex),
//					]
//				}
//			}
//			_reporter.report(makeReport())
//		}
//	}
//	var all:Slice<T> {
//		get {
//			return	_values[wholeRange]
//		}
//	}
//	
//	var count:Int {
//		get {
//			return	_values.count
//		}
//	}
//	
//	var startIndex:Index {
//		get {
//			return	_values.startIndex
//		}
//	}
//	var endIndex:Index {
//		get {
//			return	_values.endIndex
//		}
//	}
//	
//	subscript(index:Index) -> T {
//		get {
//			return	_values[index]
//		}
//		set(v) {
//			_values[index]	=	v
//			
//			let	r	=	ArrayMutationReport(incomings: nil, displacings: index..<index.successor(), outgoings: nil)
//			_reporter.report(r)
//		}
//	}
//	subscript(range:Range<Index>) -> Slice<T> {
//		get {
//			return	_values[range]
//		}
//		set(v) {
//			_values.removeRange(range)
//			_values.splice(v, atIndex: range.startIndex)
//
//let
//			removeRange(range)
//			splice(v, atIndex: range.startIndex)
//		}
//	}
//	
//	func generate() -> Array<T>.Generator {
//		return	_values.generate()
//	}
//	
////	func splice(vs:[T], atIndex index:Int) {
////		_values.splice(vs, atIndex: index)
////		_reporter.reportAdding(index..<index+vs.count)
////		
////	}
//	func splice<S : CollectionType where S.Generator.Element == T, S.Index == Array<T>.Index>(newElements: S, atIndex i: Index) {
//		_values.splice(newElements, atIndex: i)
//		let	dist	=	distance(newElements.startIndex, newElements.endIndex)
//		let	end		=	i.advancedBy(dist)
//		
//		let	r		=	ArrayMutationReport(incomings: i..<end, displacings: nil, outgoings: nil)
//		_reporter.report(r)
//	}
//	func removeRange(range:Range<Int>) {
//		_values.removeRange(range)
//		
//		let	r		=	ArrayMutationReport(incomings: nil, displacings: nil, outgoings: range)
//		_reporter.report(r)
//	}
//	
//	////
//	
//	func registerReportingObserver(o:IssueRepositoryReportingProtocol) {
//		_reporter.add(o)
//	}
//	func unregisterReportingObserver(o:IssueRepositoryReportingProtocol) {
//		_reporter.remove(o)
//	}
//	
//	////
//	
//	private var	_values		=	[] as [T]
//	private let	_reporter	=	ReportingManager<T>()
//	
//	private var wholeRange:Range<Int> {
//		get {
//			return	_values.startIndex..<_values.endIndex
//		}
//	}
//}
//
///////	Notifies changes in a `ReportingArray`.
///////	This notifies only changes while the observer is registered.
///////	Pre-existing values will not be notified.
////protocol ReportingArrayNotificationProtocol: class {
////	func issueRepositoryDidReplacingIssuesAtRange(range:Range<Int>)
////}
//
/////	Reports changes reactively to observer.
/////	Observers will be notified all existing issues when it is being registered/unregistered as addition/removing.
//protocol ArrayMutationReportingProtocol: class {
//	///	This may pass multiple reports at once.
//	///	In this case, ranges are guaranteed not to be overlapped.
//	func arrayReportsMutations(reports:[ArrayMutationReport])
//}
//
//struct ArrayMutationReport {
//	var	operation:ArrayMutationOperation
//	var	range:Range<Int>
//	
//}
//
//enum ArrayMutationOperation {
//	case Add
//	case Replace
//	case Remove
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
//private typealias	Report		=	ArrayMutationReport
//
//private class ReportingManager<T> {
//	typealias	Controller	=	MutationReportingArrayController<T>
//	typealias	Observer	=	ArrayMutationReportingProtocol
//	
//	weak var owner:	Controller!
//	
//	var	observers	=	[] as [Observer]
//	
//	init() {
//	}
//	deinit {
//		let	rs	=	[Report(operation: ArrayMutationOperation.Remove, range: owner.wholeRange)]
//		for o in observers {
//			o.arrayReportsMutations(rs)
//		}
//	}
//	
//	func register(o:Observer) {
//		observers.append(o)
//		let	rs	=	[Report(operation: ArrayMutationOperation.Add, range: owner.wholeRange)]
//		o.arrayReportsMutations(rs)
//	}
//	func unregister(o:Observer) {
//		let	rs	=	[Report(operation: ArrayMutationOperation.Remove, range: owner.wholeRange)]
//		o.arrayReportsMutations(rs)
//		observers	=	observers.filter { o1 in
//			return	o1 !== o
//		}
//	}
//	func report(reports:[Report]) {
//		for o in observers {
//			o.arrayReportsMutations(reports)
//		}
//	}
//}
//
//
//

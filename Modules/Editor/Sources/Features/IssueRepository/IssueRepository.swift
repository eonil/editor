////
////  IssueRepository.swift
////  Editor
////
////  Created by Hoon H. on 2015/01/12.
////  Copyright (c) 2015 Eonil. All rights reserved.
////
//
//import Foundation
//
/////	Stores issues.
//final class IssueRepository {
//	var issues:[Issue] {
//		get {
//			return	_issues
//		}
//	}
//	
//	var wholeRange:Range<Int> {
//		get {
//			return	_issues.startIndex..<_issues.endIndex
//		}
//	}
//	func addIssues(vs:[Issue], at index:Int) {
//		_issues.splice(vs, atIndex: index)
//		_reporter.reportAdding(index..<index+vs.count)
//		
//	}
//	func removeIssues(range:Range<Int>) {
//		_issues.removeRange(range)
//		_reporter.reportRemoving(range)
//	}
//	
//	////
//	
//	func addReportingObserver(o:IssueRepositoryReportingProtocol) {
//		_reporter.add(o)
//	}
//	func removeReportingObserver(o:IssueRepositoryReportingProtocol) {
//		_reporter.remove(o)
//	}
//	
//	////
//	
//	private var	_issues		=	[] as [Issue]
//	private let	_reporter	=	ReportingManager()
//}
//
/////	Notifies changes in issue repository.
/////	This notifies only changes while the observer is registered. 
/////	Pre-existing issues will not be notified.
//protocol IssueRepositoryNotificationProtocol: class {
//	func issueRepositoryDidAddIssuesAtRange(range:Range<Int>)
//	func issueRepositoryDidRemoveIssuesAtRange(range:Range<Int>)
//}
//
/////	Reports issues reactively to observer.
/////	Observers will be notified all existing issues when it is being registered/unregistered as addition/removing.
//protocol IssueRepositoryReportingProtocol: IssueRepositoryNotificationProtocol {
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
//private typealias	ReportObserver	=	IssueRepositoryReportingProtocol
//
//private class ReportingManager {
//	weak var owner:	IssueRepository!
//	
//	var	observers	=	[] as [ReportObserver]
//	
//	init() {
//	}
//	deinit {
//		for o in observers {
//			o.issueRepositoryDidRemoveIssuesAtRange(owner.wholeRange)
//		}
//	}
//	
//	func add(o:ReportObserver) {
//		observers.append(o)
//		o.issueRepositoryDidAddIssuesAtRange(owner.wholeRange)
//	}
//	func remove(o:ReportObserver) {
//		o.issueRepositoryDidRemoveIssuesAtRange(owner.wholeRange)
//		observers	=	observers.filter { o1 in
//			return	o1 !== o
//		}
//	}
//	func reportAdding(range:Range<Int>) {
//		for o in observers {
//			o.issueRepositoryDidAddIssuesAtRange(range)
//		}
//	}
//	func reportRemoving(range:Range<Int>) {
//		for o in observers {
//			o.issueRepositoryDidRemoveIssuesAtRange(range)
//		}
//	}
//}
//
//
//
//
//
//

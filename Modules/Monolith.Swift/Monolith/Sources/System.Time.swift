////
////  System.Time.swift
////  Monolith
////
////  Created by Hoon H. on 10/19/14.
////
////
//
//import Foundation
//
//public extension System {
//	public typealias	Timestamp	=	Standard.RFC3339.Timestamp
//	public struct Timespan {
//		public let	startPoint:Timestamp
//		public let	endPoint:Timestamp
//		
//		public init(startPoint:Timestamp, endPoint:Timestamp) {
//			precondition(startPoint <= endPoint)
//			
//			self.startPoint	=	startPoint
//			self.endPoint	=	endPoint
//		}
//	}
//}
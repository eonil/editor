//
//  ISO8601.swift
//  Monolith
//
//  Created by Hoon H. on 10/18/14.
//
//

import Foundation


//
//
//
//public class Standard {
//	///	A timestamp of a specific time-point.
//	///
//	///	http://www.w3.org/TR/NOTE-datetime
//	public class ISO8601 {
//	}
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
//public extension ISO8601 {
//	
//	///	A ISO8601 timestamp with proper values in all fields.
//	public struct Timestamp {
//		public var	date:Date
//		public var	time:Time
//		public var	zone:Zone
//		
//		public struct Date {
//			public var	year:Int
//			public var	month:Int
//			public var	day:Int
//		}
//		
//		public struct Time {
//			public var	hour:Int
//			public var	minute:Int
//			public var	second:Int
//			public var	subsecond:Int
//		}
//		
//		public struct Zone {
//			public var	sign:Sign			///<	Can be `nil` only when it is set to UTC. (marked with `Z`)
//			public var	hours:Int
//			public var	minutes:Int
//			
//			public enum Sign : String {
//				case	Zero	=	"Z"
//				case	Minus	=	"-"
//				case	Plus	=	"+"
//			}
//			
//		}
//	}
//	
//}

//extension ISO8601.Timestamp : Printable {
////	public init(date:Date, time:Time, zone:Zone) {
////		self.date	=	date
////		self.time	=	time
////		self.zone	=	zone
////	}
//	public init?(maybeDate:Date?, maybeTime:Time?, maybeZone:Zone?) {
//		if maybeDate == nil { return nil }
//		if maybeTime == nil { return nil }
//		if maybeZone == nil { return nil }
//		self.init(date:maybeDate!, time:maybeTime!, zone:maybeZone!)
//	}
//	public init?(expression:String) {
//		let	v1		=	Standard.ISO8601.PartialTimestamp(expression: expression)
//		if let v2 = v1 {
//			let	v3	=	Standard.ISO8601.Timestamp(maybeDate:v2.date, maybeTime:v2.time, maybeZone:v2.zone)
//			if let v4 = v3 {
//				self	=	v4
//			} else {
//				return	nil
//			}
//		} else {
//			return	nil
//		}
//	}
//	public var description:String {
//		get {
//			return	"\(date)T\(time)\(zone)"
//		}
//	}
//}
//
//extension ISO8601.Timestamp.Date : Printable {
////	public init(year:Int, month:Int, day:Int) {
////		self.year	=	year
////		self.month	=	month
////		self.day	=	day
////	}
//	public init?(maybeYear:Int?, maybeMonth:Int?, maybeDay:Int?) {
//		if maybeYear == nil { return nil }
//		if maybeMonth == nil { return nil }
//		if maybeDay == nil { return nil }
//		self.init(year:maybeYear!, month:maybeMonth!, day:maybeDay!)
//	}
//	public var description:String {
//		get {
//			return	"\(year)-\(month)-\(day)"
//		}
//	}
//}
//
//extension ISO8601.Timestamp.Time : Printable {
//	public init?(maybeHour:Int?, maybeMinute:Int?, maybeSecond:Int?, maybeSubsecond:Int?) {
//		if maybeHour == nil { return nil }
//		if maybeMinute == nil { return nil }
//		if maybeSecond == nil { return nil }
//		self.init(hour:maybeHour!, minute:maybeMinute!, second:maybeSecond!, subsecond:maybeSubsecond!)
//	}
//
//	public var description:String {
//		get {
//			return	"\(hour)-\(minute)-\(second).\(subsecond)"
//		}
//	}
//}
//
//extension ISO8601.Timestamp.Zone : Printable {
//	public init?(maybeSign:Sign?, maybeHours:Int?, maybeMinutes:Int?) {
//		if maybeSign == nil { return nil }
//		if maybeHours == nil { return nil }
//		if maybeMinutes == nil { return nil }
//		self.init(sign:maybeSign!, hours:maybeHours!, minutes:maybeMinutes!)
//	}
//	
//	public var description:String {
//		get {
//			return	"\(sign.rawValue)\(hours)-\(minutes)"
//		}
//	}
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
//
//public extension ISO8601 {
//	
//	///	Equal with `Timestamp`, but all fields are nillable.
//	public struct PartialTimestamp {
//		
//		public var	date:Date
//		public var	time:Time
//		public var	zone:Zone
//		
//		public init() {
//			date	=	Date(year: nil, month: nil, day: nil)
//			time	=	Time(hour: nil, minute: nil, second: nil, subsecond: nil)
//			zone	=	Zone(sign: nil, hours: nil, minutes: nil)
//		}
//		public init?(expression:String) {
//			let	v1	=	PartialTimestamp.parse(expression)
//			if let v2 = v1 {
//				self	=	v2
//			} else {
//				return	nil
//			}
//		}
//		
////		public var description:String {
////			get {
////				let	d	=	date == nil ? "" : date.description
////				let	tz	=	zone == nil ? "" : (zone.sign == nil ? "Z" : "\(zone.sign)\(zone.hours):\(zone.minutes)")
////				return	"\()-\()-\()T\()\()\().\()\()"
////			}
////		}
//		
//		private static func parse(expression:String) -> PartialTimestamp? {
//			var	scan			=	Parsing.Scanner(expression: expression)
//			var	v1				=	PartialTimestamp()
//			
//			//	here scanner will handle end of string and
//			//	unexpected characters autoamtically.
//			//	so you don't have to care.
//			
//			v1.date.year		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 4)
//			if scan.trySkippingCharacter(asCharacter: "-") == false { return v1 }
//			v1.date.month		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//			if scan.trySkippingCharacter(asCharacter: "-") == false { return v1 }
//			v1.date.day			=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//			
//			if scan.trySkippingCharacter(asCharacter: "T")
//			{
//				v1.time.hour		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//				scan.trySkippingCharacter(asCharacter: ":")
//				v1.time.minute		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//				scan.trySkippingCharacter(asCharacter: ":")
//				v1.time.second		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//				scan.trySkippingCharacter(asCharacter: ".")
//				v1.time.subsecond	=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: Int.max)
//				
//				if let ch1 = scan.tryScanningSingleCharacter()
//				{
//					let	z		=	ch1 == "Z"
//					let	plus	=	ch1 == "+"
//					let	minus	=	ch1 == "-"
//					
//					if z
//					{
//						v1.zone.sign	=	Zone.Sign.Zero
//					}
//					else
//					{
//						if plus == false || minus == false
//						{
//							return	v1
//						}
//						
//						if plus
//						{
//							v1.zone.sign	=	Zone.Sign.Plus
//						}
//						if minus
//						{
//							v1.zone.sign	=	Zone.Sign.Minus
//						}
//						
//						v1.zone.hours		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//						scan.trySkippingCharacter(asCharacter: ":")
//						v1.zone.minutes		=	scan.tryScanningAnyAvailableNumericExpressionAsInteger(byLength: 2)
//					}
//				}
//			}
//			
//			return	v1
//		}
//		
//
//		public struct Date {
//			public var	year:Int?
//			public var	month:Int?
//			public var	day:Int?
//			
////			public var description:String {
////				get {
////					return	"\(year)-\(month)-\(day)"
////				}
////			}
//		}
//		
//		public struct Time {
//			public var	hour:Int?
//			public var	minute:Int?
//			public var	second:Int?
//			public var	subsecond:Int?
//			
////			public var description:String {
////				get {
////					return	"\(hour)-\(minute)-\(second).\(subsecond)"
////				}
////			}
//		}
//		
//		public struct Zone {
//			public enum Sign {
//				case	Zero
//				case	Minus
//				case	Plus
//			}
//			
//			public var	sign:Sign?			///<	Can be `nil` only when it is set to UTC. (marked with `Z`)
//			public var	hours:Int?
//			public var	minutes:Int?
//			
////			public var description:String {
////				get {
////					func ss() -> String
////					{
////						if let s1 = sign
////						{
////							switch s1
////							{
////							case Sign.Minus:	return	"-"
////							case Sign.Plus:		return	"+"
////							}
////						}
////						else
////						{
////							return	"Z"
////						}
////					}
////					func ts() -> String
////					{
////						if hours == nil		{ return "" }
////						let	s1	=	"\(hours)"
////						
////					}
////					let	s	=	ss()
////					let	t	=	ts()
////					return	"\(ss())\(hour)-\(minute)"
////				}
////			}
//		}
//		
//	}
//	
//}
//
//
//
//

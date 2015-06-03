//
//  RFC3339.Extensions.swift
//  Standards
//
//  Created by Hoon H. on 11/27/14.
//
//

import Foundation

extension RFC3339.Expression: Printable {
	public var	description:String {
		get {
			return	"\(date.description)T\(time.description)"
		}
	}
}
extension RFC3339.Expression.Date: Printable {
	public var	description:String {
		get {
			return	"\(stringifyIntoFourDigits(year)):\(stringifyIntoTwoDigits(month)):\(stringifyIntoTwoDigits(day))"
		}
	}
}
extension RFC3339.Expression.Time: Printable {
	public var	description:String {
		get {
			if fraction == 0 {
				return	"\(stringifyIntoTwoDigits(hour)):\(stringifyIntoTwoDigits(minute)):\(stringifyIntoTwoDigits(second)))"
			}
			return	"\(stringifyIntoTwoDigits(hour)):\(stringifyIntoTwoDigits(minute)):\(stringifyIntoTwoDigits(second)).\(stringifyIntoTwoDigits(fraction))"
		}
	}
}
extension RFC3339.Expression.Time.Zone: Printable {
	public var	description:String {
		get {
			if self == RFC3339.Expression.Time.Zone.UTC {
				return	"Z"
			} else {
				return	"\(stringifyIntoTwoDigits(hours)):\(stringifyIntoTwoDigits(minutes))"
			}
		}
	}
}

private func stringifyIntoTwoDigits(v:Int) -> String {
	precondition(v < 100)
	if v < 10 { return "0\(v.description)" }
	return	v.description
}

private func stringifyIntoFourDigits(v:Int) -> String {
	precondition(v < 10000)
	if v < 10 { return "000\(v.description)" }
	if v < 100 { return "00\(v.description)" }
	if v < 1000 { return "0\(v.description)" }
	return	v.description
}













extension RFC3339.Expression {
	func toCocoaDate() -> NSDate {
		let	c			=	NSDateComponents()
		c.year			=	date.year
		c.month			=	date.month
		c.day			=	date.day
		c.hour			=	time.hour
		c.minute		=	time.minute
		c.second		=	time.second
		c.nanosecond	=	fractionToNanoseconds(time.fraction)
		c.timeZone		=	time.zone.toTimeZone()
		
		let		d		=	NSCalendar.currentCalendar().dateFromComponents(c)!
		return	d
	}
}

extension RFC3339.Expression.Time {
	func toNanoseconds() -> Int64 {
		let	h	=	Int64(hour) * Int64(SECONDS_PER_HOUR) * Int64(NANOSECONDS_PER_SECOND)
		let	m	=	Int64(minute) * Int64(SECONDS_PER_MINUTE) * Int64(NANOSECONDS_PER_SECOND)
		let	s	=	Int64(second) * Int64(NANOSECONDS_PER_SECOND)
		let	f	=	Int64(fractionToNanoseconds(fraction))
		return	h + m + s + f
	}
}
extension RFC3339.Expression.Time.Zone {
	func toTimeZone() -> NSTimeZone {
		precondition(hours >= 0 && minutes >= 0)
		precondition((sign == Sign.Zero && hours == 0 && minutes == 0) || (sign != Sign.Zero))
		
		let	s	=	(hours * SECONDS_PER_HOUR) + (minutes * SECONDS_PER_MINUTE)
		let	s1	=	sign == Sign.Minus ? -s : s
		return	NSTimeZone(forSecondsFromGMT: s)
	}
}

private func fractionToNanoseconds(f:Int) -> Int {
	precondition(f <= NANOSECONDS_PER_SECOND)
	
	var	denominator	=	1
	for i in 0..<10 {
		denominator	*=	10
		
		if f < denominator {
			return	f * (NANOSECONDS_PER_SECOND / denominator)
		}
	}
	
	fatalError("Algorithm bug. Search and destroy them.")
}

private let	SECONDS_PER_HOUR		=	60 * SECONDS_PER_MINUTE
private let	SECONDS_PER_MINUTE		=	60
private let	NANOSECONDS_PER_SECOND	=	1000000000


























///	MARK:

extension RFC3339.Test {
	static func testExtensions() {
		typealias	TS	=	RFC3339.Expression
		
		func tx(c:()->()) {
			c()
		}
		
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: RFC3339.Expression.Time.Zone.Sign.Plus, hours: 8, minutes: 9)))
			assert(a.description == "0001-02-03T04:05:06.7+08:09")
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: RFC3339.Expression.Time.Zone.Sign.Zero, hours: 0, minutes: 0)))
			assert(a.description == "0001-02-03T04:05:06.7Z")
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: RFC3339.Expression.Time.Zone.Sign.Minus, hours: 8, minutes: 9)))
			assert(a.description == "0001-02-03T04:05:06.7-08:09")
		}
	}
}















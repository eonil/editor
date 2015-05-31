//
//  RFC3339.Operators.swift
//  Standards
//
//  Created by Hoon H. on 11/27/14.
//
//

import Foundation

func == (left: RFC3339.Expression, right: RFC3339.Expression) -> Bool {
	return	left.date == right.date && left.time == right.time
}
func != (left: RFC3339.Expression, right: RFC3339.Expression) -> Bool {
	return	(left == right) == false
}

func == (left: RFC3339.Expression.Date, right: RFC3339.Expression.Date) -> Bool {
	return	left.year == right.year && left.month == right.month && left.day == right.day
}
func != (left: RFC3339.Expression.Date, right: RFC3339.Expression.Date) -> Bool {
	return	(left == right) == false
}

func == (left: RFC3339.Expression.Time, right: RFC3339.Expression.Time) -> Bool {
	return	left.hour == right.hour && left.minute == right.minute && left.second == right.second && left.fraction == right.fraction && left.zone == right.zone
}
func != (left: RFC3339.Expression.Time, right: RFC3339.Expression.Time) -> Bool {
	return	(left == right) == false
}

func == (left: RFC3339.Expression.Time.Zone, right: RFC3339.Expression.Time.Zone) -> Bool {
	return	left.sign == right.sign && left.hours == right.hours && left.minutes == right.minutes
}
func != (left: RFC3339.Expression.Time.Zone, right: RFC3339.Expression.Time.Zone) -> Bool {
	return	(left == right) == false
}









extension RFC3339.Test {
	static func testOperators() {
		typealias	TS	=	RFC3339.Expression
		
		func tx(c:()->()) {
			c()
		}
		
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			let	b	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			assert(a == b)
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			let	b	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 000)))
			assert(a != b)
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			let	b	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 000), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			assert(a != b)
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			let	b	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 000, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			assert(a != b)
		}
		tx {
			let	a	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Minus, hours: 8, minutes: 9)))
			let	b	=	TS(date: RFC3339.Expression.Date(year: 1, month: 2, day: 3), time: RFC3339.Expression.Time(hour: 4, minute: 5, second: 6, fraction: 7, zone: RFC3339.Expression.Time.Zone(sign: TS.Time.Zone.Sign.Zero, hours: 8, minutes: 9)))
			assert(a != b)
		}
	}
}






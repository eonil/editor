Text related stuffs
===================














Typical Example
----------------

Here's an example which describes [RFC3339](https://www.ietf.org/rfc/rfc3339.txt) BNF syntax.

	static let	digit				=	chs(Characters.digit)
	static let	zulu				=	chs(Characters.zulu)
	static let	tango				=	chs(Characters.tango)
	
	static let	dateFullYear		=	digit * 4
	static let	dateMonth			=	digit * 2
	static let	dateDay				=	digit * 2
	
	static let	timeHour			=	digit * 2
	static let	timeMinute			=	digit * 2
	static let	timeSecond			=	digit * 2
	static let	timeSecondFraction	=	lit(".") + digit * (1...Int.max)
	static let	timeSecondSign		=	lit("+") | lit("-")
	static let	timeNumericOffset	=	timeSecondSign + timeHour + lit(":") + timeMinute + timeSecondFraction * (0...1)
	static let	timeOffset			=	lit("Z") | timeNumericOffset
	
	static let	partialTime			=	timeHour + lit(":") + timeMinute + lit(":") + timeSecond
	static let	fullDate			=	dateFullYear + lit("-") + dateMonth + lit("-") + dateDay
	static let	fullTime			=	partialTime + timeOffset
	static let	dateTime			=	fullDate + lit("T") + fullTime

	private typealias	C	=	EonilText.Parsing.Rule.Component
	private static let	lit	=	C.literal
	private static let	chs	=	C.pattern
	private static let	sub	=	C.subrule
	private static let	mk	=	C.mark

	////

	private struct Characters {
		static let	digit			=	any(["0", "1", "2", "3", "4", "5", "6" ,"7", "8", "9"])
		static let	zulu			=	any(["Z", "z"])
		static let	tango			=	any(["T", "t"])
		
		private typealias	P		=	CharacterSubset
		private static let	or		=	P.or
		private static let	not		=	P.not
		private static let	any		=	P.any
		private static let	one		=	P.one
	}
	











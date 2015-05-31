//
//  Core.Statement.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation


func ==(left:Core.ColumnTypeCode, right:Core.ColumnTypeCode) -> Bool
{
	return	left.value == right.value
}

extension Core
{
	///	http://www.sqlite.org/c3ref/c_blob.html
	struct
	ColumnTypeCode 
	{
		static let	integer	=	ColumnTypeCode(value: SQLITE_INTEGER)
		static let	float	=	ColumnTypeCode(value: SQLITE_FLOAT)
		static let	blob	=	ColumnTypeCode(value: SQLITE_BLOB)
		static let	null	=	ColumnTypeCode(value: SQLITE_NULL)
		static let	text	=	ColumnTypeCode(value: SQLITE_TEXT)
		
		init(value:Int32)
		{
			self.value	=	value
		}
		private let	value:Int32
	}
	
	
	class Statement
	{
		let	database:Core.Connection
		
		init(database:Core.Connection, pointerToRawCStatementObject:COpaquePointer)
		{
			self.database	=	database
			
			_rawptr	=	pointerToRawCStatementObject
			
			assert(_rawptr != C.NULL)
		}
		
		deinit
		{
			assert(_rawptr == C.NULL)
		}
		
		var null:Bool
		{
			get
			{
				return	_rawptr == C.NULL
			}
		}
		
		func sql() -> String?
		{
			let	s1	=	sqlite3_sql(_rawptr)
			let	s2	=	String.fromCString(s1)
			return	s2
		}
		
		///	Returns continuability or more data availability. You can continue to interate while this returns `true`.
		func step() -> Bool
		{
			assert(_rawptr != C.NULL)
			
			///
			///	http://www.sqlite.org/c3ref/step.html
			///
			///	Only `SQLITE_ROW` and `SQLITE_DONE` are normal status.
			///	`SQLITE_OK` has not role here, and will be treated as an unknown error status.
			///	`SQLITE_BUSY` and `SQLITE_MISUSE` is treated as a programmer error -- a bug.
			let	rc1	=	sqlite3_step(_rawptr)
			Core.log("`sqlite3_step(\(_rawptr))` called.")
			
			switch rc1
			{
				case SQLITE_OK:
					Common.crash()	//	`SQLITE_OK` cannot be returned here. It must be one of `SQLITE_ROW` or `SQLITE_DONE`.
				
				case SQLITE_ROW:
					return	true
				
				case SQLITE_DONE:
					return	false
				
				default:
					database.crashOnErrorWith(resultCode: rc1)
			}
			Common.crash()	//	unreachable code.
		}
		
		func reset()
		{
			assert(_rawptr != C.NULL)
			
			let	r	=	sqlite3_reset(_rawptr)
			database.crashOnErrorWith(resultCode: r)
		}
		
		func finalize()
		{
			assert(_rawptr != C.NULL)
			
			let	r	=	sqlite3_finalize(_rawptr)
			database.crashOnErrorWith(resultCode: r)
			Core.log("`sqlite3_finalize(\(_rawptr))` called")
			Core.LeakDetector.theDetector.unregisterInstance(_rawptr, of: Core.LeakDetector.TargetObjectType.stmt)
			
			_rawptr	=	C.NULL
		}

		
		
		
		
		
		
		
		
		

		func dataCount() -> Int32
		{
			assert(_rawptr != C.NULL)
			
			let	c	=	sqlite3_data_count(_rawptr)
			precondition(c.toIntMax() < Int.max.toIntMax())
			return	c
		}
		
		///	0-based indexing.
		func columnName(index:Int32) -> String
		{
			precondition(index < dataCount())
			let	cs	=	sqlite3_column_name(_rawptr, index)
			
			precondition(cs != nil)
			let	s1	=	String.fromCString(cs)!
			return	s1
		}
		
		///	0-based indexing.
		func columnType(index:Int32) -> ColumnTypeCode
		{
			assert(index < dataCount())
			assert(_rawptr != C.NULL)
			
			return	ColumnTypeCode(value: sqlite3_column_type(_rawptr, Int32(index)))
		}
		
		///	0-based indexing.
		func columnInt64(at index:Int32) -> Int64
		{
			assert(index < dataCount())
			assert(_rawptr != C.NULL)
			assert(columnType(index) == ColumnTypeCode.integer)
//			assert(columnType(index) == ColumnTypeCode.null)

			let	n1	=	sqlite3_column_int64(_rawptr, Int32(index))
			return	Int64(n1)
		}
		
		///	0-based indexing.
		func columnDouble(at index:Int32) -> Double
		{
			assert(index < dataCount())
			assert(_rawptr != C.NULL)
			assert(columnType(index) == ColumnTypeCode.float)
//			assert(columnType(index) == ColumnTypeCode.null)
			
			return	sqlite3_column_double(_rawptr, Int32(index))
		}
		
		///	0-based indexing.
		func columnText(at index:Int32) -> String
		{
			assert(index < dataCount())
			assert(_rawptr != C.NULL)
			assert(columnType(index) == ColumnTypeCode.text)
//			assert(columnType(index) == ColumnTypeCode.null)
			
			///	>	Strings returned by sqlite3_column_text() and sqlite3_column_text16(), 
			///	>	even empty strings, are always zero-terminated. The return value from 
			///	>	sqlite3_column_blob() for a zero-length BLOB is a NULL pointer.
			///
			///	Cited from:
			///	http://www.sqlite.org/capi3ref.html#sqlite3_column_blob
			
			let	bc	=	sqlite3_column_bytes(_rawptr, Int32(index))
			let	cs	=	sqlite3_column_text(_rawptr, Int32(index))
			
			///	According to the manual, returning value can be 0 and NULL.
			///	for empty string. (because it is NULL terminated...)
			///
			///	Then, if length is not zero, created string shouldn't be `nil`. That means 
			///	bad content which means programmer error or data corruption.
			
			let	s1	=	bc == 0 ? "" : String.fromCString(UnsafePointer<CChar>(cs))!
			return	s1
		}
		
		///	0-based indexing.
		func columnBlob(at index:Int32) -> Blob
		{
			assert(index < dataCount())
			assert(_rawptr != C.NULL)
			assert(columnType(index) == ColumnTypeCode.blob)
//			assert(columnType(index) == ColumnTypeCode.null)
			
			let	bc	=	sqlite3_column_bytes(_rawptr, Int32(index))
			let	cs	=	sqlite3_column_blob(_rawptr, Int32(index))
			let	cs2	=	UnsafePointer<Int8>(cs)
			
			precondition(bc.toIntMax() < Int.max.toIntMax())
			return	Blob(address: cs2, length: Int(bc))
		}
		
		
		
		
		
		
		///	1-based indexing.
		func bindInt64(value:Int64, at index:Int32)
		{
//			assert(index <= dataCount())
			assert(_rawptr != C.NULL)
			assert(index >= 1, "The `index` is 1-based, and must be equals or larger then 1.")
			
			let	r	=	sqlite3_bind_int64(_rawptr, Int32(index), Int64(value))
			database.crashOnErrorWith(resultCode: r)
		}
		
		///	1-based indexing.
		func bindDouble(value:Double, at index:Int32)
		{
//			assert(index <= dataCount())
			assert(_rawptr != C.NULL)
			assert(index >= 1, "The `index` is 1-based, and must be equals or larger then 1.")
			
			let	r	=	sqlite3_bind_double(_rawptr, Int32(index), value)
			database.crashOnErrorWith(resultCode: r)
		}
		
		///	1-based indexing.
		func bindText(value:String, at index:Int32)
		{
//			assert(index <= dataCount())
			assert(_rawptr != C.NULL)
			assert(index >= 1, "The `index` is 1-based, and must be equals or larger then 1.")
			
			let	cs	=	value.cStringUsingEncoding(NSUTF8StringEncoding)!			///	Must be encodable into UTF8.
			let	bc	=	value.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
			
			precondition(bc.toIntMax() < Int32.max.toIntMax())
			let	r	=	CoreBridge____sqlite3_bind_text_transient(_rawptr, Int32(index), cs, Int32(bc))
			database.crashOnErrorWith(resultCode: r)
		}
		
		///	1-based indexing.
		func bindBytes(value:Blob, at index:Int32)
		{
//			assert(index <= dataCount())
			assert(_rawptr != C.NULL)
			assert(index >= 1, "The `index` is 1-based, and must be equals or larger then 1.")
			
			let	bs	=	value.address
			let	bc	=	value.length
			
			precondition(bc.toIntMax() < Int32.max.toIntMax())
			let	r	=	CoreBridge____sqlite3_bind_blob_transient(_rawptr, Int32(index), bs, Int32(bc))
			database.crashOnErrorWith(resultCode: r)
		}
		
		///	1-based indexing.
		func bindNull(at index:Int32)
		{
//			assert(index <= dataCount())
			assert(_rawptr != C.NULL)
			assert(index >= 1, "The `index` is 1-based, and must be equals or larger then 1.")
			
			let	r	=	sqlite3_bind_null(_rawptr, Int32(index))
			database.crashOnErrorWith(resultCode: r)
		}
		
		///	Return the index of an SQL parameter given its name. The index value returned is suitable for use as the second parameter to sqlite3_bind(). A zero is returned if no matching parameter is found. The parameter name must be given in UTF-8 even if the original statement was prepared from UTF-16 text using sqlite3_prepare16_v2().
		///	See also: sqlite3_bind(), sqlite3_bind_parameter_count(), and sqlite3_bind_parameter_index().
		///	See also lists of Objects, Constants, and Functions.
		///	http://www.sqlite.org/c3ref/bind_parameter_index.html
		func bindParameterIndex(by name:String) -> Int32
		{
			assert(_rawptr != C.NULL)
			assert(name.startIndex != name.endIndex, "Empty name is not allowed.")
			
			let	i1	=	sqlite3_bind_parameter_index(_rawptr, name.cStringUsingEncoding(NSUTF8StringEncoding)!)
//			if i1 == 0
//			{
//				return	nil
////				Common.crash(message: "Cannot find a parameter for the name `\(name)`.")
//			}
			return	i1
		}
		
		func clearBindings()
		{
			assert(_rawptr != C.NULL)
			
			let	r	=	sqlite3_clear_bindings(_rawptr)
			database.crashOnErrorWith(resultCode: r)
		}
		
		
		
		
		
		
		
		
		
		private typealias	C	=	Common.C
		
		private var	_rawptr:COpaquePointer
	}
}



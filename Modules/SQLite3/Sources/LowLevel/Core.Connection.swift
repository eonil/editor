//
//  Core.Connection.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/15/14.
//
//

import Foundation







func |(left:Core.Connection.OpenFlag, right:Core.Connection.OpenFlag) -> Core.Connection.OpenFlag
{
	return	Core.Connection.OpenFlag(value: left.value | right.value)
}

extension
Core
{
	///	Defined as a `class` because `struct` currently does not support `deinit`.
	///	(Xcode 6.0.1)
	///	If Swift starts to provide `deinit` also in `struct`, it is recommended
	///	to use `struct` instead of `class`.
	class Connection
	{
		typealias	Common	=	Core.Common
		typealias	C		=	Core.Common.C
		
		struct OpenFlag {
			static let	Readonly	=	OpenFlag(value: SQLITE_OPEN_READONLY)
			static let	ReadWrite	=	OpenFlag(value: SQLITE_OPEN_READWRITE)
			static let	Create		=	OpenFlag(value: SQLITE_OPEN_CREATE)
			
			///
			///	You can use any predefined option value `SQLITE_OPEN_~` constants.
			///
			private let	value:Int32
			
			private init(value:Int32) {
				func validate(value:Int32) -> Bool {
					let	opts	=	[
						SQLITE_OPEN_READONLY,
						SQLITE_OPEN_READWRITE,
						SQLITE_OPEN_CREATE,
					]
					
					let		has_any	=	opts.filter({ a in return a & value > 0 }).count > 0
					return	has_any
				}
				assert(validate(value))
				
				self.value	=	value
			}
		}
		
		struct Status {
			struct Code {
				static let	MemoryUsed			=	Code(value: SQLITE_STATUS_MEMORY_USED)
				static let	PagecacheUsed		=	Code(value: SQLITE_STATUS_PAGECACHE_USED)
				static let	PagecacheOverflow	=	Code(value: SQLITE_STATUS_PAGECACHE_OVERFLOW)
				static let	ScratchUsed			=	Code(value: SQLITE_STATUS_SCRATCH_USED)
				static let	ScratchOverflow		=	Code(value: SQLITE_STATUS_SCRATCH_OVERFLOW)
				static let	MallocSize			=	Code(value: SQLITE_STATUS_MALLOC_SIZE)
				static let	ParserStack			=	Code(value: SQLITE_STATUS_PARSER_STACK)
				static let	PagecacheSize		=	Code(value: SQLITE_STATUS_PAGECACHE_SIZE)
				static let	ScratchSize			=	Code(value: SQLITE_STATUS_SCRATCH_SIZE)
				static let	MallocCount			=	Code(value: SQLITE_STATUS_MALLOC_COUNT)
				
				private let	value:Int32
			}
		}
		
		
		
		
		
		///	Queries whether this is pointing something or nothing.
		var null:Bool
		{
			get
			{
				return	_rawptr == C.NULL
			}
		}
		
		var currentErrorMessage:String
		{
			get
			{
				assert(_rawptr != C.NULL)
				
				let	cs1	=	sqlite3_errmsg(_rawptr)
				let	s2	=	String.fromCString(cs1)!
				return	s2
			}
		}
		var autocommit:Bool
		{
			get
			{
				assert(_rawptr != C.NULL)
				
				return	sqlite3_get_autocommit(_rawptr) != 0
			}
		}
		
		
		
		
		init()
		{
		}
		deinit
		{
			assert(_rawptr == C.NULL)
		}
		
		
		
		func crashOnErrorWith(resultCode code:Int32)
		{
			if code == SQLITE_OK
			{
				///	OK status must be processed first to prevent
				///	querying on closed connection to database object.
				///	This function can be called even on closed 
				///	database object.
				return
			}
			else
			{
				let	errmsg	=	currentErrorMessage
				Core.log("[ERROR] \(errmsg)")
				assert(code == sqlite3_errcode(_rawptr))
				Common.crash(message: errmsg)
			}
			
		}
		
		///	If `reset` is `true`, then the peak value will be reset after return.
		func status(op:Status.Code, resetPeak reset:Bool = false) -> (current:Int32, peak:Int32)
		{
			var	c	=	0 as Int32
			var	p	=	0 as Int32
			
			let	r	=	sqlite3_status(op.value, &c, &p, C.TRUE)
			crashOnErrorWith(resultCode: r)
			
			return	(c, p)
		}
		
		func open(filename:String, flags:OpenFlag)
		{
			precondition(_rawptr == C.NULL)
			
			let	name2	=	filename.cStringUsingEncoding(NSUTF8StringEncoding)!
			
			let	r		=	sqlite3_open_v2(name2, &_rawptr, flags.value, nil)
			crashOnErrorWith(resultCode: r)
			Core.LeakDetector.theDetector.registerInstance(_rawptr, of: Core.LeakDetector.TargetObjectType.db)
		}
		
		func close() {
			precondition(_callback == nil)
			precondition(_rawptr != C.NULL)
			
			//	This can return `SQLITE_BUSY` for some cases,
			//	but it also will be treated as a programmer
			//	error -- a bug, and crashes the execution.
			let	r	=	sqlite3_close(_rawptr)
			crashOnErrorWith(resultCode: r)
			Core.LeakDetector.theDetector.unregisterInstance(_rawptr, of: Core.LeakDetector.TargetObjectType.db)
			_rawptr	=	C.NULL
		}
		
		///	:routingTable:	`Core.Connection` retains this object until unset.
		func setAuthorizer(routingTable:AuthorisationRoutingTable?) {
			if let rt2 = routingTable {
				precondition(_callback == nil)
				_callback	=	CallbackProxy(routingTable: rt2)
				let	r	=	CallbackProxy.installAuthorisationCallbackProxy(_callback, forSQLite3Database: _rawptr)
				crashOnErrorWith(resultCode: r)
			} else {
				precondition(_callback != nil)
				_callback	=	nil
				let	r	=	CallbackProxy.uninstallAuthorisationCallbackProxyForSQLite3Database(_rawptr)
				crashOnErrorWith(resultCode: r)
			}
		}
		
		///	Returns `nil` for `tail` if the SQL fully consumed.
		func prepare(SQL:String) -> (statements:[Core.Statement], tail:String)
		{
			assert(_rawptr != C.NULL)
			
			///	This does not use input zSql after it has been used.
			func once(zSql:UnsafePointer<Int8>, len:Int32, inout zTail:UnsafePointer<Int8>) -> Core.Statement?
			{
				Core.log("SQL command = \(String.fromCString(zSql)!)")
				
				var	pStmt	=	C.NULL
				let	r		=	sqlite3_prepare_v2(self._rawptr, zSql, len, &pStmt, &zTail)
				self.crashOnErrorWith(resultCode: r)
				Core.log("`sqlite3_prepare_v2(\(self._rawptr), \(zSql), \(len), &\(pStmt), &\(zTail))` called, SQL = \(SQL)")
				
				if pStmt == C.NULL
				{
					return	nil
				}
				Core.LeakDetector.theDetector.registerInstance(pStmt, of: Core.LeakDetector.TargetObjectType.stmt)
				return	Core.Statement(database: self, pointerToRawCStatementObject: pStmt)
			}
			
			var	stmts:[Core.Statement]	=	[]
			
			///	Don't know why, but `String` class doesn't seem to keep memory for
			///	C-string representation over function borders, and it becomes freed
			///	and shows corrupted memory. Maybe it's because it's value-semantic.
			///	Anyway still, the behavior is inunderstandable, and I have to rely
			///	on `NSString` for stability to avoid this buggy(?) behavior.
			///	Or it should be my fault...
			let	sql2	=	SQL as NSString
			var	zSql	=	UnsafePointer<Int8>(sql2.UTF8String)
			
			///	`zTail` is NULL if the SQL string fully consumed. otheriwse, there's some content and `fromCString` shouldn't be nil.
			var	zTail	=	nil as UnsafePointer<Int8>
			
			var	len1	=	sql2.lengthOfBytesUsingEncoding(NSUTF8StringEncoding);
			
			///	If the caller knows that the supplied string is nul-terminated,
			///	then there is a small performance advantage to be gained by passing
			///	an nByte parameter that is equal to the number of bytes in the input
			///	string including the nul-terminator bytes as this saves SQLite from
			///	having to make a copy of the input string.
			precondition(len1.toIntMax() < Int32.max.toIntMax())
			var	maxlen2	=	Int32(len1)+1
			
			while let one = once(zSql, maxlen2, &zTail)
			{
				stmts.append(one)
				zSql	=	zTail
			}
			
			let	rest1	=	String.fromCString(zTail)
			let	rest2	=	rest1 == nil ? "" : rest1!
			
			return	(stmts, rest2)
		}
		
		
		
		
		
		
		
		
		private var	_rawptr		=	nil as COpaquePointer
		private var	_callback	=	nil as CallbackProxy?
	}
}



























///	MARK:

extension Core.Connection {
	
//	struct ActionCode {
//		static let	AlterTable	=	ActionCode(SQLITE_ALTER_TABLE)
//		static let	DropTable	=	ActionCode(SQLITE_DROP_TABLE)
//		
//		private let	number:Int32
//		
//		private init(_ number:Int32) {
//			self.number	=	number
//		}
//	}
	
	struct AuthorisationRoutingTable {
		typealias	Authorise	=	(databaseName:String, tableName:String)->Bool
		
		let	alterTable:Authorise
		let	dropTable:Authorise
	}
	
}








private final class CallbackProxy: Eonil____SQLite3____Bridge____CallbackProxy {
	let	routingTable:Core.Connection.AuthorisationRoutingTable
	init(routingTable:Core.Connection.AuthorisationRoutingTable) {
		self.routingTable	=	routingTable
	}
	private override func authoriseActionCode(actionCode: Int32, _ argA: UnsafePointer<Int8>, _ argB: UnsafePointer<Int8>, _ argC: UnsafePointer<Int8>, _ argD: UnsafePointer<Int8>) -> Int32 {
		func resolve() -> Core.Connection.AuthorisationRoutingTable.Authorise {
			switch actionCode {
			case SQLITE_ALTER_TABLE:	return	self.routingTable.alterTable
			case SQLITE_DROP_TABLE:		return	self.routingTable.dropTable
			default:					return	{ (_, _) in return true }
			}
		}
		func stringify(source:UnsafePointer<Int8>) -> String {
			let	s1	=	String.fromCString(source)
			return	s1	== nil ? "" : s1!
		}
		func codify(flag:Bool)->Int32 {
			return	flag ? SQLITE_OK : SQLITE_DENY
		}
		
		return	resolve()(databaseName: argA >>>> stringify, tableName: argB >>>> stringify) >>>> codify
	}
}

















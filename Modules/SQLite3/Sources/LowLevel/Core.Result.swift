//
//  Core.Status.swift
//  EonilSQLite3
//
//  Created by Hoon H. on 9/16/14.
//
//

import Foundation

extension Core
{
//	struct ResultCode
//	{
//		let	value:Int32
//		
//		static let	OK			=	ResultCode(value: SQLITE_OK)
//		static let	Error		=	ResultCode(value: SQLITE_ERROR)
//		static let	Internal	=	ResultCode(value: SQLITE_INTERNAL)
//		static let	Permission	=	ResultCode(value: SQLITE_PERM)
//		static let	Abort		=	ResultCode(value: SQLITE_ABORT)
//		static let	Busy		=	ResultCode(value: SQLITE_BUSY)
//		static let	Locked		=	ResultCode(value: SQLITE_LOCKED)
//		static let	NoMemory	=	ResultCode(value: SQLITE_NOMEM)
//		static let	Readonly	=	ResultCode(value: SQLITE_READONLY)
//		static let	Interrupt	=	ResultCode(value: SQLITE_INTERRUPT)
//		static let	IOError		=	ResultCode(value: SQLITE_IOERR)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//		static let	Corrupt		=	ResultCode(value: SQLITE_CORRUPT)
//	}
	
//	#define SQLITE_OK           0   /* Successful result */
//	/* beginning-of-error-codes */
//	#define SQLITE_ERROR        1   /* SQL error or missing database */
//	#define SQLITE_INTERNAL     2   /* Internal logic error in SQLite */
//	#define SQLITE_PERM         3   /* Access permission denied */
//	#define SQLITE_ABORT        4   /* Callback routine requested an abort */
//	#define SQLITE_BUSY         5   /* The database file is locked */
//	#define SQLITE_LOCKED       6   /* A table in the database is locked */
//	#define SQLITE_NOMEM        7   /* A malloc() failed */
//	#define SQLITE_READONLY     8   /* Attempt to write a readonly database */
//	#define SQLITE_INTERRUPT    9   /* Operation terminated by sqlite3_interrupt()*/
//	#define SQLITE_IOERR       10   /* Some kind of disk I/O error occurred */
//	#define SQLITE_CORRUPT     11   /* The database disk image is malformed */
//	#define SQLITE_NOTFOUND    12   /* Unknown opcode in sqlite3_file_control() */
//	#define SQLITE_FULL        13   /* Insertion failed because database is full */
//	#define SQLITE_CANTOPEN    14   /* Unable to open the database file */
//	#define SQLITE_PROTOCOL    15   /* Connection lock protocol error */
//	#define SQLITE_EMPTY       16   /* Connection is empty */
//	#define SQLITE_SCHEMA      17   /* The database schema changed */
//	#define SQLITE_TOOBIG      18   /* String or BLOB exceeds size limit */
//	#define SQLITE_CONSTRAINT  19   /* Abort due to constraint violation */
//	#define SQLITE_MISMATCH    20   /* Data type mismatch */
//	#define SQLITE_MISUSE      21   /* Library used incorrectly */
//	#define SQLITE_NOLFS       22   /* Uses OS features not supported on host */
//	#define SQLITE_AUTH        23   /* Authorization denied */
//	#define SQLITE_FORMAT      24   /* Auxiliary database format error */
//	#define SQLITE_RANGE       25   /* 2nd parameter to sqlite3_bind out of range */
//	#define SQLITE_NOTADB      26   /* File opened that is not a database file */
//	#define SQLITE_ROW         100  /* sqlite3_step() has another row ready */
//	#define SQLITE_DONE        101  /* sqlite3_step() has finished executing */
//	/* end-of-error-codes */
//	
//	/*
//	** CAPI3REF: Extended Result Codes
//	** KEYWORDS: {extended error code} {extended error codes}
//	** KEYWORDS: {extended result code} {extended result codes}
//	**
//	** In its default configuration, SQLite API routines return one of 26 integer
//	** [SQLITE_OK | result codes].  However, experience has shown that many of
//	** these result codes are too coarse-grained.  They do not provide as
//	** much information about problems as programmers might like.  In an effort to
//	** address this, newer versions of SQLite (version 3.3.8 and later) include
//	** support for additional result codes that provide more detailed information
//	** about errors. The extended result codes are enabled or disabled
//	** on a per database connection basis using the
//	** [sqlite3_extended_result_codes()] API.
//	**
//	** Some of the available extended result codes are listed here.
//	** One may expect the number of extended result codes will be expand
//	** over time.  Software that uses extended result codes should expect
//	** to see new result codes in future releases of SQLite.
//	**
//	** The SQLITE_OK result code will never be extended.  It will always
//	** be exactly zero.
//	*/
//	#define SQLITE_IOERR_READ              (SQLITE_IOERR | (1<<8))
//	#define SQLITE_IOERR_SHORT_READ        (SQLITE_IOERR | (2<<8))
//	#define SQLITE_IOERR_WRITE             (SQLITE_IOERR | (3<<8))
//	#define SQLITE_IOERR_FSYNC             (SQLITE_IOERR | (4<<8))
//	#define SQLITE_IOERR_DIR_FSYNC         (SQLITE_IOERR | (5<<8))
//	#define SQLITE_IOERR_TRUNCATE          (SQLITE_IOERR | (6<<8))
//	#define SQLITE_IOERR_FSTAT             (SQLITE_IOERR | (7<<8))
//	#define SQLITE_IOERR_UNLOCK            (SQLITE_IOERR | (8<<8))
//	#define SQLITE_IOERR_RDLOCK            (SQLITE_IOERR | (9<<8))
//	#define SQLITE_IOERR_DELETE            (SQLITE_IOERR | (10<<8))
//	#define SQLITE_IOERR_BLOCKED           (SQLITE_IOERR | (11<<8))
//	#define SQLITE_IOERR_NOMEM             (SQLITE_IOERR | (12<<8))
//	#define SQLITE_IOERR_ACCESS            (SQLITE_IOERR | (13<<8))
//	#define SQLITE_IOERR_CHECKRESERVEDLOCK (SQLITE_IOERR | (14<<8))
//	#define SQLITE_IOERR_LOCK              (SQLITE_IOERR | (15<<8))
//	#define SQLITE_IOERR_CLOSE             (SQLITE_IOERR | (16<<8))
//	#define SQLITE_IOERR_DIR_CLOSE         (SQLITE_IOERR | (17<<8))
//	#define SQLITE_IOERR_SHMOPEN           (SQLITE_IOERR | (18<<8))
//	#define SQLITE_IOERR_SHMSIZE           (SQLITE_IOERR | (19<<8))
//	#define SQLITE_IOERR_SHMLOCK           (SQLITE_IOERR | (20<<8))
//	#define SQLITE_IOERR_SHMMAP            (SQLITE_IOERR | (21<<8))
//	#define SQLITE_IOERR_SEEK              (SQLITE_IOERR | (22<<8))
//	#define SQLITE_LOCKED_SHAREDCACHE      (SQLITE_LOCKED |  (1<<8))
//	#define SQLITE_BUSY_RECOVERY           (SQLITE_BUSY   |  (1<<8))
//	#define SQLITE_CANTOPEN_NOTEMPDIR      (SQLITE_CANTOPEN | (1<<8))
//	#define SQLITE_CANTOPEN_ISDIR          (SQLITE_CANTOPEN | (2<<8))
//	#define SQLITE_CORRUPT_VTAB            (SQLITE_CORRUPT | (1<<8))
//	#define SQLITE_READONLY_RECOVERY       (SQLITE_READONLY | (1<<8))
//	#define SQLITE_READONLY_CANTLOCK       (SQLITE_READONLY | (2<<8))
//	#define SQLITE_ABORT_ROLLBACK          (SQLITE_ABORT | (2<<8))
}

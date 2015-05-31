EonilSQLite3
============
Hoon H.






This provides SQLite3 database access on Swift.

-	Access table like a huge dictionary. You can iterate rows using
	tuples or dictionaries.

-	No need to write query at all.

-	Automatically supports nested transactions.

-	Forces safety statically and dynamically. Does not allow you 
	to do funny stuffs. Crashes relably on any illegal operations. 
	There're many debug mode assertions to prevent to make any 
	programmer errors as much as possible.



Requirements
------------
-	Xcode 6.3 beta 3, Build 6D543q (Swift 1.2)
-	iOS 8.0 or later or OS X 10.10 or later to run.

Basically target iOS 8 due to dynamic library packaging limitation.
I dropped iOS 7.x support. I don't think it's truly meaningful here.



Getting Started
---------------
Embed the project as a subproject of your project, and link iOS dynamic
framewor target. 









How to Use
----------
Schematic illustration.

````Swift

	///	Create new mutable database in memory.
	let	db1	=	Database(location: Connection.Location.Memory, editable: true)
	func tx1() {
		///	Create a new table.
		db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
		
		///	Make a single table accessor object.
		let	t1	=	db1.tables["T1"]
		
		///	Insert a new row.
		t1[111]	=	[42, "Here be dragons.", nil]
		
		///	Verify by selecting all current rows.
		let	rs1	=	collect(t1)

		XCTAssert(rs1.count == 1)
		XCTAssert(rs1[0]["v1"]!.integer! == 42)
		XCTAssert(rs1[0]["v2"]!.text! == "Here be dragons.")
		
		///	Update the row.
		t1[111]	=	[108, "Crouching tiger.", nil]
		
		///	Verify!
		let	rs2	=	collect(t1)
		XCTAssert(rs2.count == 1)
		XCTAssert(rs2[0]["v2"]!.text! == "Crouching tiger.")
		
		///	Delete the row.
		t1[111]	=	nil
		
		///	Verify!
		let	rs3	=	collect(t1)
		XCTAssert(rs3.count == 0)
	}
	
	///	Perform a transaction with multiple commands.
	db1.apply(tx1)

````

You need to perform all operations always in an explicit transaction. It's 
not allowed to run operations without transaction. This is by design.

Nested transactions are also supported. It uses implicitly generated savepoint name.

````Swift

	let	db1	=	Database(location: Connection.Location.Memory, editable: true)
	
	///	Out-most transaction.
	func tx1() {
		db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
		let	t1	=	db1.tables["T1"]
		
		///	Outer transaction.
		func tx2() -> Bool {
			///	Insert a new row.
			t1[111]	=	[42, "Here be dragons.", nil]
			
			///	Inner transaction.
			func tx3() -> Bool {
				///	Update the row.
				t1[111]	=	[108, "Crouching tiger.", nil]
				
				///	Verify the update.
				let	rs2	=	collect(t1)
				XCTAssert(rs2.count == 1)
				XCTAssert(rs2[0]["v2"]!.text! == "Crouching tiger.")
				
				///	And rollback.
				return	false
			}
			db1.applyConditionally(tx3)
			
			///	Verify inner rollback.
			let	rs2	=	collect(t1)
			XCTAssert(rs2.count == 1)
			XCTAssert(rs2[0]["v1"]!.integer! == 42)
			XCTAssert(rs2[0]["v2"]!.text! == "Here be dragons.")
			
			return	false
		}
		
		///	Verify outer rollback.
		let	rs2	=	collect(t1)
		XCTAssert(rs2.count == 0)
	}
	db1.apply(tx1)

````




Executing custom SQL is not supported.

But if you really want it, you can do it by using mid-level classses.
This requires re-opening of the database not to break abstraction.
You can do `JOIN` or other stuffs with this, but this is not recommended.
Honestly, if you can't find usefulness from the simple high-level classes,
then it would be better to look for another library.



````Swift

	let	conn1	=	Connection(location: Connection.Location.Memory, editable: true)
	conn1.allArraysByExecuting("CREATE TABLE T1 (k1 INTEGER PRIMARY KEY, v1, v2, v3);")
	conn1.allArraysByExecuting("INSERT INTO T1 (k1, v1, v2, v3) VALUES (111, 42, 'Here be dragons.', NULL);")
	
	for (_, row) in enumerate(conn1.allArraysByExecuting("SELECT * FROM T1")) {
		XCTAssert(row[0] == 111)
		XCTAssert(row[1] == 42)
		XCTAssert(row[2] == "Here be dragons.")
		XCTAssert(row[3] == nil)
	}

````












Author
------
This library is written by Hoon H..



License
-------
This library is licensed under MIT License.

















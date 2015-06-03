//
//  HighLevelFeatureTests.swift
//  EonilSQLite3 - OSX - Tests
//
//  Created by Hoon H. on 11/3/14.
//
//

import Foundation
import XCTest
import EonilSQLite3





extension HighLevelFeatureTests {
	func collect(var t:Table) -> [[String:Value]] {
		var	g1	=	t.dictionaryView.generate()
		var	a1	=	[] as [[String:Value]]
		
		while let e = g1.next() {
			a1.append(e)
		}
		return	a1
	}
	func collect(var p:Page) -> [[String:Value]] {
		let	v1	=	p.dictionaryView
		var	g1	=	v1.generate()
		var	a1	=	[] as [[String:Value]]
		
		while let e = g1.next() {
			a1.append(e)
		}
		return	a1
	}
}


class HighLevelFeatureTests: XCTestCase {
	
	
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	
	
	func testBasicsFeaturesWithTransaction() {
		
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
	}
	
	
	func testBasicFeaturesWithNestedTransactions() {
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
	}
	
	func testQueryingNonExistingRow() {
		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
		func tx1() {
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
			let	t1	=	db1.tables["T1"]
			
			///	Insert a new row.
			t1[111]	=	[42, "Here be dragons.", nil]
			
			let	r1	=	t1[222]
			XCTAssert(r1 == nil)
		}
		db1.apply(tx1)
	}
	
	func testManyRows1() {
		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
		func tx1() {
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
			let	t1	=	db1.tables["T1"]
			
			for i in 0..<64 {
				t1[10000 + i]	=	[42, "Here be dragons.", nil]
			}
			
			XCTAssert(t1.count == 64)
		}
		db1.apply(tx1)
	}
	
	func testPaging1() {
		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
		func tx1() {
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
			let	t1	=	db1.tables["T1"]
			
			for i in 0..<64 {
				t1[0 + i]	=	[42, "Here be dragons.", nil]
			}
			
			let	n1	=	Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.EqualOrGreaterThan, column: Query.Identifier("k1"), value: {30})
			let	f1	=	Query.FilterTree(root: n1)
			
			let	s1	=	t1.filter(f1)
			let	l1	=	s1.sort(Query.SortingList(items: [Query.SortingList.Item(column: Query.Identifier("k1"), order: Query.SortingList.Order.Ascending)]))
			let	p1	=	l1[10..<20]
			
			let	rs1	=	collect(p1)
			let	c1	=	rs1.count
			
			XCTAssert(rs1.count == 10)
			XCTAssert(rs1[0]["k1"]!.integer! == 40)
			XCTAssert(rs1[1]["k1"]!.integer! == 41)
			XCTAssert(rs1[2]["k1"]!.integer! == 42)
			XCTAssert(rs1[9]["k1"]!.integer! == 49)
		}
		db1.apply(tx1)
	}
	
	
	
	func testTempFileMaking() {
		let	db1	=	Database(location: Connection.Location.TemporaryFile, editable: true)
	}
	
	func testPersistentFileMaking() {
		let	p1	=	NSTemporaryDirectory()!
		let	p2	=	p1.stringByAppendingPathComponent(NSUUID().UUIDString + ".test")
		let	db1	=	Database(location: Connection.Location.PersistentFile(path: p2), editable: true)
		
	}
	
	func testPersistentFileMakingInCacheDir() {
		let	p1	=	NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
		let	p2	=	p1.stringByAppendingPathComponent("EonilSQLite3-Test" + NSUUID().UUIDString + ".test")
		let	db1	=	Database(location: Connection.Location.PersistentFile(path: p2), editable: true)
		db1.apply {
			db1.schema.create(tableName: "T1", dataColumnNames: ["c1"])
		}
	}
	
	
//	
//	///	This must fail.
//	func testInsertWithMissingFields1() {
//		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
//		func tx1() {
//			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2"])
//			let	t1	=	db1.tables["T1"]
//			
//			t1[111]	=	["Here be dragons."]
//		}
//		db1.apply(tx1)
//	}
	
	
	
	func testInsertWithMissingFields2() {
		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
		func tx1() {
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2"])
			let	t1	=	db1.tables["T1"]
			let	ds1	=	t1.dictionaryView
			ds1[111]	=	[:] as [String:Value]?
			
			let	r1	=	ds1[111]
			XCTAssert(r1!["k1"]!.integer! == 111)
		}
		db1.apply(tx1)
	}

	
	
	func testIterationCancellation1() {
		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
		func tx1() {
			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2"])
			let	t1	=	db1.tables["T1"]
			
			({ ()->() in
			
				let	ds1	=	t1.dictionaryView
				
				ds1[111]	=	["v1": Value("AA")] as [String:Value]?
				ds1[222]	=	["v1": Value("AA")] as [String:Value]?
				ds1[333]	=	["v1": Value("AA")] as [String:Value]?
				
				let	r1	=	ds1[111]!
				let	r2	=	ds1[222]!
				let	r3	=	ds1[333]!
				
				XCTAssert(r1["k1"]!.integer! == 111)
				XCTAssert(r1["v1"]!.text! == "AA")
				
				XCTAssert(r2["k1"]!.integer! == 222)
				XCTAssert(r2["v1"]!.text! == "AA")
				
				XCTAssert(r3["k1"]!.integer! == 333)
				XCTAssert(r3["v1"]!.text! == "AA")
			})()
			
			({ ()->() in
				let	s1	=	t1.filter(Query.FilterTree(root: Query.FilterTree.Node.Leaf(operation: Query.FilterTree.Node.Operation.Equal, column: Query.Identifier("v1"), value: {"AA"})))
				let	s2	=	s1.sort(Query.SortingList(items: [Query.SortingList.Item(column: Query.Identifier("k1"), order: Query.SortingList.Order.Ascending)]))
				let	x1	=	s2[]
				
				({ ()->() in
					let	ds1	=	x1.dictionaryView
					var	g1	=	ds1.generate()
					let	r1	=	g1.next()
					println(r1)
				})()
				
				
			})()
		}
		db1.apply(tx1)
	}
}






























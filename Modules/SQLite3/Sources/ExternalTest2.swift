////
////  ExternalTest2.swift
////  EonilSQLite3
////
////  Created by Hoon H. on 11/1/14.
////
////
//
//import Foundation
//import EonilSQLite3
//
//
//final class HighLevelTestCases: XCTTestCase {
//
//	func collect(var t:Table) -> [[String:Value]] {
//		var	g1	=	t.dictionaryView.generate()
//		var	a1	=	[] as [[String:Value]]
//		
//		while let e = g1.next() {
//			a1.append(e)
//		}
//		return	a1
//	}
//
//	func testBasicsHighLevelFeaturesWithTransaction() {
//		///	Create new mutable database in memory.
//		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
//		func tx1() {
//			///	Create a new table.
//			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
//			
//			///	Make a single table accessor object.
//			let	t1	=	db1.tables["T1"]
//			
//			///	Insert a new row.
//			t1[111]	=	[42, "Here be dragons.", nil]
//			
//			///	Verify by selecting all current rows.
//			let	rs1	=	collect(t1)
//			assert(rs1.count == 1)
//			assert(rs1[0]["v1"]!.integer! == 42)
//			assert(rs1[0]["v2"]!.text! == "Here be dragons.")
//			
//			///	Update the row.
//			t1[111]	=	[108, "Crouching tiger.", nil]
//			
//			///	Verify!
//			let	rs2	=	collect(t1)
//			assert(rs2.count == 1)
//			assert(rs2[0]["v2"]!.text! == "Crouching tiger.")
//			
//			///	Delete the row.
//			t1[111]	=	nil
//			
//			///	Verify!
//			let	rs3	=	collect(t1)
//			assert(rs3.count == 0)
//		}
//		
//		///	Perform a transaction with multiple commands.
//		db1.apply(tx1)
//	}
//	
//	
//	func testBasicHighLevelFeaturesWithNestedTransactions() {
//		let	db1	=	Database(location: Connection.Location.Memory, editable: true)
//		
//		///	Out-most transaction.
//		func tx1() {
//			db1.schema.create(tableName: "T1", keyColumnNames: ["k1"], dataColumnNames: ["v1", "v2", "v3"])
//			let	t1	=	db1.tables["T1"]
//			
//			///	Outer transaction.
//			func tx2() -> Bool {
//				///	Insert a new row.
//				t1[111]	=	[42, "Here be dragons.", nil]
//			
//				///	Inner transaction.
//				func tx3() -> Bool {
//					///	Update the row.
//					t1[111]	=	[108, "Crouching tiger.", nil]
//					
//					///	Verify the update.
//					let	rs2	=	collect(t1)
//					assert(rs2.count == 1)
//					assert(rs2[0]["v2"]!.text! == "Crouching tiger.")
//					
//					///	And rollback.
//					return	false
//				}
//				db1.applyConditionally(tx3)
//				
//				///	Verify inner rollback.
//				let	rs2	=	collect(t1)
//				assert(rs2.count == 1)
//				assert(rs2[0]["v1"]!.integer! == 42)
//				assert(rs2[0]["v2"]!.text! == "Here be dragons.")
//				
//				return	false
//			}
//			
//			///	Verify outer rollback.
//			let	rs2	=	collect(t1)
//			assert(rs2.count == 0)
//		}
//		db1.apply(tx1)
//	}
//	
//	func testCustomQueryUsingMidLevel() {
//		let	conn1	=	Connection(location: Connection.Location.Memory, editable: true)
//		conn1.execute("CREATE TABLE T1 (k1 INTEGER PRIMARY KEY, v1, v2, v3);")
//		conn1.execute("INSERT INTO T1 (k1, v1, v2, v3) VALUES (111, 42, 'Here be dragons.', NULL);")
//		
//		for (_, row) in enumerate(conn1.execute("SELECT * FROM T1")) {
//			assert(row[1].text! == "Here be dragons.")
//		}
//		
////			let	r1	=	t1[111]
////			println(r1)
////			assert(r1 != nil)
////			assert(r1!.count == 3)
////			assert(r1! == [42, "Here be dragons.", nil])
////		}
////		db1.apply {
////			let	r1	=	t1[222]
////			println(r1)
////			assert(r1 == nil)
////		}
//	}
//	
//	basicsWithTransaction()
//	nestedTransactions()
//	customQuery()
//}
//
//
//

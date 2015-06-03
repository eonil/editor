////
////  ExternalTest1.swift
////  EonilSQLite3
////
////  Created by Hoon H. on 9/20/14.
////
////
//
//import Foundation
//
//
//func test2() {
//	func basics() {
//		
//		///	Create new mutable database in memory.
//		let	db1	=	Connection(location: Connection.Location.Memory, editable: true)
//		
//		///	Create a new table.
//		db1.schema().create(tableName: "T1", dataColumnNames: ["c1"])
//		
//		///	Insert a new row.
//		db1.insert("T1", rowWith: ["c1":"V1"])
//		
//		///	Verify by selecting all current rows.
//		let	rs1	=	db1.select("T1")
//		assert(rs1.count == 1)
//		assert(rs1[0]["c1"]!.text! == "V1")
//		
//		///	Update the row.
//		db1.update("T1", rowsWithAllOf: ["c1":"V1"], bySetting: ["c1":"W2"])
//		
//		///	Verify!
//		let	rs2	=	db1.select("T1")
//		assert(rs2.count == 1)
//		assert(rs2[0]["c1"]!.text! == "W2")
//		
//		///	Delete the row.
//		db1.delete("T1", rowsWithAllOf: ["c1":"W2"])
//		
//		///	Verify!
//		let	rs3	=	db1.select("T1")
//		assert(rs3.count == 0)
//	}
//	
//	func basicsWithTransaction() {
//		///	Create new mutable database in memory.
//		let	db1	=	Connection(location: Connection.Location.Memory, editable: true)
//		func tx1() {
//			///	Create a new table.
//			db1.schema().create(tableName: "T1", dataColumnNames: ["c1"])
//			
//			///	Make a single table accessor object.
//			let	t1	=	db1.table(name: "T1")
//			
//			///	Insert a new row.
//			db1.insert("T1", rowWith: ["c1":"V1"])
//			
//			///	Verify by selecting all current rows.
//			let	rs1	=	db1.select("T1")
//			assert(rs1.count == 1)
//			assert(rs1[0]["c1"]!.text! == "V1")
//			
//			///	Update the row.
//			db1.update("T1", rowsWithAllOf: ["c1":"V1"], bySetting: ["c1":"W2"])
//			
//			///	Verify!
//			let	rs2	=	db1.select("T1")
//			assert(rs2.count == 1)
//			assert(rs2[0]["c1"]!.text! == "W2")
//			
//			///	Delete the row.
//			db1.delete("T1", rowsWithAllOf: ["c1":"W2"])
//			
//			///	Verify!
//			let	rs3	=	db1.select("T1")
//			assert(rs3.count == 0)
//		}
//		
//		///	Perform a transaction with multiple commands.
//		db1.apply(tx1)
//	}
//	
//	
//	func nestedTransactions() {
//		let	db1	=	Connection(location: Connection.Location.Memory, editable: true)
//		
//		///	Out-most transaction.
//		func tx1() {
//			db1.schema().create(tableName: "T1", dataColumnNames: ["c1"])
//			let	t1	=	db1.table(name: "T1")
//			
//			///	Outer transaction.
//			func tx2() -> Bool {
//				db1.insert("T1", rowWith: ["c1":"V1"])
//			
//				///	Inner transaction.
//				func tx3() -> Bool {
//					///	Update the row.
//					db1.update("T1", rowsWithAllOf: ["c1":"V1"], bySetting: ["c1":"W2"])
//					
//					///	Verify the update.
//					let	rs2	=	db1.select("T1")
//					assert(rs2.count == 1)
//					assert(rs2[0]["c1"]!.text! == "W2")
//					
//					///	And rollback.
//					return	false
//				}
//				db1.applyConditionally(tx3)
//				
//				///	Verify inner rollback.
//				let	rs2	=	db1.select("T1")
//				assert(rs2.count == 1)
//				assert(rs2[0]["c1"]!.text! == "V1")
//				
//				return	false
//			}
//			
//			///	Verify outer rollback.
//			let	rs2	=	db1.select("T1")
//			assert(rs2.count == 0)
//		}
//		db1.apply(tx1)
//	}
//	
//	func customQuery() {
//		let	db1	=	Connection(location: Connection.Location.Memory, editable: true)
//		db1.schema().create(tableName: "T1", dataColumnNames: ["c1"])
//		
//		db1.insert("T1", rowWith: ["c1":"V1"])
//		
//		db1.apply {
//			for (_, row) in enumerate(db1.run("SELECT * FROM T1")) {
//				assert(row["c1"]!.text! == "V1")
//			}
//		}
//		
//		db1.apply {
//			let	rs1	=	db1.selection("T1", valuesInColumns: ["c1"])(equalsTo: ["V1"])
//			println(rs1)
//			assert(rs1.count == 1)
//			assert(rs1[0]["c1"]! == "V1" as Value)
//		}
//		db1.apply {
//			let	rs1	=	db1.selection("T1", valuesInColumns: ["c1"])(equalsTo: ["V2"])
//			println(rs1)
//			assert(rs1.count == 0)
//		}
//	}
//	
//	basics()
//	basicsWithTransaction()
//	nestedTransactions()
//	customQuery()
//}
//
//
//
//
//
//
//
//

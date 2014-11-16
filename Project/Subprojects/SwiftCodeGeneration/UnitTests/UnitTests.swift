//
//  UnitTests.swift
//  UnitTests
//
//  Created by Hoon H. on 11/16/14.
//
//

import Cocoa
import XCTest
import SwiftCodeGeneration

class UnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
	
	func test1() {
		struct CodeWriter : CodeWriterType {
			var	output:String	=	""
			mutating func getAndClear() -> String {
				let	o2	=	output
				output	=	""
				return	o2
			}
			mutating func writeToken(s: String) {
				output	+=	s
				output	+=	" "
				
				print(s)
				print(" ")
			}
		}
		
		var	c1	=	CodeWriter()
		let	a1	=	StructDeclaration(name: "AAA")
		
		a1.writeTo(&c1)
		XCTAssert(c1.getAndClear() == "struct AAA { } ")
	}
	func test2() {
		struct CodeWriter : CodeWriterType {
			var	output:String	=	""
			mutating func getAndClear() -> String {
				let	o2	=	output
				output	=	""
				return	o2
			}
			mutating func writeToken(s: String) {
				output	+=	s
				output	+=	" "
				
				print(s)
				print(" ")
			}
		}
		
		var	c1	=	CodeWriter()
		
		var	v1	=	VariableDeclaration(name: "var1", type: "String")
		var	a1	=	StructDeclaration(name: "AAA")
		a1.structBody.append(Declaration.Variable(v1))
		
		a1.writeTo(&c1)
		XCTAssert(c1.getAndClear() == "struct AAA { internal var var1 : String } ")
	}
	func test3() {
		struct CodeWriter : CodeWriterType {
			var	tokens	=	[] as [String]

			mutating func getAndClear() -> String {
				let	o2	=	tokens.filter({$0 != ""})
				tokens	=	[]
				let	s1	=	join(" ", o2)
				return	s1
			}
			mutating func writeToken(s: String) {
				tokens	+=	[s]
			}
		}
		
		var	c1	=	CodeWriter()
		
		var	ps1	=	ParameterList()
		ps1.items.append(Parameter(name: "param1", type: "NSData?"))
		var	i1	=	InitializerDeclaration(failable: true, parameters: ps1)
		var	a1	=	StructDeclaration(name: "AAA")
		a1.structBody.append(Declaration.Initializer(i1))
		
		a1.writeTo(&c1)
		let	s1	=	c1.getAndClear()
		println(s1)
		XCTAssert(s1 == "struct AAA { init ? ( let param1 : NSData? ) { } }")
	}
	func test4() {
		struct CodeWriter : CodeWriterType {
			var	tokens	=	[] as [String]
			
			mutating func getAndClear() -> String {
				let	o2	=	tokens.filter({$0 != ""})
				tokens	=	[]
				let	s1	=	join(" ", o2)
				return	s1
			}
			mutating func writeToken(s: String) {
				tokens	+=	[s]
			}
		}
		
		var	c1	=	CodeWriter()
		
		var	ps1	=	ParameterList()
		ps1.items.append(Parameter(name: "param1", type: "NSData?"))
		var	f1	=	FunctionDeclaration(name: "HereX", resultType: "Flak88")
		var	a1	=	StructDeclaration(name: "AAA")
		a1.structBody.append(Declaration.Function(f1))
		
		a1.writeTo(&c1)
		let	s1	=	c1.getAndClear()
		println(s1)
		XCTAssert(s1 == "struct AAA { func HereX ( ) -> Flak88 { } }")
	}
}
















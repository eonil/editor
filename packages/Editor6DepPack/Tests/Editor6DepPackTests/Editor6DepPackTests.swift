import XCTest
@testable import Editor6DepPack

class Editor6DepPackTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Editor6DepPack().text, "Hello, World!")
    }


    static var allTests : [(String, (Editor6DepPackTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

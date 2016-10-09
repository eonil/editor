import XCTest
@testable import Editor5DepPack

class Editor5DepPackTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Editor5DepPack().text, "Hello, World!")
    }


    static var allTests : [(String, (Editor5DepPackTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}

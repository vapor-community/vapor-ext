import XCTest
@testable import VaporExt

final class VaporExtTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VaporExt().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

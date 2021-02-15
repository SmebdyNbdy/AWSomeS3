import XCTest
@testable import AWSomeS3

final class AWSomeS3Tests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AWSomeS3().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

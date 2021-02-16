import XCTest
import Vapor
@testable import AWSomeS3

final class AWSomeS3Tests: XCTestCase {
    func testExample() {
        let app = Application()
        app.configS3 = ConfigS3(accessKey: "I3vmRHCTdfkLu5767eiq", secretKey: "vhQ5-K_kpWUWDfwxwnbWVk6dj9g8w6IFqlXu6vhS", bucketName: "faces")
        let headers = app.requestS3.sign(HTTPMethod.GET, item: "simple.txt", body: nil)
        print(headers.description)
        app.shutdown()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

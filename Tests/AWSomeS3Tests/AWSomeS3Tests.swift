import XCTest
import Vapor
@testable import AWSomeS3

final class AWSomeS3Tests: XCTestCase {
    func testExample() {
        let app = Application()
        app.configS3 = ConfigS3(accessKey: "I3vmRHCTdfkLu5767eiq", secretKey: "vhQ5-K_kpWUWDfwxwnbWVk6dj9g8w6IFqlXu6vhS", bucketName: "avas")
        let url = app.signS3.url(.PUT, item: "new.jpg")
        print(url)
        let res = app.http.client.shared.get(url: url)
        print(res)
        let _ = res.map { resp in
            print(resp)
            print(resp.status)
            print(resp.headers)
        }
        app.shutdown()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

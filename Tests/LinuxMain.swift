import XCTest

import AWSomeS3Tests

var tests = [XCTestCaseEntry]()
tests += AWSomeS3Tests.allTests()
XCTMain(tests)

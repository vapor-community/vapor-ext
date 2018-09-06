//
//  EnvironmentTests.swift
//  ServiceExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

@testable import ServiceExt
import XCTest

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

final class EnvironmentDotEnvTests: XCTestCase {
    let path = "\(DirectoryConfig.detect().workDir)/_____test.env"

    override func setUp() {
        let mockEnv =
            """
            # example comment

            SERVICE_EXT_STRING_QUOTED="Hello Vapor Quoted"
            SERVICE_EXT_STRING_QUOTED_2=Hello "Vapor"
            SERVICE_EXT_STRING=Hello Vapor
            SERVICE_EXT_INT=107

            SERVICE_EXT_BOOL=true
            """

        FileManager.default.createFile(atPath: path, contents: mockEnv.data(using: .utf8), attributes: nil)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(atPath: path)
    }

    func testDotEnv() {
        Environment.dotenv(filename: "_____test.env")

        var string: String? = Environment.get("SERVICE_EXT_STRING_QUOTED")
        XCTAssertEqual(string, "Hello Vapor Quoted")

        string = Environment.get("SERVICE_EXT_STRING_QUOTED_2")
        XCTAssertEqual(string, "Hello \"Vapor\"")

        string = Environment.get("SERVICE_EXT_STRING")
        XCTAssertEqual(string, "Hello Vapor")

        let int: Int? = Environment.get("SERVICE_EXT_INT")
        XCTAssertEqual(int, 107)

        let bool: Bool? = Environment.get("SERVICE_EXT_BOOL")
        XCTAssertEqual(bool, true)
    }

    func testLinuxTestSuiteIncludesAllTests() throws {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass.defaultTestSuite.testCaseCount)

            XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    static let allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ("testDotEnv", testDotEnv)
    ]
}

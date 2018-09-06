//
//  Future+BoolTests.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async
@testable import AsyncExt
import XCTest

// MARK: - Methods

final class FutureBoolTests: XCTestCase {
    let worker: Worker = EmbeddedEventLoop()

    func testTrue() throws {
        let futTrue = Future.map(on: worker) { true }
        let futFalse = Future.map(on: worker) { false }

        XCTAssertEqual(try futTrue.true(or: CustomError()).wait(), true)
        XCTAssertThrowsError(try futFalse.true(or: CustomError()).wait())
    }

    func testFalse() throws {
        let futTrue = Future.map(on: worker) { true }
        let futFalse = Future.map(on: worker) { false }

        XCTAssertThrowsError(try futTrue.false(or: CustomError()).wait())
        XCTAssertEqual(try futFalse.false(or: CustomError()).wait(), true)
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
        ("testTrue", testTrue),
        ("testFalse", testFalse)
    ]
}

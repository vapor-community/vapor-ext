//
//  Future+ComparableTests.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async
@testable import AsyncExt
import XCTest

final class FutureComparableTests: XCTestCase {
    let worker: Worker = EmbeddedEventLoop()

    func testGreater() throws {
        let fut1 = Future.map(on: worker) { 34 }

        XCTAssertEqual(try fut1.greater(than: 10).wait(), true)
        XCTAssertEqual(try fut1.greater(than: 34).wait(), false)
        XCTAssertEqual(try fut1.greater(than: 50).wait(), false)

        XCTAssertNoThrow(try fut1.greater(than: 10, or: CustomError()).wait())
        XCTAssertThrowsError(try fut1.greater(than: 34, or: CustomError()).wait())
        XCTAssertThrowsError(try fut1.greater(than: 50, or: CustomError()).wait())
    }

    func testGreaterOrEqual() throws {
        let fut1 = Future.map(on: worker) { 34 }

        XCTAssertEqual(try fut1.greaterOrEqual(to: 10).wait(), true)
        XCTAssertEqual(try fut1.greaterOrEqual(to: 34).wait(), true)
        XCTAssertEqual(try fut1.greaterOrEqual(to: 50).wait(), false)

        XCTAssertNoThrow(try fut1.greaterOrEqual(to: 10, or: CustomError()).wait())
        XCTAssertNoThrow(try fut1.greaterOrEqual(to: 34, or: CustomError()).wait())
        XCTAssertThrowsError(try fut1.greaterOrEqual(to: 50, or: CustomError()).wait())
    }

    func testLess() throws {
        let fut1 = Future.map(on: worker) { 34 }

        XCTAssertEqual(try fut1.less(than: 10).wait(), false)
        XCTAssertEqual(try fut1.less(than: 34).wait(), false)
        XCTAssertEqual(try fut1.less(than: 50).wait(), true)

        XCTAssertThrowsError(try fut1.less(than: 10, or: CustomError()).wait())
        XCTAssertThrowsError(try fut1.less(than: 34, or: CustomError()).wait())
        XCTAssertNoThrow(try fut1.less(than: 50, or: CustomError()).wait())
    }

    func testLessOrEqual() throws {
        let fut1 = Future.map(on: worker) { 34 }

        XCTAssertEqual(try fut1.lessOrEqual(to: 10).wait(), false)
        XCTAssertEqual(try fut1.lessOrEqual(to: 34).wait(), true)
        XCTAssertEqual(try fut1.lessOrEqual(to: 50).wait(), true)

        XCTAssertThrowsError(try fut1.lessOrEqual(to: 10, or: CustomError()).wait())
        XCTAssertNoThrow(try fut1.lessOrEqual(to: 34, or: CustomError()).wait())
        XCTAssertNoThrow(try fut1.lessOrEqual(to: 50, or: CustomError()).wait())
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
        ("testGreater", testGreater),
        ("testGreaterOrEqual", testGreaterOrEqual),
        ("testLess", testLess),
        ("testLessOrEqual", testLessOrEqual)
    ]
}

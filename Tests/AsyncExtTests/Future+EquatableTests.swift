//
//  Future+EquatableTests.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async
import XCTest
@testable import AsyncExt

final class FutureEquatableTests: XCTestCase {
    let worker: Worker = EmbeddedEventLoop()

    func testEqual() throws {
        let fut1 = Future.map(on: worker) { 34 }
        let fut2 = Future.map(on: worker) { "string" }

        XCTAssertEqual(try fut1.equal(to: 34).wait(), true)
        XCTAssertEqual(try fut1.equal(to: 30).wait(), false)

        XCTAssertNoThrow(try fut1.equal(to: 34, or: CustomError()).wait())
        XCTAssertThrowsError(try fut1.equal(to: 30, or: CustomError()).wait())

        XCTAssertEqual(try fut2.equal(to: "string").wait(), true)
        XCTAssertEqual(try fut2.equal(to: "not-equal").wait(), false)

        XCTAssertNoThrow(try fut2.equal(to: "string", or: CustomError()).wait())
        XCTAssertThrowsError(try fut2.equal(to: "not-equal", or: CustomError()).wait())
    }

    func testNotEqual() throws {
        let fut1 = Future.map(on: worker) { 34 }
        let fut2 = Future.map(on: worker) { "string" }

        XCTAssertEqual(try fut1.notEqual(to: 34).wait(), false)
        XCTAssertEqual(try fut1.notEqual(to: 30).wait(), true)

        XCTAssertThrowsError(try fut1.notEqual(to: 34, or: CustomError()).wait())
        XCTAssertNoThrow(try fut1.notEqual(to: 30, or: CustomError()).wait())

        XCTAssertEqual(try fut2.notEqual(to: "string").wait(), false)
        XCTAssertEqual(try fut2.notEqual(to: "not-equal").wait(), true)

        XCTAssertThrowsError(try fut2.notEqual(to: "string", or: CustomError()).wait())
        XCTAssertNoThrow(try fut2.notEqual(to: "not-equal", or: CustomError()).wait())
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
        ("testEqual", testEqual),
        ("testNotEqual", testNotEqual)
    ]
}

//
//  VaporExtTests.swift
//  VaporExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import XCTest
@testable import VaporExt

final class StubTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VaporExt().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}

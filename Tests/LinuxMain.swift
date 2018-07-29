//
//  LinuxMain.swift
//  VaporExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import XCTest

@testable import AsyncExtTests
@testable import VaporExtTests

var tests = [XCTestCaseEntry]()

tests += AsyncExtTests.allTests()
tests += VaporExtTests.allTests()

XCTMain(tests)

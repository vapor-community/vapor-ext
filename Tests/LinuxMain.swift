//
//  LinuxMain.swift
//  VaporExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import XCTest

import VaporExtTests

var tests = [XCTestCaseEntry]()
tests += VaporExtTests.allTests()
XCTMain(tests)

//
//  XCTestManifests.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import XCTest

#if !os(macOS)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(FutureBoolTests.allTests),
            testCase(FutureComparableTests.allTests),
            testCase(FutureEquatableTests.allTests)
        ]
    }
#endif

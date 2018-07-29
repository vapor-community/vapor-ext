//
//  Future+Equatable.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async

// MARK: - Methods

public extension Future where T: Equatable {
    /// AsyncExtensions: Check if the current value is equal to the passed value.
    ///
    ///    Future(5).equal(to: 5) -> Future(true)
    ///
    ///    Future("some string").equal(to: "other string") -> Future(false)
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func equal(to value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current == value
        }
    }

    /// AsyncExtensions: Check if the current value is equal to the passed value.
    ///
    ///    Future(5).equal(to: 5, or: CustomError()) -> Future(true)
    ///
    ///    Future(5).equal(to: 3, or: CustomError()) -> Throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if values are not equals.
    public func equal(to value: T, or error: Error) throws -> Future<Bool> {
        return try self.map(to: Bool.self) { current in
            return current == value
        }.true(or: error)
    }

    /// AsyncExtensions: Check if the current value is different to the passed value.
    ///
    ///    Future(5).notEqual(to: 5) -> Future(false)
    ///
    ///    Future("some string").notEqual(to: "other string") -> Future(true)
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func notEqual(to value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current != value
        }
    }

    /// AsyncExtensions: Check if the current value is different to the passed value.
    ///
    ///    Future(5).notEqual(to: 5, or: CustomError()) -> Throws CustomError
    ///
    ///    Future(5).notEqual(to: 3, or: CustomError()) -> Future(true)
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if values are not equals.
    public func notEqual(to value: T, or error: Error) throws -> Future<Bool> {
        return try self.map(to: Bool.self) { current in
            return current != value
        }.true(or: error)
    }
}

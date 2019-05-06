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
    /// Check if the current value is equal to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.equal(to: 5) // true
    ///
    ///    Future.map(on: worker) { "some string" }.equal(to: "other string") // false
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    func equal(to value: T) -> Future<Bool> {
        return map(to: Bool.self) { current in
            current == value
        }
    }

    /// Check if the current value is equal to the passed value
    ///
    ///    Future.map(on: worker) { 5 }.equal(to: 5, or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { 5 }.equal(to: 3, or: CustomError()) // throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if values are not equals.
    func equal(to value: T, or error: Error) throws -> Future<Bool> {
        return try map(to: Bool.self) { current in
            current == value
        }.true(or: error)
    }

    /// Check if the current value is different to the passed value
    ///
    ///    Future.map(on: worker) { 5 }.notEqual(to: 5) // false
    ///
    ///    Future.map(on: worker) { "some string" }.notEqual(to: "other string") // true
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    func notEqual(to value: T) -> Future<Bool> {
        return map(to: Bool.self) { current in
            current != value
        }
    }

    /// Check if the current value is different to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.notEqual(to: 5, or: CustomError()) // throws CustomError
    ///
    ///    Future.map(on: worker) { 5 }.notEqual(to: 3, or: CustomError()) // true
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if values are not equals.
    func notEqual(to value: T, or error: Error) throws -> Future<Bool> {
        return try map(to: Bool.self) { current in
            current != value
        }.true(or: error)
    }
}

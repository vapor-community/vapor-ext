//
//  Future+Comparable.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async

// MARK: - Methods

public extension Future where T: Comparable {
    /// Check if the current value is greater than the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.greater(than: 4) // true
    ///
    ///    Future.map(on: worker) { 5 }.greater(than: 5) // false
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func greater(than value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current > value
        }
    }

    /// Check if the current value is greater than the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.greater(than: 4, or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { 5 }.greater(than: 5, or: CustomError()) // throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if the current value is not greater than the passed value.
    public func greater(than value: T, or error: Error) throws -> Future<Bool> {
        return try greater(than: value).true(or: error)
    }

    /// Check if the current value is greater or equal to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.greaterOrEqual(to: 4) // true
    ///
    ///    Future.map(on: worker) { 5 }.greaterOrEqual(to: 5) // true
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func greaterOrEqual(to value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current >= value
        }
    }

    /// Check if the current value is greater or equal to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.greaterOrEqual(to: 5, or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { 5 }.greaterOrEqual(to: 7, or: CustomError()) // throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if the current value is not greater or equal to the passed value.
    public func greaterOrEqual(to value: T, or error: Error) throws -> Future<Bool> {
        return try greaterOrEqual(to: value).true(or: error)
    }

    /// Check if the current value is less than the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.less(than: 10) // true
    ///
    ///    Future.map(on: worker) { 5 }.less(than: 5) // false
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func less(than value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current < value
        }
    }

    /// Check if the current value is less than the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.less(than: 10, or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { 5 }.less(than: 5, or: CustomError()) // throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if the current value is not less than the passed value.
    public func less(than value: T, or error: Error) throws -> Future<Bool> {
        return try less(than: value).true(or: error)
    }

    /// Check if the current value is less or equal to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.lessOrEqual(to: 10) // true
    ///
    ///    Future.map(on: worker) { 5 }.lessOrEqual(to: 5) // true
    ///
    /// - Parameter value: The value to compare.
    /// - Returns: The result of the comparison wrapped in a Future.
    public func lessOrEqual(to value: T) -> Future<Bool> {
        return self.map(to: Bool.self) { current in
            return current <= value
        }
    }

    /// Check if the current value is less or equal to the passed value.
    ///
    ///    Future.map(on: worker) { 5 }.lessOrEqual(to: 10, or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { 5 }.lessOrEqual(to: 7, or: CustomError()) // throws CustomError
    ///
    /// - Parameters:
    ///   - value: The value to compare.
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error if the current value is not less or equal to the passed value.
    public func lessOrEqual(to value: T, or error: Error) throws -> Future<Bool> {
        return try lessOrEqual(to: value).true(or: error)
    }
}

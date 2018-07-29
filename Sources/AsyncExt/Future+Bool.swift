//
//  Future+Bool.swift
//  AsyncExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Async

// MARK: - Methods

public extension Future where T == Bool {
    /// AsyncExtensions: Check if the current value is `true`.
    ///
    ///    Future(true).true(or: CustomError()) -> Future(true)
    ///
    ///    Future(false).true(or: CustomError()) -> Throws CustomError
    ///
    /// - Parameters:
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error in the opposite case.
    public func `true`(or error: Error) throws -> Future<Bool> {
        return self.map(to: Bool.self) { boolean in
            if !boolean {
                throw error
            }
            return boolean
        }
    }

    /// AsyncExtensions: Check if the current value is `false`.
    ///
    ///    Future(false).false(or: CustomError()) -> Future(true)
    ///
    ///    Future(true).false(or: CustomError()) -> Throws CustomError
    ///
    /// - Parameters:
    ///   - error: The error to be thrown.
    /// - Returns: The result of the comparison wrapped in a Future.
    /// - Throws: Throws the passed error in the opposite case.
    public func `false`(or error: Error) throws -> Future<Bool> {
        return self.map(to: Bool.self) { boolean in
            if boolean {
                throw error
            }
            return !boolean
        }
    }
}

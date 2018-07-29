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
    /// Check if the current value is `true`.
    ///
    ///    Future.map(on: worker) { true }.true(or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { false }.true(or: CustomError()) // Throws CustomError
    ///
    /// - Parameter error: The error to be thrown.
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

    /// Check if the current value is `false`.
    ///
    ///    Future.map(on: worker) { false }.false(or: CustomError()) // true
    ///
    ///    Future.map(on: worker) { true }.false(or: CustomError()) // Throws CustomError
    ///
    /// - Parameter error: The error to be thrown.
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

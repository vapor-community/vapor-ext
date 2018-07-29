//
//  QueryBuilder+Sort.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Fluent
import Vapor

public extension QueryBuilder where Result: Model, Result.Database == Database {
    /// Applies sort criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath.
    ///   - queryParam: the sorting parameter name in the query params url.
    ///   - parameter: the parameter name in sorting config.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func sort<T>(_ keyPath: KeyPath<Result, T>, at queryParam: String, as parameter: String, on req: Request) throws -> Self {
        guard let sort = req.query[String.self, at: queryParam] else {
            return self
        }

        let sortOpts = sort.components(separatedBy: ",")

        for option in sortOpts {
            let splited = option.components(separatedBy: ":")

            let field = splited[0]

            if field != parameter {
                continue
            }

            let direction = splited.count == 1 ? "asc" : splited[1]

            guard ["asc", "desc"].contains(direction) else {
                throw FluentError(identifier: "invalidSortConfiguration", reason: "Invalid sort config for '\(option)'")
            }

            return self.sort(keyPath, direction == "asc" ? Database.querySortDirectionAscending : Database.querySortDirectionDescending)
        }

        return self
    }

    /// Applies sort criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath.
    ///   - parameter: the parameter name in sorting config.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func sort<T>(_ keyPath: KeyPath<Result, T>, as parameter: String, on req: Request) throws -> Self {
        return try self.sort(keyPath, at: "sort", as: parameter, on: req)
    }
}

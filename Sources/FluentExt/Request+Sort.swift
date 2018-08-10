//
//  Request+Sort.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 08/09/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Vapor

public extension Request {
    /// Build sort criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath.
    ///   - queryParam: the sorting parameter name in the query params url.
    ///   - parameter: the parameter name in sorting config.
    ///   - direction: Default direction to apply if no value is found in url query params.
    /// - Returns: QuerySort criteria
    /// - Throws: FluentError
    public func sort<M, T>(_ keyPath: KeyPath<M, T>, at queryParam: String, as parameter: String, default direction: M.Database.QuerySortDirection? = nil) throws -> M.Database.QuerySort? where M: Model {
        if let sort = self.query[String.self, at: queryParam] {
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

                let dir = direction == "asc" ? M.Database.querySortDirectionAscending: M.Database.querySortDirectionDescending

                return M.Database.querySort(M.Database.queryField(.keyPath(keyPath)), dir)
            }
        }

        if let direction = direction {
            return M.Database.querySort(M.Database.queryField(.keyPath(keyPath)), direction)
        }

        return nil
    }

    /// Build sort criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath.
    ///   - parameter: the parameter name in sorting config.
    ///   - direction: Default direction to apply if no value is found in url query params.
    /// - Returns: QuerySort criteria
    /// - Throws: FluentError
    public func sort<M, T>(_ keyPath: KeyPath<M, T>, as parameter: String, default direction: M.Database.QuerySortDirection? = nil) throws -> M.Database.QuerySort? where M: Model {
        return try self.sort(keyPath, at: "sort", as: parameter, default: direction)
    }
}

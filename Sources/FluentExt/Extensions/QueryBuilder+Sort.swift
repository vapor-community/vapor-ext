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
    ///   - direction: Default direction to apply if no value is found in url query params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    func sort<T>(_ keyPath: KeyPath<Result, T>, at queryParam: String, as parameter: String, default direction: Database.QuerySortDirection? = nil, on req: Request) throws -> Self {
        if let sort = req.query[String.self, at: queryParam] {
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
        }

        if let direction = direction {
            return sort(keyPath, direction)
        }

        return self
    }

    /// Applies sort criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath.
    ///   - parameter: the parameter name in sorting config.
    ///   - direction: Default direction to apply if no value is found in url query params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    func sort<T>(_ keyPath: KeyPath<Result, T>, as parameter: String, default direction: Database.QuerySortDirection? = nil, on req: Request) throws -> Self {
        return try sort(keyPath, at: "sort", as: parameter, default: direction, on: req)
    }

    /// Applies sort criteria over a keypath using criteria configured in a request query params
    ///
    /// - Parameter sorts: Some `QuerySort`s to be applied.
    /// - Returns: Self
    func sort(by sorts: [Database.QuerySort]? = nil) -> Self {
        sorts?.forEach { sort in
            Database.querySortApply(sort, to: &query)
        }

        return self
    }
}

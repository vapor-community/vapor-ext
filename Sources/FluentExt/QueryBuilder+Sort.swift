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
                throw Abort(.internalServerError)
            }

            return self.sort(keyPath, direction == "asc" ? Database.querySortDirectionAscending : Database.querySortDirectionDescending)
        }

        return self
    }

    public func sort<T>(_ keyPath: KeyPath<Result, T>, as parameter: String, on req: Request) throws -> Self {
        return try self.sort(keyPath, at: "sort", as: parameter, on: req)
    }
}

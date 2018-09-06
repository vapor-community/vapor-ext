//
//  QueryBuilder+Filter.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Fluent
import FluentSQL
import Vapor

public extension QueryBuilder where Result: Model, Result.Database == Database {
    /// Applies filter criteria over a keypath using criteria configured in a request query params.
    ///
    ///     If your request user is /users?username=ew:gmail.com
    ///     `\User.query(on: req).filter(\User.username, at: email, on: req)`
    ///     then, the previous code will extract the filter config for the key `email` of your url params
    ///     and will build a query filter for the \User.username keypath where their values ends with `gmail.com`
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func filter<T>(_ keyPath: KeyPath<Result, T>, at parameter: String, on req: Request) throws -> Self where T: Codable {
        let decoder = try req.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = req.query[String.self, at: parameter] else {
            return self
        }

        let filterConfig = config.toFilterConfig

        let method = filterConfig.method
        let value = filterConfig.value

        let multiple = [.in, .notIn].contains(method)
        var parsed: FilterValue<T, [T]>

        if multiple {
            let str = value.components(separatedBy: ",").map { "\(parameter)[]=\($0)" }.joined(separator: "&")
            parsed = try .multiple(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        } else {
            let str = "\(parameter)=\(value)"
            parsed = try .single(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        }

        switch (method, parsed) {
        case let (.equal, .single(value)): // Equal
            return filter(keyPath == value)
        case let (.notEqual, .single(value)): // Not Equal
            return filter(keyPath != value)
        case let (.greaterThan, .single(value)): // Greater Than
            return filter(keyPath > value)
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return filter(keyPath >= value)
        case let (.lessThan, .single(value)): // Less Than
            return filter(keyPath < value)
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return filter(keyPath <= value)
        case let (.in, .multiple(value)): // In
            return filter(keyPath ~~ value)
        case let (.notIn, .multiple(value)): // Not In
            return filter(keyPath !~ value)
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }
}

public extension QueryBuilder where Result: Model, Result.Database == Database, Result.Database.QueryFilterMethod: SQLBinaryOperator {
    /// Applies filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func filter(_ keyPath: KeyPath<Result, String>, at parameter: String, on req: Request) throws -> Self {
        let decoder = try req.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = req.query[String.self, at: parameter] else {
            return self
        }

        let filterConfig = config.toFilterConfig

        let method = filterConfig.method
        let value = filterConfig.value

        let multiple = [.in, .notIn].contains(method)
        var parsed: FilterValue<String, [String]>

        if multiple {
            let str = value.components(separatedBy: ",").map { "\(parameter)[]=\($0)" }.joined(separator: "&")
            parsed = try .multiple(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        } else {
            let str = "\(parameter)=\(value)"
            parsed = try .single(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        }

        switch (method, parsed) {
        case let (.equal, .single(value)): // Equal
            return filter(keyPath == value)
        case let (.notEqual, .single(value)): // Not Equal
            return filter(keyPath != value)
        case let (.greaterThan, .single(value)): // Greater Than
            return filter(keyPath > value)
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return filter(keyPath >= value)
        case let (.lessThan, .single(value)): // Less Than
            return filter(keyPath < value)
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return filter(keyPath <= value)
        case let (.contains, .single(value)): // Contains
            return filter(keyPath ~~ value)
        case let (.notContains, .single(value)): // Not Contains
            return filter(keyPath !~~ value)
        case let (.startsWith, .single(value)): // Start With / Preffix
            return filter(keyPath =~ value)
        case let (.endsWith, .single(value)): // Ends With / Suffix
            // return self.filter(keyPath ~= value)
            return filter(.make(keyPath, .like, ["%" + value]))
        case let (.notStartsWith, .single(value)): // No Start With / Preffix
            return filter(keyPath !=~ value)
        case let (.notEndsWith, .single(value)): // No Ends With / Suffix
            return filter(keyPath !~= value)
        case let (.in, .multiple(value)): // In
            return filter(keyPath ~~ value)
        case let (.notIn, .multiple(value)): // Not In
            return filter(keyPath !~ value)
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }

    /// Applies filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func filter(_ keyPath: KeyPath<Result, String?>, at parameter: String, on req: Request) throws -> Self {
        let decoder = try req.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = req.query[String.self, at: parameter] else {
            return self
        }

        let filterConfig = config.toFilterConfig

        let method = filterConfig.method
        let value = filterConfig.value

        let multiple = [.in, .notIn].contains(method)
        var parsed: FilterValue<String, [String]>

        if multiple {
            let str = value.components(separatedBy: ",").map { "\(parameter)[]=\($0)" }.joined(separator: "&")
            parsed = try .multiple(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        } else {
            let str = "\(parameter)=\(value)"
            parsed = try .single(decoder.decode(SingleValueDecoder.self, from: str).get(at: [parameter.makeBasicKey()]))
        }

        switch (method, parsed) {
        case let (.equal, .single(value)): // Equal
            return filter(keyPath == value)
        case let (.notEqual, .single(value)): // Not Equal
            return filter(keyPath != value)
        case let (.greaterThan, .single(value)): // Greater Than
            return filter(keyPath > value)
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return filter(keyPath >= value)
        case let (.lessThan, .single(value)): // Less Than
            return filter(keyPath < value)
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return filter(keyPath <= value)
        case let (.contains, .single(value)): // Contains
            return filter(keyPath ~~ value)
        case let (.notContains, .single(value)): // Not Contains
            return filter(keyPath !~~ value)
        case let (.startsWith, .single(value)): // Start With / Preffix
            return filter(keyPath =~ value)
        case let (.endsWith, .single(value)): // Ends With / Suffix
            // return self.filter(keyPath ~= value)
            return filter(.make(keyPath, .like, ["%" + value]))
        case let (.notStartsWith, .single(value)): // No Start With / Preffix
            return filter(keyPath !=~ value)
        case let (.notEndsWith, .single(value)): // No Ends With / Suffix
            return filter(keyPath !~= value)
        case let (.in, .multiple(value)): // In
            return filter(keyPath ~~ value)
        case let (.notIn, .multiple(value)): // Not In
            return filter(keyPath !~ value)
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }
}

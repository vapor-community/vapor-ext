//
//  QueryBuilder+Filter.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Vapor
import Fluent
import FluentSQL

public extension QueryBuilder where Result: Model, Result.Database == Database {
    /// Applies filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    ///   - req: the request.
    /// - Returns: Self
    /// - Throws: FluentError
    public func filter<T>(_ keyPath: KeyPath<Result, T>, at parameter: String, on req: Request) throws -> Self where T: Encodable & Decodable {
        let decoder = try req.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = req.query[String.self, at: parameter] else {
            return self
        }

        let splited = config.components(separatedBy: ":")

        let method: QueryFilterMethod
        let value: String

        if splited.count == 1 {
            method = .equal
            value = splited[0]
        } else {
            guard let mth = QueryFilterMethod(rawValue: splited[0]) else {
                throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
            }
            method = mth
            value = splited[1]
        }

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
        case (.equal, .single(let value)): // Equal
            return self.filter(keyPath == value)
        case (.notEqual, .single(let value)): // Not Equal
            return self.filter(keyPath != value)
        case (.greaterThan, .single(let value)): // Greater Than
            return self.filter(keyPath > value)
        case (.greaterThanOrEqual, .single(let value)): // Greater Than Or Equal
            return self.filter(keyPath >= value)
        case (.lessThan, .single(let value)): // Less Than
            return self.filter(keyPath < value)
        case (.lessThanOrEqual, .single(let value)): // Less Than Or Equal
            return self.filter(keyPath <= value)
        case (.in, .multiple(let value)): // In
            return self.filter(keyPath ~~ value)
        case (.notIn, .multiple(let value)): // Not In
            return self.filter(keyPath !~ value)
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

        let splited = config.components(separatedBy: ":")

        let method: QueryFilterMethod
        let value: String

        if splited.count == 1 {
            method = .equal
            value = splited[0]
        } else {
            guard let mth = QueryFilterMethod(rawValue: splited[0]) else {
                throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
            }
            method = mth
            value = splited[1]
        }

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
        case (.equal, .single(let value)): // Equal
            return self.filter(keyPath == value)
        case (.notEqual, .single(let value)): // Not Equal
            return self.filter(keyPath != value)
        case (.greaterThan, .single(let value)): // Greater Than
            return self.filter(keyPath > value)
        case (.greaterThanOrEqual, .single(let value)): // Greater Than Or Equal
            return self.filter(keyPath >= value)
        case (.lessThan, .single(let value)): // Less Than
            return self.filter(keyPath < value)
        case (.lessThanOrEqual, .single(let value)): // Less Than Or Equal
            return self.filter(keyPath <= value)
        case (.contains, .single(let value)): // Contains
            return self.filter(keyPath ~~ value)
        case (.notContains, .single(let value)): // Not Contains
            return self.filter(keyPath !~~ value)
        case (.startsWith, .single(let value)): // Start With / Preffix
            return self.filter(keyPath =~ value)
        case (.endsWith, .single(let value)): // Ends With / Suffix
            // return self.filter(keyPath ~= value)
            return self.filter(.make(keyPath, .like, ["%" + value]))
        case (.notStartsWith, .single(let value)): // No Start With / Preffix
            return self.filter(keyPath !=~ value)
        case (.notEndsWith, .single(let value)): // No Ends With / Suffix
            return self.filter(keyPath !~= value)
        case (.in, .multiple(let value)): // In
            return self.filter(keyPath ~~ value)
        case (.notIn, .multiple(let value)): // Not In
            return self.filter(keyPath !~ value)
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }
}

//
//  Request+Filter.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 08/09/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Vapor

public extension Request {
    /// Build filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    /// - Returns: FilterOperator
    /// - Throws: FluentError
    public func filter<Result, T>(_ keyPath: KeyPath<Result, T>, at parameter: String) throws -> FilterOperator<Result.Database, Result>? where T: Codable, Result: Model {
        let decoder = try self.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value // self.filter(keyPath == value)
        case (.notEqual, .single(let value)): // Not Equal
            return keyPath != value // self.filter(keyPath != value)
        case (.greaterThan, .single(let value)): // Greater Than
            return keyPath > value // self.filter(keyPath > value)
        case (.greaterThanOrEqual, .single(let value)): // Greater Than Or Equal
            return keyPath >= value // self.filter(keyPath >= value)
        case (.lessThan, .single(let value)): // Less Than
            return keyPath < value // self.filter(keyPath < value)
        case (.lessThanOrEqual, .single(let value)): // Less Than Or Equal
            return keyPath <= value // self.filter(keyPath <= value)
        case (.in, .multiple(let value)): // In
            return keyPath ~~ value // self.filter(keyPath ~~ value)
        case (.notIn, .multiple(let value)): // Not In
            return keyPath !~ value // self.filter(keyPath !~ value)
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }

    /// Build filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    /// - Returns: FilterOperator
    /// - Throws: FluentError
    public func filter<Result>(_ keyPath: KeyPath<Result, String>, at parameter: String) throws -> FilterOperator<Result.Database, Result>? where Result: Model, Result.Database.QueryFilterMethod: SQLBinaryOperator {
        let decoder = try self.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value
        case (.notEqual, .single(let value)): // Not Equal
            return keyPath != value
        case (.greaterThan, .single(let value)): // Greater Than
            return keyPath > value
        case (.greaterThanOrEqual, .single(let value)): // Greater Than Or Equal
            return keyPath >= value
        case (.lessThan, .single(let value)): // Less Than
            return keyPath < value
        case (.lessThanOrEqual, .single(let value)): // Less Than Or Equal
            return keyPath <= value
        case (.contains, .single(let value)): // Contains
            return keyPath ~~ value
        case (.notContains, .single(let value)): // Not Contains
            return keyPath !~~ value
        case (.startsWith, .single(let value)): // Start With / Preffix
            return keyPath =~ value
        case (.endsWith, .single(let value)): // Ends With / Suffix
            return keyPath ~= value
        case (.notStartsWith, .single(let value)): // No Start With / Preffix
            return keyPath !=~ value
        case (.notEndsWith, .single(let value)): // No Ends With / Suffix
            return keyPath !~= value
        case (.in, .multiple(let value)): // In
            return keyPath ~~ value
        case (.notIn, .multiple(let value)): // Not In
            return keyPath !~ value
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }

    /// Build filter criteria over a keypath using criteria configured in a request query params.
    ///
    /// - Parameters:
    ///   - keyPath: the model keypath
    ///   - parameter: the parameter name in filter config from request url params.
    /// - Returns: FilterOperator
    /// - Throws: FluentError
    public func filter<Result>(_ keyPath: KeyPath<Result, String?>, at parameter: String, on req: Request) throws -> FilterOperator<Result.Database, Result>? where Result: Model, Result.Database.QueryFilterMethod: SQLBinaryOperator {
        let decoder = try self.make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value
        case (.notEqual, .single(let value)): // Not Equal
            return keyPath != value
        case (.greaterThan, .single(let value)): // Greater Than
            return keyPath > value
        case (.greaterThanOrEqual, .single(let value)): // Greater Than Or Equal
            return keyPath >= value
        case (.lessThan, .single(let value)): // Less Than
            return keyPath < value
        case (.lessThanOrEqual, .single(let value)): // Less Than Or Equal
            return keyPath <= value
        case (.contains, .single(let value)): // Contains
            return keyPath ~~ value
        case (.notContains, .single(let value)): // Not Contains
            return keyPath !~~ value
        case (.startsWith, .single(let value)): // Start With / Preffix
            return keyPath =~ value
        case (.endsWith, .single(let value)): // Ends With / Suffix
            return keyPath ~= value
        case (.notStartsWith, .single(let value)): // No Start With / Preffix
            return keyPath !=~ value
        case (.notEndsWith, .single(let value)): // No Ends With / Suffix
            return keyPath !~= value
        case (.in, .multiple(let value)): // In
            return keyPath ~~ value
        case (.notIn, .multiple(let value)): // Not In
            return keyPath !~ value
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }
}

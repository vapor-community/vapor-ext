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
        let decoder = try make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value // self.filter(keyPath == value)
        case let (.notEqual, .single(value)): // Not Equal
            return keyPath != value // self.filter(keyPath != value)
        case let (.greaterThan, .single(value)): // Greater Than
            return keyPath > value // self.filter(keyPath > value)
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return keyPath >= value // self.filter(keyPath >= value)
        case let (.lessThan, .single(value)): // Less Than
            return keyPath < value // self.filter(keyPath < value)
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return keyPath <= value // self.filter(keyPath <= value)
        case let (.in, .multiple(value)): // In
            return keyPath ~~ value // self.filter(keyPath ~~ value)
        case let (.notIn, .multiple(value)): // Not In
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
        let decoder = try make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value
        case let (.notEqual, .single(value)): // Not Equal
            return keyPath != value
        case let (.greaterThan, .single(value)): // Greater Than
            return keyPath > value
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return keyPath >= value
        case let (.lessThan, .single(value)): // Less Than
            return keyPath < value
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return keyPath <= value
        case let (.contains, .single(value)): // Contains
            return keyPath ~~ value
        case let (.notContains, .single(value)): // Not Contains
            return keyPath !~~ value
        case let (.startsWith, .single(value)): // Start With / Preffix
            return keyPath =~ value
        case let (.endsWith, .single(value)): // Ends With / Suffix
            return keyPath ~= value
        case let (.notStartsWith, .single(value)): // No Start With / Preffix
            return keyPath !=~ value
        case let (.notEndsWith, .single(value)): // No Ends With / Suffix
            return keyPath !~= value
        case let (.in, .multiple(value)): // In
            return keyPath ~~ value
        case let (.notIn, .multiple(value)): // Not In
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
    public func filter<Result>(_ keyPath: KeyPath<Result, String?>, at parameter: String) throws -> FilterOperator<Result.Database, Result>? where Result: Model, Result.Database.QueryFilterMethod: SQLBinaryOperator {
        let decoder = try make(ContentCoders.self).requireDataDecoder(for: .urlEncodedForm)

        guard let config = self.query[String.self, at: parameter] else {
            return nil
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
            return keyPath == value
        case let (.notEqual, .single(value)): // Not Equal
            return keyPath != value
        case let (.greaterThan, .single(value)): // Greater Than
            return keyPath > value
        case let (.greaterThanOrEqual, .single(value)): // Greater Than Or Equal
            return keyPath >= value
        case let (.lessThan, .single(value)): // Less Than
            return keyPath < value
        case let (.lessThanOrEqual, .single(value)): // Less Than Or Equal
            return keyPath <= value
        case let (.contains, .single(value)): // Contains
            return keyPath ~~ value
        case let (.notContains, .single(value)): // Not Contains
            return keyPath !~~ value
        case let (.startsWith, .single(value)): // Start With / Preffix
            return keyPath =~ value
        case let (.endsWith, .single(value)): // Ends With / Suffix
            return keyPath ~= value
        case let (.notStartsWith, .single(value)): // No Start With / Preffix
            return keyPath !=~ value
        case let (.notEndsWith, .single(value)): // No Ends With / Suffix
            return keyPath !~= value
        case let (.in, .multiple(value)): // In
            return keyPath ~~ value
        case let (.notIn, .multiple(value)): // Not In
            return keyPath !~ value
        default:
            throw FluentError(identifier: "invalidFilterConfiguration", reason: "Invalid filter config for '\(config)'")
        }
    }
}

//
//  QueryFilterMethod.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

internal enum QueryFilterMethod: String {
    case equal = "eq"
    case notEqual = "neq"
    case `in` = "in"
    case notIn = "nin"
    case greaterThan = "gt"
    case greaterThanOrEqual = "gte"
    case lessThan = "lt"
    case lessThanOrEqual = "lte"
    case startsWith = "sw"
    case notStartsWith = "nsw"
    case endsWith = "ew"
    case notEndsWith = "new"
    case contains = "ct"
    case notContains = "nct"
}

#if swift(>=4.2)
    extension QueryFilterMethod: CaseIterable {}
#else
    extension QueryFilterMethod {
        static var allCases: [QueryFilterMethod] {
            return [
                .equal,
                .notEqual,
                .in,
                .notIn,
                .greaterThan,
                .greaterThanOrEqual,
                .lessThan,
                .lessThanOrEqual,
                .startsWith,
                .notStartsWith,
                .endsWith,
                .notEndsWith,
                .contains,
                .notContains,
            ]
        }
    }
#endif

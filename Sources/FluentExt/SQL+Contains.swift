//
//  SQL+Contains.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 07/28/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Fluent
import FluentSQL

infix operator !~=
/// Not has suffix
public func !~= <Result, D>(lhs: KeyPath<Result, String>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, ["%" + rhs])
}
/// Not has suffix
public func !~= <Result, D>(lhs: KeyPath<Result, String?>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, ["%" + rhs])
}

infix operator !=~
/// Not has prefix.
public func !=~ <Result, D>(lhs: KeyPath<Result, String>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, [rhs + "%"])
}
/// Not has prefix.
public func !=~ <Result, D>(lhs: KeyPath<Result, String?>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, [rhs + "%"])
}

infix operator !~~
/// Not contains.
public func !~~ <Result, D>(lhs: KeyPath<Result, String>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, ["%" + rhs + "%"])
}
/// Not contains.
public func !~~ <Result, D>(lhs: KeyPath<Result, String?>, rhs: String) -> FilterOperator<D, Result>
    where D: QuerySupporting, D.QueryFilterMethod: SQLBinaryOperator {
    return .make(lhs, .notLike, ["%" + rhs + "%"])
}

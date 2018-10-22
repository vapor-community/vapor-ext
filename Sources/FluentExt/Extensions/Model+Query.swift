//
//  Model+Query.swift
//  FluentExt
//
//  Created by Gustavo Perdomo on 09/20/18.
//  Copyright © 2018 Vapor Community. All rights reserved.
//

import Fluent
import Vapor

extension Model where Database: QuerySupporting {
    /// Creates a query for this model type on the supplied connection.
    ///
    /// - Parameters:
    ///   - filters: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: QueryBuilder
    public static func query(by filters: [FilterOperator<Self.Database, Self>], on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> QueryBuilder<Self.Database, Self> {
        var query = Self.query(on: conn, withSoftDeleted: withSoftDeleted)

        filters.forEach { filter in
            query = query.filter(filter)
        }

        return query
    }

    /// Collects all the results of this model type into an array.
    ///
    /// - Parameters:
    ///   - sortBy: Some `QuerySort`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the results.
    public static func findAll(sortBy: [Self.Database.QuerySort]? = nil, on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<[Self]> {
        return Self.findAll(as: Self.self, sortBy: sortBy, on: conn, withSoftDeleted: withSoftDeleted)
    }
    
    /// Collects all the results of this model type into an array.
    ///
    /// - Parameters:
    ///   - as: Sets the query to decode Model type D when run. The Model’s entity will be used.
    ///   - sortBy: Some `QuerySort`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the results.
    public static func findAll<M>(as:
        M.Type, sortBy: [Self.Database.QuerySort]? = nil, on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<[M]> where M: Model {
        return Self
            .query(on: conn, withSoftDeleted: withSoftDeleted)
            .sort(by: sortBy)
            .decode(M.self)
            .all()
    }

    /// Collects all the results of this model type that matches with filters criteria, into an array.
    ///
    /// - Parameters:
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - sortBy: Some `QuerySort`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the results.
    public static func find(by criteria: [FilterOperator<Self.Database, Self>] = [], sortBy: [Self.Database.QuerySort]? = nil, on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<[Self]> {
        return Self.find(as: Self.self, by: criteria, sortBy: sortBy, on: conn, withSoftDeleted: withSoftDeleted)
    }
    
    /// Collects all the results of this model type that matches with filters criteria, into an array.
    ///
    /// - Parameters:
    ///   - as: Sets the query to decode Model type D when run. The Model’s entity will be used.
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - sortBy: Some `QuerySort`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the results.
    public static func find<M>(as: M.Type, by criteria: [FilterOperator<Self.Database, Self>] = [], sortBy: [Self.Database.QuerySort]? = nil, on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<[M]> where M: Model {
        return Self
            .query(by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
            .sort(by: sortBy)
            .decode(M.self)
            .all()
    }

    /// Search the first model of this type, that matches the filters criteria.
    ///
    /// - Parameters:
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the result.
    public static func findOne(by criteria: [FilterOperator<Self.Database, Self>], on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Self?> {
        return Self.findOne(as: Self.self, by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
    }
    
    /// Search the first model of this type, that matches the filters criteria.
    ///
    /// - Parameters:
    ///   - as: Sets the query to decode Model type D when run. The Model’s entity will be used.
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the result.
    public static func findOne<M>(as: M.Type, by criteria: [FilterOperator<Self.Database, Self>], on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<M?> where M: Model {
        return Self
            .query(by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
            .decode(M.self)
            .first()
    }

    /// Returns the number of registers for this model.
    ///
    /// - Parameters:
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the count.
    public static func count(on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Int> {
        return Self.query(on: conn, withSoftDeleted: withSoftDeleted).count()
    }

    /// Returns the number of results for this model, after apply the filter criteria.
    ///
    /// - Parameters:
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the count.
    public static func count(by criteria: [FilterOperator<Self.Database, Self>], on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Int> {
        return Self
            .query(by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
            .count()
    }
}

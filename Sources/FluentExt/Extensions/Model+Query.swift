import Fluent
import Vapor

extension Model where Database: QuerySupporting {
    /// Find by id.
    ///
    /// - Parameters:
    ///   - id: id of the model to find
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the result.
    public static func find(id: Self.ID, on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Self?> {
        return Self
            .query(on: conn, withSoftDeleted: withSoftDeleted)
            .filter(\Self.fluentID == id)
            .first()
    }

    /// Creates a query for this model type on the supplied connection.
    ///
    /// - Parameters:
    ///   - filters: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: <#return value description#>
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
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - sortBy: Some `QuerySort`s to be applied.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the results.
    public static func findAll(on conn: DatabaseConnectable, sortBy: [Self.Database.QuerySort]? = nil, withSoftDeleted: Bool = false) -> Future<[Self]> {
        return Self
            .query(on: conn, withSoftDeleted: withSoftDeleted)
            .sort(by: sortBy)
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
        return Self
            .query(by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
            .sort(by: sortBy)
            .all()
    }

    /// Search the first model of this type, that matches the filters criteria
    ///
    /// - Parameters:
    ///   - criteria: Some `FilterOperator`s to be applied.
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the result.
    public static func findOne(by criteria: [FilterOperator<Self.Database, Self>], on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Self?> {
        return Self
            .query(by: criteria, on: conn, withSoftDeleted: withSoftDeleted)
            .first()
    }

    /// Returns the number of registers for this model
    ///
    /// - Parameters:
    ///   - conn: Something `DatabaseConnectable` to create the `QueryBuilder` on.
    ///   - withSoftDeleted: If `true`, soft-deleted models will be included in the results. Defaults to `false`.
    /// - Returns: A `Future` containing the count.
    public static func count(on conn: DatabaseConnectable, withSoftDeleted: Bool = false) -> Future<Int> {
        return Self.query(on: conn, withSoftDeleted: withSoftDeleted).count()
    }

    /// Returns the number of results for this model, after apply the filter criteria
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

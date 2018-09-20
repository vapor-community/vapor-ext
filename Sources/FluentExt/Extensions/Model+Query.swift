import Fluent
import Vapor

extension Model where Database: QuerySupporting {
    public static func findAll(on connectable: DatabaseConnectable) -> Future<[Self]> {
        return Self.query(on: connectable).all()
    }

    public static func findBy(criteria: [FilterOperator<Self.Database, Self>], orderBy: [Self.Database.QuerySort]?, on connectable: DatabaseConnectable) -> Future<[Self]> {
        var query = Self.query(on: connectable)

        criteria.forEach { filter in
            query = query.filter(filter)
        }

        if let orderBy = orderBy {
            orderBy.forEach { order in
                query = query.sort(order)
            }
        }

        return query.all()
    }

    public static func findOneBy(criteria: [FilterOperator<Self.Database, Self>], on connectable: DatabaseConnectable) -> Future<Self?> {
        var query = Self.query(on: connectable)

        criteria.forEach { filter in
            query = query.filter(filter)
        }

        return query.first()
    }

    public static func count(on connectable: DatabaseConnectable) -> Future<Int> {
        return Self.query(on: connectable).count()
    }

    public static func countBy(criteria: [FilterOperator<Self.Database, Self>] = [FilterOperator<Self.Database, Self>](), on connectable: DatabaseConnectable) -> Future<Int> {
        var query = Self.query(on: connectable)

        criteria.forEach { filter in
            query = query.filter(filter)
        }

        return query.count()
    }
}

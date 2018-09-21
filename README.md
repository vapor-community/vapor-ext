<p align="center">
    <a href="https://vapor.codes">
        <img src="https://img.shields.io/badge/Vapor-3-brightgreen.svg" alt="Vapor Version">
    </a>
    <a href="license">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor-community/vapor-ext">
        <img src="https://circleci.com/gh/vapor-community/vapor-ext.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://codecov.io/gh/vapor-community/vapor-ext">
      <img src="https://codecov.io/gh/vapor-community/vapor-ext/branch/master/graph/badge.svg" />
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
    </a>
</p>

# VaporExt

VaporExt is a collection of **Swift extensions**, with handy methods, syntactic sugar, and performance improvements for wide range of Vapor types and classes.

## Requirements:

- Swift 4.1+

## Installation

You can use <a href="https://swift.org/package-manager">The Swift Package Manager</a> to install <code>VaporExt</code> by adding the proper description to your <code>Package.swift</code> file:

<pre><code class="swift language-swift">import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.1.0"),
    ]
)
</code></pre>

<p>Note that the <a href="https://swift.org/package-manager">Swift Package Manager</a> is still in early design and development, for more information checkout its <a href="https://github.com/apple/swift-package-manager">GitHub Page</a></p>

## What is included?

The extensions are grouped in 3 modules, `AsyncExt`, `FluentExt` and `ServiceExt`, and the `VaporExt` which acts as a helper to export the extensions included in the previous packages.

### AsyncExt

- New Future methods:
  - `true(or error:)`
  - `false(or error:)`
  - `greater(than value:)`
  - `greater(than value:, or error:)`
  - `greaterOrEqual(to value:)`
  - `greaterOrEqual(to value:, or error:)`
  - `less(than value:)`
  - `less(than value:, or error:)`
  - `lessOrEqual(to value:)`
  - `lessOrEqual(to value:, or error:)`
  - `equal(to value:)`
  - `equal(to value:, or error:)`
  - `notEqual(to value:)`
  - `notEqual(to value:, or error:)`

### FluentExt

- New Model functions:
  - `query(by:, on:, withSoftDeleted:)` to create a query for the model and apply a filter of criteria.
  - `findAll(sortBy:, on:, withSoftDeleted:)` to find all models and apply some sorting criteria.
  - `find(by:, sortBy:, on:, withSoftDeleted:)` to find models and apply some filters and sorting criteria.
  - `findOne(by:, on:, withSoftDeleted:)` to find first model that matches the filters criteria.
  - `count(on:, withSoftDeleted:)` to count the number of registers of the model.
  - `count(by:, on:, withSoftDeleted:)` to count the number of registers of the model that matches some criteria.
- New Binary operators:
  - `!~=` for not has suffix comparison
  - `!=~` for not has prefix comparison
  - `!~~` for not contains comparison
- New filter methods:
  - `filter(keyPath:, at parameter:, on req:)` to handle automatic filters based in query params
- New sort methods:
  - `sort(keyPath:, at queryParam:, as parameter:, default direction:, on req:)` to handle automatic sorting based in query params
  - `sort(keyPath:, as parameter:, default direction:, on req:)` to handle automatic sorting based in query params
- New Request extensions to build FilterOperator and QuerySort from query params (Usefull if you use a Repository system):
  - `filter(keyPath:, at parameter:)` to build FilterOperator based in query params
  - `sort(keyPath:, at queryParam:, as parameter:)` to build QuerySort based in query params
  - `sort(keyPath:, at queryParam:, as parameter:, default direction:)` to build QuerySort based in query params
  - `sort(keyPath:, as parameter:)` to build QuerySort based in query params
  - `sort(keyPath:, as parameter:, default direction:)` to build QuerySort based in query params

#### Query params syntax for filters:

You can set the filter method with this format `parameter=method:value` and the new filter method will build the filter based on the `method`, example:

- `username=example@domain.com` or `username=eq:example@domain.com` will use `equal` comparison.
- `username=neq:example@domain.com` will use `not equal` comparison.
- `username=in:example@domain.com,other@domain.com` will use `in` comparison.
- `username=nin:example@domain.com,other@domain.com` will use `not in` comparison.
- `price=gt:3000` will use `greater than` comparison.
- `price=gte:3000` will use `greater than or equal` comparison.
- `price=lt:3000` will use `less than` comparison.
- `price=lte:3000` will use `less than or equal` comparison.
- `username=sw:example` will filter using `starts with` comparison.
- `username=nsw:example` will filter using `not starts with` comparison.
- `username=ew:domain.com` will filter using `ends with` comparison.
- `username=new:domain.com` will filter using `not ends with` comparison.
- `username=ct:domain.com` will filter using `contains` comparison.
- `username=nct:domain.com` will filter using `not contains` comparison.

```swift
return try User.query(on: req)
            .filter(\User.username, at: "username", on: req)
            .filter(\User.enabled, at: "enabled", on: req)
            .filter(\User.createdAt, at: "created_at", on: req)
            .filter(\User.updatedAt, at: "updated_at", on: req)
            .filter(\User.deletedAt, at: "deleted_at", on: req)
```

#### Query params syntax for sorting:

You can set the sorts methods with this format `sort=field:direction,field:direction` and the new sort method will build the query based on that configuration, for example

- With `sort=username:asc,created_at:desc` you can get you users sorted by username with ASC direction and firstname in DESC direction

```swift
return try User.query(on: req)
            .sort(\User.username, as: "username", on: req)
            .sort(\User.createdAt, as: "created_at", default: .ascending, on: req) // if created_at is not present in the url, then the sort is applied using the default direction
```

#### Request extensions example:

```swift
func index(_ req: Request) throws -> Future<[User]> {
    let repository = try req.make(UserRepository.self)

    let criteria: [FilterOperator<User.Database, User>] = try [
        req.filter(\User.name, at: "name"),
        req.filter(\User.username, at: "username"),
        req.filter(\User.enabled, at: "enabled")
    ].compactMap { $0 }

    var sort: [User.Database.QuerySort] = try [
        req.sort(\User.name, as: "name"),
        req.sort(\User.username, as: "username"),
        req.sort(\User.createdAt, as: "created_at"),
    ].compactMap { $0 }

    if sort.isEmpty {
        let defaultSort = try req.sort(\User.name, as: "name", default: .ascending)
        sort.append(defaultSort)
    }

    return repository.findBy(criteria: criteria, orderBy: sort, on: req)
}
```

### ServiceExt

- New Enviroment methods:
  - New method `dotenv(filename:)` to add `.env`support!
  - New generic `get(_ key:)` method to get values as Int and Bool
  - New generic `get(_ key:, _ fallback:)` method to get values as Int and Bool and String, with a fallback values

### VaporExt

- New Future methods:
  - new `toResponse(on req:, as status:, contentType:)` to transform a Future<Encodable> to a Future<Response>

## Get involved:

We want your feedback.
Please refer to [contributing guidelines](https://github.com/vapor-community/vapor-ext/tree/master/CONTRIBUTING.md) before participating.

## Discord Channel:

It is always nice to talk with other people using VaporExt and exchange experiences, so come [join our Discord channel](http://vapor.team).

## Credits

This package is developed and maintained by [Gustavo Perdomo](https://github.com/gperdomor) with the collaboration of all vapor community.

## License

VaporExt is released under an MIT license. See [license](license) for more information.

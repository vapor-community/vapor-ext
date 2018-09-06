// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "VaporExt",
    products: [
        .library(name: "AsyncExt", targets: ["AsyncExt"]),
        .library(name: "FluentExt", targets: ["FluentExt"]),
        .library(name: "ServiceExt", targets: ["ServiceExt"]),
        .library(name: "VaporExt", targets: ["VaporExt"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/gperdomor/vapor.git", from: "3.0.0"),
        // 🌎 Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging.
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
        // 🖋 Swift ORM framework (queries, models, and relations) for building NoSQL and SQL database integrations.
        .package(url: "https://github.com/vapor/fluent.git", from: "3.0.0"),
        // 📦 Dependency injection / inversion of control framework.
        .package(url: "https://github.com/vapor/service.git", from: "1.0.0"),
    ],
    targets: [
        // AsyncExt
        .target(name: "AsyncExt", dependencies: ["Async"]),
        .testTarget(name: "AsyncExtTests", dependencies: ["AsyncExt"]),

        // FluentExt
        .target(name: "FluentExt", dependencies: ["Fluent", "FluentSQL", "Debugging", "Vapor"]),
        .testTarget(name: "FluentExtTests", dependencies: ["FluentExt"]),

        // ServiceExt
        .target(name: "ServiceExt", dependencies: ["Service"]),
        .testTarget(name: "ServiceExtTests", dependencies: ["ServiceExt"]),

        .target(name: "VaporExt", dependencies: ["AsyncExt", "FluentExt", "ServiceExt"]),
        .testTarget(name: "VaporExtTests", dependencies: ["VaporExt"]),
    ]
)

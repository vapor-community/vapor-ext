// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "VaporExt",
    products: [
        .library(name: "AsyncExt",targets: ["AsyncExt"]),
        .library(name: "VaporExt",targets: ["VaporExt"]),
    ],
    dependencies: [
        // 🌎 Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging.
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0"),
    ],
    targets: [
        // AsyncExt
        .target(name: "AsyncExt", dependencies: ["Async"]),
        .testTarget(name: "AsyncExtTests", dependencies: ["AsyncExt"]),

        // VaporExt
        .target(name: "VaporExt", dependencies: ["AsyncExt"]),
        .testTarget(name: "VaporExtTests", dependencies: ["VaporExt"]),
    ]
)

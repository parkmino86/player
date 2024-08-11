// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "database",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "database",
            targets: ["database"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/groue/GRDB.swift.git",
            branch: "master"
        ),
    ],
    targets: [
        .target(
            name: "database",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "databaseTests",
            dependencies: ["database"],
            path: "Tests"
        ),
    ]
)

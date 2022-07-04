// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "fluent-postgis",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        // FluentPostgreSQL support for PostGIS
        .library(
            name: "FluentPostGIS",
            targets: ["FluentPostGIS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.24.0"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.1.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.3.1"),

        // Well Known Binary Encoding and Decoding
        .package(url: "https://github.com/plarson/WKCodable", from: "0.1.1"),
    ],
    targets: [
        .target(
            name: "FluentPostGIS",
            dependencies: ["FluentKit", "FluentPostgresDriver", "WKCodable"]),
        .testTarget(
            name: "FluentPostGISTests",
            dependencies: [.target(name: "FluentPostGIS"),
                           .product(name: "FluentBenchmark", package: "fluent-kit")]),
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRequestBuilder",
    platforms: [
        .iOS(.v10), .macOS(.v10_10), .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftRequestBuilder",
            targets: ["SwiftRequestBuilder"]
        ),
        .library(
            name: "SwiftRequestBuilderTestHelpers", 
            targets: ["SwiftRequestBuilderTestHelpers"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftRequestBuilder",
            dependencies: [],
            path: "Sources"
        ),
        .target(
            name: "SwiftRequestBuilderTestHelpers",
            dependencies: ["SwiftRequestBuilder"],
            path: "TestHelpers"),
        .testTarget(
            name: "SwiftRequestBuilderTests",
            dependencies: ["SwiftRequestBuilder", "SwiftRequestBuilderTestHelpers"],
            path: "Tests"
        )
    ]
)

// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day20",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "day20",
            targets: ["day20"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "utils", path: "../../utils"),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.4")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "day20",
            dependencies: ["utils"]
        ),
        .testTarget(
            name: "day20Tests",
            dependencies: ["day20", "utils", .product(name: "Collections", package: "swift-collections")],
            resources: [
                .copy("sample.txt"),
                .copy("real.txt"),
            ]
        ),
    ]
)

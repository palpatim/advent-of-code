// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day08",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "day08",
            targets: ["day08"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "utils", path: "../../utils"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "day08",
            dependencies: ["utils"]
        ),
        .testTarget(
            name: "day08Tests",
            dependencies: ["day08", "utils"],
            resources: [
                .copy("sample.txt"),
                .copy("real.txt"),
            ]
        ),
    ]
)

// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day01",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "day01",
            targets: ["day01"]
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
            name: "day01",
            dependencies: ["utils"]
        ),
        .testTarget(
            name: "day01Tests",
            dependencies: ["day01", "utils"],
            resources: [
                .copy("part1.sample.txt"),
                .copy("part1.real.txt"),
                .copy("part2.sample.txt"),
                .copy("part2.real.txt"),
            ]
        ),
    ]
)

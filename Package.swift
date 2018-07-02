// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Xorswift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Xorswift",
            targets: ["Xorswift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/t-ae/rng-extension.git", from: "1.1.0-alpha.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Xorswift",
            dependencies: ["RNGExtension"],
            path: "Sources"),
        .testTarget(
            name: "XorswiftTests",
            dependencies: ["Xorswift"]),
    ]
)

// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Xorswift",
    targets: [
        Target(name: "Xorswift", dependencies: ["Cxorswift"])
    ]
)

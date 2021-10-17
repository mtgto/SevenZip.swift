// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LZMA",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LZMA",
            targets: ["LZMA"]),
    ],
    targets: [
        .target(
            name: "LZMA",
            dependencies: ["CLZMA"]),
        .target(
            name: "CLZMA"
        ),
        .testTarget(
            name: "LZMATests",
            dependencies: ["LZMA"]),
    ]
)

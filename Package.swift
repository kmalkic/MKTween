// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKTween",
    platforms: [
        .macOS("10.60"),
        .tvOS(.v12),
        .iOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "MKTween",
            targets: ["MKTween"]),
    ],
    targets: [
        .target(
            name: "MKTween",
            path: "MKTween"
        ),
    ]
)

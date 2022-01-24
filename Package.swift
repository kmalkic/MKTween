// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKTween",
    platforms: [.iOS("12.0"), .macOS("10.60"), .tvOS("11.0")],
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

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKTween",
    products: [
        .library(
            name: "MKTween",
            targets: ["MKTween"]),
    ],
    targets: [
        .target(
            name: "MKTween",
            path: "MKTween",
            exclude: ["Info.plist", "MKTween.h"]
        ),
    ]
)

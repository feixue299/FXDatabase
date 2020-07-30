// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FXDatabase",
    products: [
    .library(name: "FXDatabase", targets: ["FXDatabase"])
    ],
    dependencies: [
        .package(name: "FMDB", url: "https://github.com/ccgus/fmdb", .upToNextMinor(from: "2.7.7")),
    ],
    targets: [
        .target(
            name: "FXDatabase",
            dependencies: ["FMDB"],
            publicHeadersPath: "."),
    ]
)

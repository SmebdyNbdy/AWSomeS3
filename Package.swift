// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AWSomeS3",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AWSomeS3",
            targets: ["AWSomeS3"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "AWSomeS3",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]),
        .testTarget(
            name: "AWSomeS3Tests",
            dependencies: ["AWSomeS3"]),
    ]
)

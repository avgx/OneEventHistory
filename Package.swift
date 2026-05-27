// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "OneEventHistory",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "OneEventHistory",
            targets: ["OneEventHistory"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/RequestResponse", from: "2.0.1"),
        .package(url: "https://github.com/avgx/SafeEnum", from: "1.0.0"),
        .package(url: "https://github.com/avgx/OneWireFormat", from: "1.0.2"),
        .package(url: "https://github.com/avgx/JSONValue", from: "1.0.0"),
        .package(url: "https://github.com/avgx/EncodeDecode", from: "1.0.5"),
        .package(url: "https://github.com/avgx/Get", branch: "dev"),
    ],
    targets: [
        .target(
            name: "OneEventHistory",
            dependencies: [
                .product(name: "RequestResponse", package: "RequestResponse"),
                .product(name: "SafeEnum", package: "SafeEnum"),
                .product(name: "OneWireFormat", package: "OneWireFormat"),
                .product(name: "JSONValue", package: "JSONValue"),
            ]
        ),
        .testTarget(
            name: "OneEventHistoryTests",
            dependencies: [
                "OneEventHistory",
                .product(name: "RequestResponse", package: "RequestResponse"),
                .product(name: "EncodeDecode", package: "EncodeDecode"),
                .product(name: "HTTP", package: "Get"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)

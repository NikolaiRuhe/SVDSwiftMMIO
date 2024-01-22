// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVDSwiftMMIO",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "SVDSwiftMMIO", targets: ["SVDSwiftMMIO"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.2"),
    ],
    targets: [
        .target(
            name: "SVD"),
        .executableTarget(
            name: "SVDSwiftMMIO",
            dependencies: [
                "SVD",
                "MMIOMacros",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
            ]
        ),
        .target(name: "MMIOMacros", dependencies: [
            "MMIOUtilities",
            .product(name: "SwiftSyntax", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftDiagnostics", package: "swift-syntax"),
            .product(name: "SwiftSyntaxMacroExpansion", package: "swift-syntax"),
        ]),
        .target(name: "MMIOUtilities"),
        .testTarget(
            name: "SVDTests",
            dependencies: ["SVD", "SVDSwiftMMIO"]),
    ]
)

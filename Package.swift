// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "EnumMacros",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "EnumMacros",
            targets: ["EnumMacros"]
        ),
        .executable(
            name: "EnumMacrosClient",
            targets: ["EnumMacrosClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.4.0")
    ],
    targets: [
        .macro(
            name: "EnumMacrosImplementation",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "EnumMacros", dependencies: ["EnumMacrosImplementation"]),
        .executableTarget(name: "EnumMacrosClient", dependencies: ["EnumMacros"]),
        .testTarget(
            name: "EnumMacrosTests",
            dependencies: [
                "EnumMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing"),
            ]
        ),
    ]
)

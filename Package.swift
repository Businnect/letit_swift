// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LetIt",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LetIt",
            targets: ["LetIt"]
        )
    ],
    targets: [
        .target(
            name: "LetIt"
        ),
        .testTarget(
            name: "LetItTests",
            dependencies: ["LetIt"]
        )
    ]
)

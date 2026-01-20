// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZenCards",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ZenCards",
            targets: ["ZenCards"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/open-spaced-repetition/swift-fsrs", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "ZenCards",
            dependencies: [
                .product(name: "FSRS", package: "swift-fsrs")
            ]
        )
    ]
)

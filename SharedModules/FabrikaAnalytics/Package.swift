// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FabrikaAnalytics",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "FabrikaAnalytics",
            targets: ["FabrikaAnalytics"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/amplitude/Amplitude-iOS", from: "8.17.0"),
        .package(url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework", from: "6.12.0")
    ],
    targets: [
        .target(
            name: "FabrikaAnalytics",
            dependencies: [
                .product(name: "Amplitude", package: "Amplitude-iOS"),
                .product(name: "AppsFlyerLib", package: "AppsFlyerFramework")
            ],
            path: "Sources/FabrikaAnalytics"
        ),
        .testTarget(
            name: "FabrikaAnalyticsTests",
            dependencies: ["FabrikaAnalytics"],
            path: "Tests/FabrikaAnalyticsTests"
        )
    ]
)

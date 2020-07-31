// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "UtiliKit",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(
            name: "UtiliKit",
            targets: ["UtiliKit"])
    ],
    targets: [
        .target(
            name: "UtiliKit",
            path: "Sources"),
        .testTarget(
            name: "UtiliKitTests",
            path: "Tests")
    ]
)

// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "UtiliKit",
    platforms: [
        .iOS("11.0")
    ],
    products: [
        .library(
            name: "UtiliKit",
            targets: ["Instantiate", "TimelessDate", "General", "Version", "Container", "ActiveLabel", "Obfuscation"]),
        .library(
            name: "UtiliKit-Container",
            targets: ["Container"]),
        .library(
            name: "UtiliKit-Core",
            targets: ["Instantiate", "General"]),
        ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            from: "1.9.0")
        ],
    targets: [
        .target(
            name: "General",
            dependencies: [],
            path: "Sources/UtiliKit/General"),
        .target(
            name: "Instantiate",
            dependencies: [],
            path: "Sources/UtiliKit/Instantiation"),
        .target(
            name: "TimelessDate",
            dependencies: [],
            path: "Sources/UtiliKit/TimelessDate"),
        .target(
            name: "Version",
            dependencies: [],
            path: "Sources/UtiliKit/Version"),
        .target(
            name: "Container",
            dependencies: [],
            path: "Sources/UtiliKit/Container"),
        .target(
            name: "ActiveLabel",
            dependencies: [],
            path: "Sources/UtiliKit/ActiveLabel"),
        .target(
            name: "Obfuscation",
            dependencies: [],
            path: "Sources/UtiliKit/Obfuscation"),
        .testTarget(
            name: "UtiliKitTests",
            dependencies: ["Instantiate", "TimelessDate", "General", "Version", "Container", "ActiveLabel", "Obfuscation", "SnapshotTesting"],
            path: "Tests")
    ]
)


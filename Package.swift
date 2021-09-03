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
            targets: ["GeneralUtilities", "InstantiationUtilities", "TimelessDate", "VersionUtilities", "ContainerViewController", "ActiveLabel", "ObfuscationUtilities"]),
        .library(
            name: "UtiliKitContainer",
            targets: ["ContainerViewController"]),
        .library(
            name: "UtiliKitCore",
            targets: ["InstantiationUtilities", "GeneralUtilities"]),
        ],
    targets: [
        .target(
            name: "GeneralUtilities",
            path: "Sources/UtiliKit/General"),
        .target(
            name: "InstantiationUtilities",
            path: "Sources/UtiliKit/Instantiation"),
        .target(
            name: "TimelessDate",
            path: "Sources/UtiliKit/TimelessDate"),
        .target(
            name: "VersionUtilities",
            path: "Sources/UtiliKit/Version"),
        .target(
            name: "ContainerViewController",
            path: "Sources/UtiliKit/Container"),
        .target(
            name: "ActiveLabel",
            path: "Sources/UtiliKit/ActiveLabel"),
        .target(
            name: "ObfuscationUtilities",
            path: "Sources/UtiliKit/Obfuscation")
    ]
)


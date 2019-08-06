// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "UtiliKit",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(
            name: "UtiliKit-General",
            targets: ["UtiliKit-General"]),
        .library(
            name: "UtiliKit-Instantiation",
            targets: ["UtiliKit-Instantiation"]),
        .library(
            name: "UtiliKit-TimelessDate",
            targets: ["UtiliKit-TimelessDate"]),
        .library(
            name: "UtiliKit-Version",
            targets: ["UtiliKit-Version"]),
        .library(
            name: "UtiliKit-Container",
            targets: ["UtiliKit-Container"]),
        .library(
            name: "UtiliKit-ActiveLabel",
            targets: ["UtiliKit-ActiveLabel"]),
        .library(
            name: "UtiliKit-Obfuscation",
            targets: ["UtiliKit-Obfuscation"]),
    ],
    targets: [
        .target(
            name: "UtiliKit-General",
            path: "Sources/UtiliKit/General"),
        .target(
            name: "UtiliKit-Instantiation",
            path: "Sources/UtiliKit/Instantiation"),
        .target(
            name: "UtiliKit-TimelessDate",
            path: "Sources/UtiliKit/TimelessDate"),
        .target(
            name: "UtiliKit-Version",
            path: "Sources/UtiliKit/Version"),
        .target(
            name: "UtiliKit-Container",
            path: "Sources/UtiliKit/Container"),
        .target(
            name: "UtiliKit-ActiveLabel",
            path: "Sources/UtiliKit/ActiveLabel"),
        .target(
            name: "UtiliKit-Obfuscation",
            path: "Sources/UtiliKit/Obfuscation"),
        .testTarget(
            name: "UtiliKitTests",
            dependencies: ["UtiliKit-General",
                            "UtiliKit-Instantiation",
                            "UtiliKit-TimelessDate",
                            "UtiliKit-Version",
                            "UtiliKit-Container",
                            "UtiliKit-ActiveLabel",
                            "UtiliKit-Obfuscation"],
            path: "Tests")
    ]
)

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
    targets: [
        .target(
            name: "General",
            path: "Sources/UtiliKit/General"),
        .target(
            name: "Instantiate",
            path: "Sources/UtiliKit/Instantiation"),
        .target(
            name: "TimelessDate",
            path: "Sources/UtiliKit/TimelessDate"),
        .target(
            name: "Version",
            path: "Sources/UtiliKit/Version"),
        .target(
            name: "Container",
            path: "Sources/UtiliKit/Container"),
        .target(
            name: "ActiveLabel",
            path: "Sources/UtiliKit/ActiveLabel"),
        .target(
            name: "Obfuscation",
            path: "Sources/UtiliKit/Obfuscation")
    ]
)


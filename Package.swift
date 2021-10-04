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
            targets: ["GeneralUtilities", "Instantiation", "TimelessDate", "Versioning", "Container", "ActiveLabel", "Obfuscation"]),
        .library(
            name: "GeneralUtilities",
            targets: ["GeneralUtilities"]),
        .library(
            name: "Instantiation",
            targets: ["Instantiation"]),
        .library(
            name: "TimelessDate",
            targets: ["TimelessDate"]),
        .library(
            name: "Versioning",
            targets: ["Versioning"]),
        .library(
            name: "Container",
            targets: ["Container"]),
        .library(
            name: "ActiveLabel",
            targets: ["ActiveLabel"]),
        .library(
            name: "Obfuscation",
            targets: ["Obfuscation"]),
        ],
    targets: [
        .target(
            name: "GeneralUtilities",
            path: "Sources/UtiliKit/General"),
        .target(
            name: "Instantiation",
            path: "Sources/UtiliKit/Instantiation"),
        .target(
            name: "TimelessDate",
            path: "Sources/UtiliKit/TimelessDate"),
        .target(
            name: "Versioning",
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


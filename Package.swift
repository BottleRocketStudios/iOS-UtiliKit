// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "UtiliKit",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(
            name: "UtiliKit",
            targets: ["GeneralUtilities", "Instantiation", "TimelessDate", "Versioning",
                      "ContainerViewController", "ActiveLabel", "Obfuscation", "ScrollingPageControl"]),
        .library(name: "GeneralUtilities", targets: ["GeneralUtilities"]),
        .library(name: "Instantiation", targets: ["Instantiation"]),
        .library(name: "TimelessDate", targets: ["TimelessDate"]),
        .library(name: "Versioning", targets: ["Versioning"]),
        .library(name: "ContainerViewController", targets: ["ContainerViewController"]),
        .library(name: "ActiveLabel", targets: ["ActiveLabel"]),
        .library(name: "Obfuscation", targets: ["Obfuscation"]),
        .library(name: "ScrollingPageControl", targets: ["ScrollingPageControl"])
        ],
    targets: [
        .target(name: "GeneralUtilities", path: "Sources/General"),
        .target(name: "Instantiation", path: "Sources/Instantiation"),
        .target(name: "TimelessDate", path: "Sources/TimelessDate"),
        .target(name: "Versioning", path: "Sources/Version"),
        .target(name: "ContainerViewController", path: "Sources/Container"),
        .target(name: "ActiveLabel", path: "Sources/ActiveLabel"),
        .target(name: "Obfuscation", path: "Sources/Obfuscation"),
        .target(name: "ScrollingPageControl", dependencies: [.target(name: "GeneralUtilities")], path: "Sources/ScrollingPageControl")
    ]
)


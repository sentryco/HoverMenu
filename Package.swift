// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HoverMenu",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "HoverMenu",
            targets: ["HoverMenu"])
    ],
    targets: [
        .target(
            name: "HoverMenu"),
        .testTarget(
            name: "HoverMenuTests",
            dependencies: ["HoverMenu"])
    ]
)

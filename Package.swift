// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "QuickTableView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "QuickTableView",
            targets: ["QuickTableView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/lionheart/KeyboardAdjuster.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "QuickTableView",
            dependencies: [
                .product(name: "KeyboardAdjuster", package: "KeyboardAdjuster")
            ],
            path: "Pod",
            sources: ["Classes", "Extensions", "Protocols"]
        ),
        .testTarget(
            name: "QuickTableViewTests",
            dependencies: ["QuickTableView"]
        ),
    ],
    swiftLanguageModes: [.v4]
)

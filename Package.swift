// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WorkTimeFocus",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "WorkTimeFocus",
            targets: ["WorkTimeFocus"]
        ),
        .library(
            name: "WorkTimeFocusKit",
            targets: ["WorkTimeFocusKit"]
        )
    ],
    targets: [
        .executableTarget(
            name: "WorkTimeFocus",
            dependencies: ["WorkTimeFocusKit"],
            path: "Sources/WorkTimeFocus"
        ),
        .target(
            name: "WorkTimeFocusKit",
            path: "Sources/WorkTimeFocusKit"
        )
    ]
)

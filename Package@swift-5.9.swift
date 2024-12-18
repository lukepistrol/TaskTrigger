// swift-tools-version: 5.9

import PackageDescription

let taskTrigger = "TaskTrigger"

let package = Package(
    name: taskTrigger,
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15),
        .macCatalyst(.v15),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: taskTrigger,
            targets: [
                taskTrigger,
            ]
        ),
    ],
    targets: [
        .target(
            name: taskTrigger
        ),
    ]
)

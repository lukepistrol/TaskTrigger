// swift-tools-version: 5.8

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
    ],
    products: [
        .library(
            name: taskTrigger,
            targets: [taskTrigger]
        ),
    ],
    targets: [
        .target(
            name: taskTrigger
        ),
    ]
)

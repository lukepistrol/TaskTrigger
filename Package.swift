// swift-tools-version: 6.0

import PackageDescription

let taskTrigger = "TaskTrigger"
let taskTriggerUI = "TaskTriggerUI"

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
            targets: [taskTrigger]
        ),
        .library(
            name: taskTriggerUI,
            targets: [taskTriggerUI]
        )
    ],
    targets: [
        .target(
            name: taskTrigger
        ),
        .target(
            name: taskTriggerUI,
            dependencies: [
                .target(name: taskTrigger)
            ]
        )
    ]
)

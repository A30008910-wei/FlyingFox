// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "FlyingFox",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "FlyingFox",
            targets: ["FlyingFox"]
        ),
        .library(
            name: "FlyingSocks",
            targets: ["FlyingSocks"]
        )
    ],
    targets: [
        .target(
            name: "FlyingFox",
            dependencies: ["FlyingSocks"],
            path: "FlyingFox/Sources",
            swiftSettings: .upcomingFeatures
        ),
        .target(
            name: "FlyingSocks",
            dependencies: [.target(name: "CSystemLinux", condition: .when(platforms: [.linux]))],
            path: "FlyingSocks/Sources",
            swiftSettings: .upcomingFeatures
        ),
        .target(
             name: "CSystemLinux",
             path: "CSystemLinux"
        )
    ] + .testingTargets
)

extension Array where Element == SwiftSetting {

    static var upcomingFeatures: [SwiftSetting] {
        [
            .enableUpcomingFeature("ExistentialAny"),
            .swiftLanguageMode(.v6)
        ]
    }
}

extension [PackageDescription.Target] {
    static var testingTargets: [PackageDescription.Target] {
    #if canImport(Darwin) || compiler(>=6.1)
        [
            .testTarget(
                name: "FlyingFoxTests",
                dependencies: ["FlyingFox"],
                path: "FlyingFox/Tests",
                resources: [
                    .copy("Stubs")
                ],
                swiftSettings: .upcomingFeatures
            ),
            .testTarget(
                name: "FlyingSocksTests",
                dependencies: ["FlyingSocks"],
                path: "FlyingSocks/Tests",
                resources: [
                    .copy("Resources")
                ],
                swiftSettings: .upcomingFeatures
            )
        ]
        #else
        [
            .testTarget(
                name: "FlyingFoxXCTests",
                dependencies: ["FlyingFox"],
                path: "FlyingFox/XCTests",
                resources: [
                    .copy("Stubs")
                ],
                swiftSettings: .upcomingFeatures
            ),
            .testTarget(
                name: "FlyingSocksXCTests",
                dependencies: ["FlyingSocks"],
                path: "FlyingSocks/XCTests",
                resources: [
                    .copy("Resources")
                ],
                swiftSettings: .upcomingFeatures
            )
        ]
        #endif
    }
}

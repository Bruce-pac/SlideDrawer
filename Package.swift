// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SlideDrawer",
    platforms: [.iOS(.v9)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SlideDrawer",
            targets: ["SlideDrawer"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SlideDrawer",
            path: "SlideDrawer/Classes"),
        .testTarget(
            name: "SlideDrawer_Tests",
            dependencies: ["SlideDrawer"],
            path: "Example/Tests"),
    ],
    swiftLanguageVersions: [.v4_2, .v5]
)

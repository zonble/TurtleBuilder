// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TurtleBuilder",
    products: [
        .library(
            name: "TurtleBuilder",
            targets: ["TurtleBuilder", "TurtleView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TurtleBuilder",
            dependencies: []),
		.target(
			name: "TurtleView",
			dependencies: ["TurtleBuilder"]),
		.testTarget(
            name: "TurtleBuilderTests",
            dependencies: ["TurtleBuilder"]),
    ]
)

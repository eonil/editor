// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "pconf",
    dependencies: [
        .Package(url: "https://github.com/carambalabs/xcodeproj.git", Version(0, 0, 3)),
        .Package(url: "https://github.com/tomlokhorst/XcodeEdit.git", Version(1, 1, 0)),
        ]
)

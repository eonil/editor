import PackageDescription

let package = Package(
    name: "Editor6DepPack",
    dependencies: [
//        .Package(url: "https://github.com/eonil/flow.swift.git", Version(0, 0, 3)),
        .Package(url: "https://github.com/eonil/flow.swift.git", majorVersion: 0),
        .Package(url: "https://github.com/eonil/flow4.swift.git", majorVersion: 0),
        .Package(url: "https://github.com/eonil/fsevents-unofficial-wrapper.git", majorVersion: 0),
        .Package(url: "https://github.com/eonil/reftable.swift.git", majorVersion: 0),
        .Package(url: "https://github.com/lorentey/BTree", Version(4, 0, 1)),
        .Package(url: "https://github.com/eonil/gcd-actor.swift.git", Version(0, 0, 5)),
    ]
)

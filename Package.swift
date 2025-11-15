// swift-tools-version:5.10
import PackageDescription
import Foundation
let package = Package(
    name: "PWA-Kit",
    // PWA-Kit: The macOS toolkit for progressive web apps
    // Targeting macOS 14 (Sonoma) with Swift 5.10 for modern PWA support
    // Swift 6.0 strict concurrency will be adopted in Phase 1.5
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "PWAKit", type: .dynamic, targets: ["PWAKit"]),
        .executable(name: "PWAKit_static", targets: ["PWAKit_static"]),
        .executable(name: "PWAKit_stub", targets: ["PWAKit_stub"]),
        .executable(name: "iconify", targets: ["iconify"]),
    ],
    dependencies: [
        .package(path: "modules/Linenoise"),
        .package(path: "modules/UTIKit"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .systemLibrary(
            name: "WebKitPrivates",
            path: "modules/WebKitPrivates"
        ),
        .systemLibrary(
            name: "ViewPrivates",
            path: "modules/ViewPrivates"
        ),
        .systemLibrary(
            name: "UserNotificationPrivates",
            path: "modules/UserNotificationPrivates"
        ),
        .systemLibrary(
            name: "JavaScriptCorePrivates",
            path: "modules/JavaScriptCorePrivates"
        ),
    ]
)
if let iosvar = ProcessInfo.processInfo.environment["PWAKIT_IOS"], !iosvar.isEmpty {
    package.platforms = [.iOS(.v13)]
    package.products = [ .executable(name: "PWAKit", targets: ["PWAKit"]) ]
    package.targets.append(
        .executableTarget(
            name: "PWAKit",
            dependencies: [
                "WebKitPrivates",
                "JavaScriptCorePrivates",
                "ViewPrivates",
                "UserNotificationPrivates",
                "Linenoise",
                "UTIKit",
            ],
            path: "Sources/MacPinIOS"
        )
    )
} else {
    package.targets.append(contentsOf: [
        .executableTarget(
            name: "iconify",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Tools/iconify"
        ),
        .target(name: "PWAKit",
            dependencies: [
                "WebKitPrivates",
                "JavaScriptCorePrivates",
                "ViewPrivates",
                "UserNotificationPrivates",
                "Linenoise",
                "UTIKit",
            ],
            path: "Sources/MacPinOSX"
        ),
        .executableTarget(
            name: "PWAKit_static",
            dependencies: [
                .target(name: "PWAKit")
            ]
        ),
        .executableTarget(
            name: "PWAKit_stub",
            dependencies: [],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-rpath", "-Xlinker", "@loader_path:@loader_path/../Frameworks"])
            ]
        )
    ])
}

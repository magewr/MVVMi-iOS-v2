// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MVVMi-v2",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Presentation", targets: ["Presentation"])
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0")
    ],
    targets: [
        // MARK: - Domain Layer
        .target(
            name: "Domain",
            dependencies: [],
            path: "Projects/Domain/Sources",
            swiftSettings: [
                .define("IOS_ONLY"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "DomainTests",
            dependencies: ["Domain"],
            path: "Projects/Domain/Tests"
        ),
        
        // MARK: - Data Layer  
        .target(
            name: "Data",
            dependencies: [
                "Domain",
                .product(name: "Moya", package: "Moya")
            ],
            path: "Projects/Data/Sources",
            swiftSettings: [
                .define("IOS_ONLY"),
                .enableExperimentalFeature("StrictConcurrency"),
                .unsafeFlags(["-Xfrontend", "-warn-concurrency"])
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data",
                "Domain",
                .product(name: "Moya", package: "Moya")
            ],
            path: "Projects/Data/Tests"
        ),
        
        // MARK: - Presentation Layer
        .target(
            name: "Presentation", 
            dependencies: [
                "Domain"
            ],
            path: "Projects/Presentation/Sources",
            swiftSettings: [
                .define("IOS_ONLY"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "PresentationTests",
            dependencies: [
                "Presentation",
                "Domain"
            ],
            path: "Projects/Presentation/Tests"
        )
    ]
) 
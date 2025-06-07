import ProjectDescription

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.mvvmi.v2.domain",
            deploymentTargets: .iOS("15.0"),
            sources: ["Sources/**"],
            dependencies: []
        ),
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.mvvmi.v2.domain.tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        )
    ]
)
import ProjectDescription

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.mvvmi.v2.presentation",
            deploymentTargets: .iOS("15.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        ),
        .target(
            name: "PresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.mvvmi.v2.presentation.tests",
            deploymentTargets: .iOS("15.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Presentation"),
                .project(target: "Domain", path: "../Domain")
            ]
        )
    ]
)
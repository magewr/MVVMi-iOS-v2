import ProjectDescription

let project = Project(
    name: "MVVMi-v2",
    targets: [
        .target(
            name: "MVVMi-v2",
            destinations: .iOS,
            product: .app,
            bundleId: "com.mvvmi.v2",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "철학 명언",
                    "UILaunchScreen": [:],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data"),
                .project(target: "Presentation", path: "../Presentation")
            ]
        ),
        .target(
            name: "MVVMi-v2Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.mvvmi.v2.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MVVMi-v2")
            ]
        )
    ]
)
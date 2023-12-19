import ProjectDescription

/// 참고 사이트
/// https://cheonsong.tistory.com/15

// 프로젝트 생성자 생성
extension Project {
    
    static let bundleID = "com.JMT-iOS"
    static let iosVersion = "14.0"
    
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return self.project(
            name: name,
            product: .app,
            bundleID: bundleID + "\(name)",
            dependencies: dependencies,
            resources: resources
        )
    }
}

extension Project {
    public static func framework(name: String,
                                 dependencies: [TargetDependency] = [],
                                 resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return .project(name: name,
                        product: .framework,
                        bundleID: bundleID + ".\(name)",
                        dependencies: dependencies,
                        resources: resources)
    }
    
    
    
    public static func project(
        name: String,
        product: Product,
        bundleID: String,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        return Project(
            name: name,
            targets: [
                Target(
                    name: name,
                    platform: .iOS,
                    product: product,
                    bundleId: bundleID,
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
                    infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
                    sources: ["Sources/**"],
                    resources: resources,
                    dependencies: dependencies
                ),
                Target(
                    name: "\(name)Tests",
                    platform: .iOS,
                    product: .unitTests,
                    bundleId: bundleID,
                    deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
                    infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(name)")
                    ]
                )
            ],
            schemes: schemes
        )
    }
}
















































///// Project helpers are functions that simplify the way you define your project.
///// Share code to create targets, settings, dependencies,
///// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
///// See https://docs.tuist.io/guides/helpers/
//
//extension Project {
//    /// Helper function to create the Project for this ExampleApp
//    public static func app(name: String, destinations: Destinations, additionalTargets: [String]) -> Project {
//        var targets = makeAppTargets(name: name,
//                                     destinations: destinations,
//                                     dependencies: additionalTargets.map { TargetDependency.target(name: $0) })
//        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, destinations: destinations) })
//        return Project(name: name,
//                       organizationName: "tuist.io",
//                       targets: targets)
//    }
//
//    // MARK: - Private
//
//    /// Helper function to create a framework target and an associated unit test target
//    private static func makeFrameworkTargets(name: String, destinations: Destinations) -> [Target] {
//        let sources = Target(name: name,
//                destinations: destinations,
//                product: .framework,
//                bundleId: "io.tuist.\(name)",
//                infoPlist: .default,
//                sources: ["Targets/\(name)/Sources/**"],
//                resources: [],
//                dependencies: [])
//        let tests = Target(name: "\(name)Tests",
//                destinations: destinations,
//                product: .unitTests,
//                bundleId: "io.tuist.\(name)Tests",
//                infoPlist: .default,
//                sources: ["Targets/\(name)/Tests/**"],
//                resources: [],
//                dependencies: [.target(name: name)])
//        return [sources, tests]
//    }
//
//    /// Helper function to create the application target and the unit test target.
//    private static func makeAppTargets(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
//        let infoPlist: [String: Plist.Value] = [
//            "CFBundleShortVersionString": "1.0",
//            "CFBundleVersion": "1",
//            "UILaunchStoryboardName": "LaunchScreen"
//            ]
//
//        let mainTarget = Target(
//            name: name,
//            destinations: destinations,
//            product: .app,
//            bundleId: "io.tuist.\(name)",
//            infoPlist: .extendingDefault(with: infoPlist),
//            sources: ["Targets/\(name)/Sources/**"],
//            resources: ["Targets/\(name)/Resources/**"],
//            dependencies: dependencies
//        )
//
//        let testTarget = Target(
//            name: "\(name)Tests",
//            destinations: destinations,
//            product: .unitTests,
//            bundleId: "io.tuist.\(name)Tests",
//            infoPlist: .default,
//            sources: ["Targets/\(name)/Tests/**"],
//            dependencies: [
//                .target(name: "\(name)")
//        ])
//        return [mainTarget, testTarget]
//    }
//}

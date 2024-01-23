//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by PKW on 2023/12/19.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies([
        .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .upToNextMajor(from: "2.8.0")),
        .remote(url: "https://github.com/Swinject/SwinjectStoryboard.git", requirement: .upToNextMajor(from: "2.2.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.8.1")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/jrendel/SwiftKeychainWrapper", requirement: .upToNextMajor(from: "4.0.0"))
    ],
                                                         productTypes: ["Swinject": .framework,
                                                                        "SwinjectStoryboard": .framework,
                                                                        "Alamofire": .framework,
                                                                        "Kingfisher": .framework,
                                                                        "SnapKit": .framework,
                                                                        "Then": .framework,
                                                                        "SwiftKeychainWrapper": .framework]),
    platforms: [.iOS]
)


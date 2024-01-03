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
        .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .upToNextMajor(from: "5.8.1"))
    ],
                                                         productTypes: ["Swinject": .framework,
                                                                        "SwinjectStoryboard": .framework,
                                                                        "Alamofire": .framework]),
    platforms: [.iOS]
)


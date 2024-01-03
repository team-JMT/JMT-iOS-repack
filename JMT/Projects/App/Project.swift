//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by PKW on 2023/12/19.
//

import ProjectDescription
import ProjectDescriptionHelpers

//let project = Project.app(name: "App",
//                          dependencies: [
//
//                          ].map(\.project),
//                          resources: .default)

let project = Project.app(name: "App",
                          dependencies: [.external(name: "Swinject"),
                                         .external(name: "SwinjectStoryboard"),
                                         .external(name: "Alamofire")],
                          resources: .default)


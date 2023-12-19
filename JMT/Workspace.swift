//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by PKW on 2023/12/19.
//
import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(name: "Projects",
                          projects: Module.allCases.map(\.path))

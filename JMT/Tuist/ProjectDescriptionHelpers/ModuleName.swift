//
//  ModuleName.swift
//  ProjectDescriptionHelpers
//
//  Created by PKW on 2023/12/19.
//
import ProjectDescription

// 모듈의 이름을 열거형으로 캡슐화 
public enum Module {
    case app
    
//    // Repository|DataStore
//    case data
//
//    // Presentation
//    case presentation
//
//    // Domain
//    case domain
//
//    // Design|UI
//    case designSystem
}

extension Module {
    public var name: String {
        switch self {
        case .app:
            return "App"
//        case .data:
//            return "Data"
//        case .presentation:
//            return "Presentation"
//        case .domain:
//            return "Domain"
//        case .designSystem:
//            return "DesignSystem"
        }
    }
    
    public var path: ProjectDescription.Path {
        return .relativeToRoot("Projects/" + self.name)
    }
    
    public var project: TargetDependency {
        return .project(target: self.name, path: self.path)
    }
}

extension Module: CaseIterable { }

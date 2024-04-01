//
//  DependencyInjector.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Swinject

protocol DependencyAsssemblable {
    func assemble(_ assemblyList: [Assembly])
}

typealias Injector = DependencyAsssemblable

final class DependencyInjector: Injector {
    
    static let shared = DependencyInjector()
    var container: Container = Container()
    private init() {}
    
    func assemble(_ assemblyList: [Swinject.Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
}

//
//  UIViewController+Ext.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit
import SwinjectStoryboard

extension UIViewController {
    static func instantiateFromStoryboard<T: UIViewController>(storyboardName: String) -> T {
        let storyboard = SwinjectStoryboard.create(name: storyboardName, bundle: nil, container: DependencyInjector.shared.container)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    }
}

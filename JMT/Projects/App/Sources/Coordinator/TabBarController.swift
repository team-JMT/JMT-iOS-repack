//
//  TabBarController.swift
//  JMTeng
//
//  Created by PKW on 2024/03/01.
//

import UIKit

class DefaultTabBarController: UITabBarController {
    
    var isHomeSearchButton: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
}

extension DefaultTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
           
        }
    }
}

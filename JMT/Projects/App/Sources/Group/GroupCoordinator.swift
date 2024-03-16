//
//  GroupCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol GroupCoordinator: Coordinator {
    
    func showDetailGroupPage(groupId: Int)
    
}

class DefaultGroupCoordinator: GroupCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .group
    
    init(navigationController: UINavigationController?, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
//    func start() {
//        let groupViewController = GroupViewController.instantiateFromStoryboard(storyboardName: "Group")
//        self.navigationController?.pushViewController(groupViewController, animated: true)
//    }
    
    func start() {
        let groupWebViewController = GroupWebViewController.instantiateFromStoryboard(storyboardName: "Group")
        self.navigationController?.pushViewController(groupWebViewController, animated: true)
    }
 
    func showDetailGroupPage(groupId: Int) {
        if let groupWebViewController = self.navigationController?.viewControllers[0] as? GroupWebViewController {
            groupWebViewController.groupId = groupId
            groupWebViewController.webViewUrlType = .base
        }
    }
}

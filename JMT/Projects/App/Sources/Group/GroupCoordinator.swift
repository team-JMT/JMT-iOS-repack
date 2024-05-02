//
//  GroupCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol GroupCoordinator: Coordinator {
    func showDetailGroupPage(groupId: Int)
    func showCreateGroupPage()
    func setSearchRestaurantCoordinator()
    func showSearchRestaurantViewController()
    func goToHomeViewController()
    
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
    
    func start() {
        let groupWebViewController = GroupWebViewController.instantiateFromStoryboard(storyboardName: "Group") as GroupWebViewController
        groupWebViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(groupWebViewController, animated: false)
    }
 
    func showDetailGroupPage(groupId: Int) {
        if let tabVC = self.navigationController?.parent as? UITabBarController {
            tabVC.selectedIndex = 2
            
            if let groupWebViewController = self.navigationController?.viewControllers[0] as? GroupWebViewController {
                groupWebViewController.groupId = groupId
                groupWebViewController.webViewUrlType = .detailGroup(id: groupId)
                groupWebViewController.loadWebPage()
            }
        }
    }
    
    func showCreateGroupPage() {
        if let tabVC = self.navigationController?.parent as? UITabBarController {
            tabVC.selectedIndex = 2
            
            if let groupWebViewController = self.navigationController?.viewControllers[0] as? GroupWebViewController {
                groupWebViewController.groupId = nil
                groupWebViewController.webViewUrlType = .createGroup
                groupWebViewController.loadWebPage()
            }
        }
    }
    
    func setSearchRestaurantCoordinator() {
        let coordinator = DefaultSearchRestaurantCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showSearchRestaurantViewController() {
        if getChildCoordinator(.searchRestaurant) == nil {
            setSearchRestaurantCoordinator()
        }
        
        let coordinator = getChildCoordinator(.searchRestaurant) as! SearchRestaurantCoordinator
        coordinator.start()
    }
    
    func goToHomeViewController() {
        if let homeViewController = parentCoordinator?.childCoordinators[0].navigationController?.viewControllers[0] as? HomeViewController {
            self.navigationController?.tabBarController?.selectedIndex = 0
            homeViewController.updateViewBasedOnGroupStatus()
        }
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .searchRestaurant:
            childCoordinator = childCoordinators.first(where: { $0 is SearchRestaurantCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
}

extension DefaultGroupCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

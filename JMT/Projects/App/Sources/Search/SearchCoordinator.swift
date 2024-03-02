//
//  SearchCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    func setRestaurantDetailCoordinator()
    func showRestaurantDetailViewController()
}

class DefaultSearchCoordinator: SearchCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .search
    
    
    init(navigationController: UINavigationController?, parentCoordinator: Coordinator) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let searchViewController = SearchViewController.instantiateFromStoryboard(storyboardName: "Search") as SearchViewController
        searchViewController.viewModel?.coordinator = self

        guard let pageViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchPageViewController") as? SearchPageViewController else { return }
        
        let totalResultViewController = TotalResultViewController.instantiateFromStoryboard(storyboardName: "Search") as TotalResultViewController
        let restaurantResultViewController = RestaurantResultViewController.instantiateFromStoryboard(storyboardName: "Search") as RestaurantResultViewController
        let groupResultViewController = GroupResultViewController.instantiateFromStoryboard(storyboardName: "Search") as GroupResultViewController
        
        totalResultViewController.viewModel?.coordinator = self
        restaurantResultViewController.viewModel?.coordinator = self
        groupResultViewController.viewModel?.coordinator = self
    
        pageViewController.vcArray = [totalResultViewController, restaurantResultViewController, groupResultViewController]
        
        searchViewController.pageViewController = pageViewController
        
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    func setRestaurantDetailCoordinator() {
        let coordinator = DefaultRestaurantDetailCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showRestaurantDetailViewController() {
        if getChildCoordinator(.restaurantDetail) == nil {
            setRestaurantDetailCoordinator()
        }
        
        let coordinator = getChildCoordinator(.restaurantDetail) as! RestaurantDetailCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .restaurantDetail:
            childCoordinator = childCoordinators.first(where: { $0 is RestaurantDetailCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
}

extension DefaultSearchCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

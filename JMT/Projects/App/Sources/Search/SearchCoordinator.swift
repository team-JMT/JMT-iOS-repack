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
    
    func setButtonPopupCoordinator()
    func showButtonPopupViewController()
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

        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let pageViewController = storyboard.instantiateViewController(withIdentifier: "SearchPageViewController") as? SearchPageViewController else { return }
        
        guard let totalResultViewController = storyboard.instantiateViewController(withIdentifier: "TotalResultViewController") as? TotalResultViewController else { return }
        guard let restaurantResultViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantResultViewController") as? RestaurantResultViewController else { return }
        guard let groupResultViewController = storyboard.instantiateViewController(withIdentifier: "GroupResultViewController") as? GroupResultViewController else { return }
        
        totalResultViewController.viewModel = searchViewController.viewModel
        restaurantResultViewController.viewModel = searchViewController.viewModel
        groupResultViewController.viewModel = searchViewController.viewModel
        
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
    
    func setButtonPopupCoordinator() {
        let coordinator = DefaultButtonPopupCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showButtonPopupViewController() {
        if getChildCoordinator(.buttonPopup) == nil {
            setButtonPopupCoordinator()
        }
        
        let coordinator = getChildCoordinator(.buttonPopup) as! ButtonPopupCoordinator
        coordinator.start()
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .buttonPopup:
            childCoordinator = childCoordinators.first(where: { $0 is ButtonPopupCoordinator })
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

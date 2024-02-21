//
//  SearchCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    func testCoordinator()
}

class DefaultSearchCoordinator: SearchCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .search
    
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
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
    
    func testCoordinator() {
        print("123123123123123")
    }
}

//
//  HomeCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import FloatingPanel

protocol HomeCoordinator: Coordinator {
    func setUserLocationCoordinator()
    func showUserLocationViewController(endPoint: Int)
    
    func setFilterBottomSheetCoordinator()
    func showFilterBottomSheetViewController()
    
    func setSearchRestaurantCoordinator()
    func showSearchRestaurantViewController()
}

class DefaultHomeCoordinator: HomeCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController.instantiateFromStoryboard(storyboardName: "Home") as HomeViewController
        homeViewController.viewModel?.coordinator = self
    
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func setUserLocationCoordinator() {
        let coordinator = DefaultUserLocationCoordinator(navigationController: navigationController,
                                                         parentCoordinator: self,
                                                         finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showUserLocationViewController(endPoint: Int) {
        if getChildCoordinator(.userLocation) == nil {
            setUserLocationCoordinator()
        }
        
        let coordinator = getChildCoordinator(.userLocation) as! UserLocationCoordinator
        coordinator.enterPoint = endPoint
        coordinator.start()
    }
    
    func setFilterBottomSheetCoordinator() {
        let coordinator = DefaultFilterBottomSheetCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showFilterBottomSheetViewController() {
        if getChildCoordinator(.filterBS) == nil {
            setFilterBottomSheetCoordinator()
        }
        
        let coordinator = getChildCoordinator(.filterBS) as! FilterBottomSheetCoordinator
        coordinator.start()
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
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .userLocation:
            childCoordinator = childCoordinators.first(where: { $0 is UserLocationCoordinator })
        case .filterBS:
            childCoordinator = childCoordinators.first(where: { $0 is FilterBottomSheetCoordinator })
        case .searchRestaurant:
            childCoordinator = childCoordinators.first(where: { $0 is SearchRestaurantCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
}


extension DefaultHomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

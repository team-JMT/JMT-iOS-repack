//
//  Coordinator.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit

enum CoordinatorType {
    case app, tabBar
    case socialLogin, nickname
    case profileImage, album, cropPhoto, profile
    case home, userLocation, convertUserLocation, homeBS, filterBS
    case search, restaurantDetail, searchRestaurant, searchRestaurantMap, registrationRestaurantInfo, searchRestaurantMenuBS
    case group
    case mypage
    case buttonPopup
}

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get set }
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get set }
    
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func getTopCoordinator() -> AppCoordinator {
        var coordinator: Coordinator = self
        while let parent = coordinator.parentCoordinator {
            coordinator = parent
        }
        return coordinator as! AppCoordinator
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

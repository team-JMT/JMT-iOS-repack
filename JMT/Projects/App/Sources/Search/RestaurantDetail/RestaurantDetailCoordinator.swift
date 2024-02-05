//
//  RestaurantDetailCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/01.
//

import Foundation
import UIKit

protocol RestaurantDetailCoordinator: Coordinator {
    
}


class DefaultRestaurantDetailCoordinator: RestaurantDetailCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .restaurantDetail
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator, finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let restaurantDetailViewController = RestaurantDetailViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailViewController
        restaurantDetailViewController.viewModel?.coordinator = self
        
        guard let pageViewController = UIStoryboard(name: "RestaurantDetail", bundle: nil).instantiateViewController(withIdentifier: "RestaurantDetailPageViewController") as? RestaurantDetailPageViewController else { return }
        
        let infoViewController = RestaurantDetailInfoViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailInfoViewController
        let photoViewController = RestaurantDetailPhotoViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailPhotoViewController
        let reviewViewController = RestaurantDetailReviewViewController.instantiateFromStoryboard(storyboardName: "RestaurantDetail") as RestaurantDetailReviewViewController
        
        infoViewController.viewModel?.coordinator = self
        photoViewController.viewModel?.coordinator = self
        reviewViewController.viewModel?.coordinator = self
        
        pageViewController.vcArray = [infoViewController, photoViewController, reviewViewController]
        
        restaurantDetailViewController.pageViewController = pageViewController
                
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }
}

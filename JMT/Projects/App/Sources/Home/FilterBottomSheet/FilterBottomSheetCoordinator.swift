//
//  FilterBottomSheetCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/01/26.
//

import Foundation
import UIKit

protocol FilterBottomSheetCoordinator: Coordinator {
    
}

class DefaultFilterBottomSheetCoordinator: FilterBottomSheetCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .homeBS
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator?,
         finishDelegate: CoordinatorFinishDelegate) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "HomeBottomSheet", bundle: nil)
        guard let vc =  storyboard.instantiateViewController(withIdentifier: "HomeBottomSheetViewController") as? HomeBottomSheetViewController else { return }
        
        
        
    }
}

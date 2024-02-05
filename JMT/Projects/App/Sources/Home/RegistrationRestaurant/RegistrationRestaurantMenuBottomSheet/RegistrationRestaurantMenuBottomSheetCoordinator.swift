//
//  RegistrationRestaurantMenuBottomSheetCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import Foundation
import UIKit
import FloatingPanel

protocol RegistrationRestaurantMenuBottomSheetCoordinator: Coordinator {
    
}

class DefaultRegistrationRestaurantMenuBottomSheetCoordinator: RegistrationRestaurantMenuBottomSheetCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .searchRestaurantMenuBS
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator?,
         finishDelegate: CoordinatorFinishDelegate?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "RegistrationRestaurantMenuBottomSheet", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "RegistrationRestaurantMenuBottomSheetViewController") as? RegistrationRestaurantMenuBottomSheetViewController else { return }
        
        let fpc = FloatingPanelController()
        vc.fpc = fpc
        fpc.set(contentViewController: vc)

        if let tvc = self.navigationController?.topViewController as? RegistrationRestaurantInfoViewController {
            vc.viewModel = tvc.viewModel
        }

        self.navigationController?.present(fpc, animated: true)
    }
    
//    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
//        var childCoordinator: Coordinator? = nil
//
//        switch type {
//        case .searchRestaurantMenuBS:
//            childCoordinator = childCoordinators.first(where: { $0 is RegistrationRestaurantMenuBottomSheetCoordinator })
//        default:
//            break
//        }
//        return childCoordinator
//    }
}

extension DefaultRegistrationRestaurantMenuBottomSheetCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}



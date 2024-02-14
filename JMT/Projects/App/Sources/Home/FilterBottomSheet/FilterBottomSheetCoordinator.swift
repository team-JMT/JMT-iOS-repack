//
//  FilterBottomSheetCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/01/26.
//

import Foundation
import UIKit
import FloatingPanel

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
        let storyboard = UIStoryboard(name: "FilterBottomSheet", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FilterBottomSheetViewController") as? FilterBottomSheetViewController else { return }
        
        if let tvc = self.navigationController?.topViewController as? HomeViewController {
            vc.viewModel = tvc.viewModel
        }
    
        let fpc = FloatingPanelController()
        vc.fpc = fpc
        fpc.set(contentViewController: vc)
        
       
        self.navigationController?.present(fpc, animated: true)
    }
}

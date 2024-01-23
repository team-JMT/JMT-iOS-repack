//
//  ButtonPopupCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/01/23.
//

import Foundation
import UIKit

protocol ButtonPopupCoordinator: Coordinator {
    
}

class DefaultButtonPopupCoordinator: ButtonPopupCoordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .buttonPopup
    
    init(navigationController: UINavigationController?,
         parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "ButtonPopup", bundle: nil)
        guard let buttonPopupViewController = storyboard.instantiateViewController(withIdentifier: "ButtonPopupViewController") as? ButtonPopupViewController else { return }
        
        setupPopupType(vc: buttonPopupViewController)
        
        if let topViewController = self.navigationController?.topViewController as? ButtonPopupDelegate {
            buttonPopupViewController.popupDelegate = topViewController
        }
    
        buttonPopupViewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(buttonPopupViewController, animated: false)
    }
    
    func setupPopupType(vc: ButtonPopupViewController) {
        guard let topViewController = self.navigationController?.topViewController else { return }
        
        // 뷰 컨트롤러 분기처리
        switch topViewController {
        case is UserLocationViewController:
            vc.popupType = .location
        default:
            return
        }
    }
}

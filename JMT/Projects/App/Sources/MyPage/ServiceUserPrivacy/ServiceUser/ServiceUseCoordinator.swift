//
//  ㄹㄷㅈㄹㅂㄹㄷㄷㅈㅂ.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

protocol ServiceUseCoordinator: Coordinator {

    
}

class DefaultServiceUseCoordinator: ServiceUseCoordinator {
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        
        let mypageViewController = ServiceUseVC.instantiateFromStoryboard(storyboardName: "ServiceUser") as ServiceUseVC
        
        mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    
    
    
}

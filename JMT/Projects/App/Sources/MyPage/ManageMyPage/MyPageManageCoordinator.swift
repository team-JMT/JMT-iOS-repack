//
//  1111.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

protocol MyPageManageCoordinator: Coordinator {

    
}

class DefaultMyPageManageCoordinator: MyPageManageCoordinator {
    
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .myPageManage
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = MyPageManageVC.instantiateFromStoryboard(storyboardName: "MyPageManage") as MyPageManageVC
        mypageViewController.viewModel?.coordinator = self
        
       
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    
}

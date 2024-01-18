//
//  MyPageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
    func goToTestt()
    
}

class DefaultMyPageCoordinator: MyPageCoordinator {
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .home
    
    init(navigationController: UINavigationController?) {
    
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = MyPageViewController.instantiateFromStoryboard(storyboardName: "MyPage") as MyPageViewController
        
         mypageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
        
        
    }
    
    func goToTestt() {
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)

             guard let mypageTestVC = storyboard.instantiateViewController(withIdentifier: "MyPageTestViewController") as? MyPageTestViewController else {
             
             print("MyPageTestViewController를 찾을 수 없습니다.")
             
             return
             
             }
             self.navigationController?.pushViewController(mypageTestVC, animated: true)
             print(1)
    }
    
    
}

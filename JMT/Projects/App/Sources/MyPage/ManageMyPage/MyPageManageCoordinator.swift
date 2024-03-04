//
//  1111.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

protocol MyPageManageCoordinator: Coordinator {
    
    func setlogOutAlertViewController()
    func showlogOutAlertViewController()
    
    func showLogoutViewController()
    
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
    
    // 스토리보드 인스턴스를 초기화
    let storyboard = UIStoryboard(name: "MyPageManage", bundle: nil)
    
    
    func start() {
        let mypageViewController = MyPageManageVC.instantiateFromStoryboard(storyboardName: "MyPageManage") as MyPageManageVC
        mypageViewController.viewModel?.coordinator = self
        
        
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    
    
    func setlogOutAlertViewController() {
        let coordinator = DefaultMyPageManageCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
    }
    
    func showlogOutAlertViewController() {
        if getChildCoordinator(.myPageManage) == nil {
            setlogOutAlertViewController()
        }
        
        let coordinator = getChildCoordinator(.myPageManage) as! MyPageManageCoordinator
        coordinator.start()
    }
    
    
    func showLogoutViewController() {
        // 스토리보드 ID를 사용하여 뷰 컨트롤러를 인스턴스화합니다.
        if let aViewController = storyboard.instantiateViewController(withIdentifier: "logoutAlertViewController") as? logoutAlertViewController {
            aViewController.modalPresentationStyle = .overCurrentContext
            aViewController.modalTransitionStyle = .crossDissolve
            navigationController?.present(aViewController, animated: true, completion: nil)
        }
    }
    
    func showBViewController() {
        if let bViewController = storyboard.instantiateViewController(withIdentifier: "withdrawlAlertViewController") as? withdrawlAlertViewController {
            bViewController.modalPresentationStyle = .overCurrentContext
            bViewController.modalTransitionStyle = .crossDissolve
            navigationController?.present(bViewController, animated: true, completion: nil)
        }
    }
    
    
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .myPageManage:
            childCoordinator = childCoordinators.first(where:  { $0 is DetailMyPageCoordinator })
        default:
            break
        }
        
        return childCoordinator
    }
}

extension DefaultMyPageManageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

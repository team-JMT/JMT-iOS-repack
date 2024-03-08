//
//  MyPageCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

protocol MyPageCoordinator: Coordinator {
   
    func goToDetailView(for segmentIndex: Int)
    func goToDetailMyPageView()
    //func goToTestt()
    
    
    func setDetailMyPageCoordinator()
    func showDetailMyPageVieController()
    
}

class DefaultMyPageCoordinator: MyPageCoordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .mypage
    
    init(navigationController: UINavigationController?) {
        
        self.navigationController = navigationController
    }
    
    func start() {
        let mypageViewController = MyPageViewController.instantiateFromStoryboard(storyboardName: "MyPage") as MyPageViewController
        
        mypageViewController.viewModel.coordinator = self
        self.navigationController?.pushViewController(mypageViewController, animated: true)
    }
    
    
    func goToDetailView(for segmentIndex: Int) {
        //   goToSegmentViewController(for : segmentIndex)
    }
    
    
    func goToDetailMyPageView() {
        let storyboard = UIStoryboard(name: "DetailMyPage", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "DetailMyPageVC") as? DetailMyPageVC {
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("DetailMyPageVC could not be instantiated.")
        }
    }
    
    func showUserInfoViewController() {
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil) // 스토리보드 이름 확인
        if let userInfoVC = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController {
            //  userInfoVC.viewModel = MyPageViewModel()
            navigationController?.pushViewController(userInfoVC, animated: true)
        }
    }
    
    func setDetailMyPageCoordinator() {
        let coordinator = DefaultDetailMyPageCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
    }
    
    func showDetailMyPageVieController() {
        if getChildCoordinator(.detailMyPage) == nil {
            setDetailMyPageCoordinator()
        }
        
        let coordinator = getChildCoordinator(.detailMyPage) as! DetailMyPageCoordinator
        coordinator.start()
    }
    
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .detailMyPage:
            childCoordinator = childCoordinators.first(where:  { $0 is DetailMyPageCoordinator })
        default:
            break
        }
        
        return childCoordinator
    }
}

extension DefaultMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

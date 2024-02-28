//
//  MyPageTestVoordinator.swift
//  App
//
//  Created by 이지훈 on 1/19/24.
//

import Foundation
import UIKit

protocol DetailMyPageCoordinator: Coordinator {
    //
    //    func goToServiceTermsViewController()
    //    func goToServiceUseViewController()
    //
    
    func setMyPageManageCoordinator()
    func showMyPageManageViewController()
    
    func setMyPageServiceTermsCoordinator()
    func showMyPageServiceTermsViewController()
    
    func setMyPageServiceUseCoordinator()
    func showMyPageServiceUseVC()
    
    func setProfileImagePopupCoordinator()
    func showProfileImagePopupViewController()
    
    func showImagePicker()
}

class DefaultDetailMyPageCoordinator: DetailMyPageCoordinator {
    
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .detailMyPage
    
    init(navigationController: UINavigationController?) {
        
        self.navigationController = navigationController
    }
    
    
    
    func start() {
        let detailMyPageViewController = DetailMyPageVC.instantiateFromStoryboard(storyboardName: "DetailMyPage") as DetailMyPageVC
        detailMyPageViewController.viewModel?.coordinator = self
        self.navigationController?.pushViewController(detailMyPageViewController, animated: true)
        
    }
    
    
    //계정관리
    func setMyPageManageCoordinator() {
        let coordinator = DefaultMyPageManageCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
    }
    
    
    func showMyPageManageViewController() {
        //있는지 예외처리
        if getChildCoordinator(.myPageManage) == nil {
            setMyPageManageCoordinator()

        }
    
        let coordinator = getChildCoordinator(.myPageManage) as! MyPageManageCoordinator
        coordinator.start()
        }


    //서비스 이용동의
    func setMyPageServiceTermsCoordinator() {
        let coordinator = DefaultMyPageServiceTermsVC(navigationController: navigationController)
        childCoordinators.append(coordinator)
    }

    func showMyPageServiceTermsViewController() {
        //있는지 예외처리
        if getChildCoordinator(.serviceTerms) == nil {
            setMyPageServiceTermsCoordinator()

        }
        
        let coordinator = getChildCoordinator(.serviceTerms) as! MyPageServiceTermsCoordinator
        coordinator.start()
    }
    
    //개인정보 처리방침
    func setMyPageServiceUseCoordinator() {
        let coordinator = DefaultServiceUseCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
    }

    func showMyPageServiceUseVC() {
        //있는지 예외처리
        if getChildCoordinator(.serviceUse) == nil {
            setMyPageServiceUseCoordinator()

        }
        
        let coordinator = getChildCoordinator(.serviceUse) as! ServiceUseCoordinator
        coordinator.start()
    }
    
    func setProfileImagePopupCoordinator() {
        let coordinator = DefaultProfileImagePopupCoordinator(navigationController: navigationController, parentCoordinator: self, finishDelegate: self)
        childCoordinators.append(coordinator)
    }
    
    func showProfileImagePopupViewController() {
        if getChildCoordinator(.profilePopup) == nil {
            setProfileImagePopupCoordinator()
        }
        
        let coordinator = getChildCoordinator(.profilePopup) as! ProfileImagePopupCoordinator
        coordinator.start()
    }
    
    func showImagePicker() {
        
        var config = PhotoKitConfiguration()
        config.library.defaultMultipleSelection = false
        
        let picker = PhotoKitNavigationController(configuration: config)
        
        picker.didFinishCompletion = { photo in
        
            self.handleImagePickerResult(photo.first, isDefault: false)
            picker.dismiss(animated: true)
        }

        self.navigationController?.present(picker, animated: true)
    }
    
    func handleImagePickerResult(_ image: UIImage?, isDefault: Bool) {
        if let detailMyPageViewController = self.navigationController?.topViewController as? DetailMyPageVC {
            detailMyPageViewController.profileImage.image = image
            detailMyPageViewController.viewModel?.isDefaultProfileImage = isDefault
        }
    }
    

//배열내에 있는 코디네이터에 enum으로 선언한 애가 있는지
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .serviceTerms:
            childCoordinator = childCoordinators.first(where: { $0 is MyPageServiceTermsCoordinator })
        case .myPageManage:
            childCoordinator = childCoordinators.first(where: { $0 is MyPageManageCoordinator })
        case .serviceUse:
            childCoordinator = childCoordinators.first(where: { $0 is ServiceUseCoordinator})
        case .profilePopup:
            childCoordinator = childCoordinators.first(where: { $0 is ProfileImagePopupCoordinator})
        default:
            break
        }
        
        return childCoordinator
    }



}

extension DefaultDetailMyPageCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

//
//  AppCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/20.
//

import UIKit

protocol AppCoordinator: Coordinator {
    func setSocialLoginCoordinator()
    func showSocialLoginViewController()
    
    // 탭바 컨트롤러에 사용할 메소드 정의
    func setTabBarCoordinator()
    func showTabBarViewController()

    func logout()
    func updateAllRestaurantsData()
    
}

protocol RestaurantsDataUpdatable {
    func updateRestaurantsData()
}

class DefaultAppCoordinator: AppCoordinator {
   
    var parentCoordinator: Coordinator? = nil
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        if DefaultKeychainService.shared.accessToken == nil {
            showSocialLoginViewController()
        } else {
            showTabBarViewController()
        }
    }
    
    func logout() {
        if getChildCoordinator(.socialLogin) == nil {
            setSocialLoginCoordinator()
        }
        
        let socialLocinCoordinator = getChildCoordinator(.socialLogin) as! SocialLoginCoordinator
        socialLocinCoordinator.logout()

    }
    
    func setSocialLoginCoordinator() {
        let socialLoginCoordinator = DefaultSocialLoginCoordinator(navigationController: navigationController,
                                                        parentCoordinator: self,
                                                        finishDelegate: self)
        
        childCoordinators.append(socialLoginCoordinator)
    }
    
    func showSocialLoginViewController() {
        if getChildCoordinator(.socialLogin) == nil {
            setSocialLoginCoordinator()
        }
        
        let socialLocinCoordinator = getChildCoordinator(.socialLogin) as! SocialLoginCoordinator
        socialLocinCoordinator.start()
    }
    
    func setTabBarCoordinator() {
        let coordinator = DefaultTabBarCoordinator(parentCoordinator: self,
                                                   finishDelegate: self)
        
        childCoordinators.append(coordinator)
    }
    
    func showTabBarViewController() {
        if getChildCoordinator(.tabBar) == nil {
            setTabBarCoordinator()
        }
        
        let coordinator = getChildCoordinator(.tabBar) as! TabBarCoordinator
        coordinator.start()
    }
    
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .socialLogin:
            childCoordinator = childCoordinators.first(where: { $0 is SocialLoginCoordinator })
        case .tabBar:
            childCoordinator = childCoordinators.first(where: { $0 is TabBarCoordinator})
        default:
            break
        }
    
        return childCoordinator
    }
    
    
    func updateAllRestaurantsData() {
        if let tab = childCoordinators.first {
            if let home = tab.childCoordinators[0] as? DefaultHomeCoordinator,
                let myPage = tab.childCoordinators[3] as? DefaultMyPageCoordinator {
        
                     home.updateRestaurantsData()
                     myPage.updateRestaurantsData()
                
            }
        }
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}

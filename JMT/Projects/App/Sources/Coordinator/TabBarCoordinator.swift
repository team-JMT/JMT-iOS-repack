//
//  TabBarCoordinator.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit


protocol TabBarCoordinator: Coordinator {
    var tabBarController: DefaultTabBarController { get }
}

class DefaultTabBarCoordinator: TabBarCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var tabBarController = DefaultTabBarController()
     
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .tabBar
    
    init(navigationController: UINavigationController? = nil,
         parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        
        let controllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(of: $0)
        }
        
        self.configureTabBarController(with: controllers)
    }
    
    // 각각의 탭에서 사용할 네비게이션 컨트롤러를 생성
    private func createTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(true, animated: false)
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-Medium", size: 16)!]
        tabNavigationController.navigationBar.titleTextAttributes = attributes
        tabNavigationController.tabBarItem = configureTabBarItem(of: page)
        
        self.setTabBarCoordinator(of: page, to: tabNavigationController)
        
        return tabNavigationController
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: false)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.view.backgroundColor = .white
        self.tabBarController.tabBar.backgroundColor = .white
        self.tabBarController.tabBar.tintColor = JMTengAsset.gray800.color
        self.tabBarController.tabBar.unselectedItemTintColor = JMTengAsset.gray200.color
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width:  self.tabBarController.tabBar.frame.width, height: 1))
        lineView.backgroundColor = JMTengAsset.gray100.color // 선의 색상 설정
        lineView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.tabBarController.tabBar.addSubview(lineView)
        
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            
            window.rootViewController = self.tabBarController
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                
            }) { completed in
                // 루트뷰 교체 후 작업 할 것
            }
        }
        
    }
    
    private func configureTabBarItem(of page: TabBarPage) -> UITabBarItem {
        switch page {
        case .home:
            return UITabBarItem(title: "둘러보기", image: UIImage(named: "HomeTab"), tag: page.pageOrderNumber())
        case .search:
            return UITabBarItem(title: "검색", image: UIImage(named: "SearchTab"), tag: page.pageOrderNumber())
        case .group:
            return UITabBarItem(title: "그룹", image: UIImage(named: "GroupTab"), tag: page.pageOrderNumber())
        case .mypage:
            return UITabBarItem(title: "마이페이지", image: UIImage(named: "MyPageTab"), tag: page.pageOrderNumber())
        }
    }
    
    private func setTabBarCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let coordinator = DefaultHomeCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            coordinator.start()
            childCoordinators.append(coordinator)
        case .search:
            let coordinator = DefaultSearchCoordinator(navigationController: tabNavigationController, parentCoordinator: self)
            coordinator.start()
            childCoordinators.append(coordinator)
        case .group:
            let coordinator = DefaultGroupCoordinator(navigationController: tabNavigationController)
            coordinator.start()
            childCoordinators.append(coordinator)
        case .mypage:
            let coordinator = DefaultMyPageCoordinator(navigationController: tabNavigationController)
            coordinator.start()
            childCoordinators.append(coordinator)
        }
    }
}

enum TabBarPage: String, CaseIterable {
    case home, search, group, mypage
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .search
        case 2:
            self = .group
        case 3:
            self = .mypage
        default:
            return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .group:
            return 2
        case .mypage:
            return 3
        }
    }
    
    func tabIconName() -> String {
        return self.rawValue
    }
}


extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}



//
//  SceneDelegate.swift
//  av
//
//  Created by cheonsong on 2022/09/05.
//

import UIKit
import Swinject
import NMapsMap
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let injector = DependencyInjector.shared
    var appCoordinator: AppCoordinator?
    var locationManager = LocationManager.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        if !UserDefaultManager.hasBeenLaunchedBeforeFlag {
            KeychainWrapper.standard.removeAllKeys()
            UserDefaultManager.hasBeenLaunchedBeforeFlag = true
            UserDefaultManager.defaults.synchronize()
        }
    
        // 포그라운드로 돌아올때 위치 권한 확인
        NotificationCenter.default.addObserver(self, selector: #selector(self.appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
      
        let navigationController = UINavigationController()
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        configNavigationBar()
        
        appCoordinator = DefaultAppCoordinator(navigationController: navigationController)
        
        injector.assemble([SocialLoginDI(),
                           
                           NicknameDI(),
                           
                           ProfileImageDI(), ProfilePopupDI(),
                           
                           HomeDI(), UserLocationDI(), RegistrationRestaurantDI(),
                           
                           SearchDI(), RestaurantDetailDI(),
                           
                           GroupDI(),
                           
                           MyPageDI(),
                           
                          ])
        
        self.appCoordinator?.start()
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) { 
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    @objc func appWillEnterForeground() {
         checkLocationAuthorization()
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            // 권한이 있는 경우
            break
        case .denied, .restricted:
            // 권한이 없는 경우 사용자에게 권한 요청
            self.window?.rootViewController?.showAccessDeniedAlert(type: .location)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unhandled authorization status")
        }
    }
    
    func configNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        appearance.backgroundImage = UIImage() // 배경 이미지 없음으로 설정
        appearance.shadowImage = UIImage() // 그림자 이미지 없음으로 설정
        appearance.shadowColor = nil
        
        // 모든 UINavigationBar 인스턴스에 대한 기본 속성으로 appearance 객체 설정
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance // 컴팩트 높이에 대한 설정 (예: 스크롤 시)
        UINavigationBar.appearance().scrollEdgeAppearance = appearance // 스크롤 가장자리에 대한 설정 (예: large title이 있는 경우)
        
        // iOS 15.0 이상에서 compactScrollEdgeAppearance 추가 설정
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }
}


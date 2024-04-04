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
        
        NMFAuthManager.shared().clientId = "4mc8nybxwl"
        
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
}


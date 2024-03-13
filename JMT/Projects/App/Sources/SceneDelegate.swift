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
            locationManager.requestWhenInUseAuthorization()
        }
    
    
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

        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        if !UserDefaultManager.hasBeenLaunchedBeforeFlag {
            UserDefaultManager.hasBeenLaunchedBeforeFlag = true
            UserDefaultManager.defaults.synchronize()
        } else {
            if locationManager.checkAuthorizationStatus() == false {
                self.window?.rootViewController?.showAccessDeniedAlert(type: .location)
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) { 
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
       
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

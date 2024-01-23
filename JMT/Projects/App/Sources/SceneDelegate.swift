//
//  SceneDelegate.swift
//  av
//
//  Created by cheonsong on 2022/09/05.
//

import UIKit
import Swinject
import NMapsMap

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let injector = DependencyInjector.shared
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
            
        let navigationController = UINavigationController()
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        NMFAuthManager.shared().clientId = "4mc8nybxwl"
        
        appCoordinator = DefaultAppCoordinator(navigationController: navigationController)
        
        injector.assemble([SocialLoginDI(),
                           NicknameDI(),
                           ProfileImageDI(),
                           ProfilePopupDI(),
                           HomeDI(), UserLocationDI(),
                           SearchDI(),
                           GroupDI(),
                           MyPageDI(),
                          ])
        
        appCoordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


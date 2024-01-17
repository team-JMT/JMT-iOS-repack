//
//  SceneDelegate.swift
//  av
//
//  Created by cheonsong on 2022/09/05.
//

import UIKit
import Swinject

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
        
        appCoordinator = DefaultAppCoordinator(navigationController: navigationController)
        
        injector.assemble([SocialLoginDI(),
                           NicknameDI(),
                           ProfileImageDI(),
                           ProfilePopupDI()
                          ])
        
        appCoordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


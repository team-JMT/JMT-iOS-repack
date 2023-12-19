//
//  SceneDelegate.swift
//  av
//
//  Created by cheonsong on 2022/09/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "SocialLogin", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SocialLocinViewController") as? SocialLocinViewController else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


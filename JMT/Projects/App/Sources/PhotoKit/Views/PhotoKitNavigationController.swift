//
//  PhotoKitNavigationController.swift
//  App
//
//  Created by PKW on 2024/01/11.
//

import UIKit

class PhotoKitNavigationController: UINavigationController {
    
    var didFinishCompletion: ((UIImage?) -> ())?
    
    var albumViewController: PhotoKitViewController!

    convenience init() {
        self.init(configuration: PhotoKitConfiguration.shared)
    }
    
    required init(configuration: PhotoKitConfiguration) {
        super.init(nibName: nil, bundle: nil)
        
        PhotoKitConfiguration.shared = configuration
        let storyboard = UIStoryboard(name: "PhotoKit", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "PhotoKitViewController") as? PhotoKitViewController else { return }
        albumViewController = vc
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [albumViewController]
        
        albumViewController.didSelectItems = { image in
            self.didFinishCompletion?(image)
        }
    }
}

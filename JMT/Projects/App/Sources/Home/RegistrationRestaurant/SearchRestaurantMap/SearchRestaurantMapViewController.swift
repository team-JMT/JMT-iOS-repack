//
//  SearchRestaurantMapViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import NMapsMap

class SearchRestaurantMapViewController: UIViewController {

    var viewModel: SearchRestaurantMapViewModel?
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCustomNavigationBarBackButton(isSearchVC: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func didTabSelectedButton(_ sender: Any) {
        viewModel?.coordinator?.showRegistrationRestaurantInfoViewController()
    }
}

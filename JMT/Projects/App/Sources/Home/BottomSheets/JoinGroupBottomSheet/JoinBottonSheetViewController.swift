//
//  JoinBottonSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/03/01.
//

import UIKit

class JoinBottonSheetViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var createGorupButton: UIButton!
    @IBOutlet weak var searchGroupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func didTabCreateGroupButton(_ sender: Any) {
        self.dismiss(animated: false)
        viewModel?.coordinator?.showGroupTab()
    }
    
    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        self.dismiss(animated: false)
        viewModel?.coordinator?.showSearchTabWithButton()
    }
}


extension JoinBottonSheetViewController {
    func setupUI() {
        createGorupButton.layer.cornerRadius = 8
        createGorupButton.layer.borderColor = JMTengAsset.main500.color.cgColor
        createGorupButton.layer.borderWidth = 1
        
        searchGroupButton.layer.cornerRadius = 8
    }
}

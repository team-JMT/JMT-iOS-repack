//
//  222.swift
//  JMTeng
//
//  Created by 이지훈 on 2/22/24.
//

import Foundation

import UIKit

class MyPageManageVC: UIViewController {
    
    var viewModel: MyPageManageViewModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setCustomNavigationBarBackButton(isSearchVC: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

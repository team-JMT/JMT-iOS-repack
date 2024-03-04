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
   // var coordinator : MyPageManageCoordinator
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //네비게이션 바 보이기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setCustomNavigationBarBackButton(isSearchVC: false)
    }
    
    //네비게이션 스택 사라지기
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func didTapLogOut(_ sender: Any) {
        viewModel?.coordinator?.showLogoutViewController()
    }
    
    @IBAction func didTabWithdrawl(_ sender: Any) {
        
    }
    
    
}

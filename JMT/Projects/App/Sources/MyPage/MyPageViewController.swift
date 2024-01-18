//
//  MyPageViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit

class MyPageViewController: UIViewController {
    
    var viewModel: MyPageViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

    }
    
    
    
    @IBAction func gotoNext(_ sender: Any) {
        print(0)
        viewModel?.gotoNext()
        print(10)
    }
    
    
}

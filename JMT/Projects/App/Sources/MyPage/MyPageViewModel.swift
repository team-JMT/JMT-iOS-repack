//
//  MyPageViewModel.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import Foundation

class MyPageViewModel {
    weak var coordinator: MyPageCoordinator?
    
    func gotoNext() {
        coordinator?.goToTestt()
        print(100)
    }
    
    
    let test = "홈"
}

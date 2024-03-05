//
//  RegistrationRestaurantMenuBottomSheetViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import FloatingPanel

class RegistrationRestaurantMenuBottomSheetViewController: UIViewController {

    var viewModel: RegistrationRestaurantInfoViewModel?
    var fpc: FloatingPanelController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fpc?.delegate = self
    }
}

extension RegistrationRestaurantMenuBottomSheetViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            print("1")
        case .half:
            print("2")
        case .tip:
            print("#")
        default:
            print("default")
        }
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
//        if fpc.isAttracting == false || fpc.isAttracting == true {
//            if fpc.surfaceLocation.y < 65 + self.view.safeAreaInsets.top {
//                fpc.surfaceLocation.y = 65 + self.view.safeAreaInsets.top
//            }
//        }
    }
}

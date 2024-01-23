//
//  HomeViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import MapKit
import NMapsMap

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?

    var isFolded: Bool = true

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var topContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var groupNameButton: UIButton!
    @IBOutlet weak var groupButtonTop: NSLayoutConstraint!
    @IBOutlet weak var groupButtonBottom: NSLayoutConstraint!
    
    @IBOutlet weak var underLineView: UIView!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var addressButton: UIButton!

    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        naverMapView.showZoomControls = false

//        NicknameAPI.saveNickname(request: NicknameRequest(nickname: "3333")) { response in
//            switch response {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error)
//            }
//        }

//        DefaultKeychainService.shared.accessToken = nil
    }
    
    @IBAction func didTabGroupTitleButton(_ sender: Any) {
        isFolded.toggle()
        updateTopContainerView()
    }
    
    
    @IBAction func didTabAddressButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(tag: 0)
    }
    
    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(tag: 1)
    }
    
    
    func updateTopContainerView() {
        
        let font: UIFont = isFolded ? UIFont(name: "Pretendard-Bold", size: 14)! : UIFont(name: "Pretendard-Bold", size: 20)!
        let topContainerHeight: CGFloat = isFolded ? 32 : 99
        let groupButtonTop: CGFloat = isFolded ? 6 : 20
        let groupButtonBottom: CGFloat = isFolded ? 5 : 49
        let addressLabelTop: CGFloat = isFolded ? -5 : 16
        let alpha: CGFloat = isFolded ? 0 : 1
        
        self.groupNameButton.titleLabel?.font = font
        self.topContainerViewHeight.constant = topContainerHeight
        self.groupButtonTop.constant = groupButtonTop
        self.groupButtonBottom.constant = groupButtonBottom
        self.addressLabelTop.constant = addressLabelTop
        
        UIView.animate(withDuration: 0.5) {
            self.searchButton.alpha = alpha
            self.underLineView.alpha = alpha
            self.addressLabel.alpha = alpha
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.addressButton.isHidden = self.isFolded
        }
    }
    
}

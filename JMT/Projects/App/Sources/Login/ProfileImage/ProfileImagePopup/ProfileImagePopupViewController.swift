//
//  ProfileImagePopupViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/01/17.
//

import UIKit

class ProfileImagePopupViewController: UIViewController {
    
    var viewModel: ProfileImagePopupViewModel?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var defaultProfileImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    
    func setupUI() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        albumButton.layer.cornerRadius = 8
        albumButton.layer.borderColor = JMTengAsset.gray100.color.cgColor
        albumButton.layer.borderWidth = 2
        
        defaultProfileImageButton.layer.cornerRadius = 8
        defaultProfileImageButton.layer.borderColor = JMTengAsset.gray100.color.cgColor
        defaultProfileImageButton.layer.borderWidth = 2
    }
    
    @IBAction func didTabAlbumButton(_ sender: Any) {
        dismiss(animated: false) {
            self.viewModel?.coordinator?.showAlbum()
        }
        
    }
    
    @IBAction func didTabDefaultImageButton(_ sender: Any) {
        dismiss(animated: false) {
            self.viewModel?.coordinator?.setDefaultProfileImage()
        }
       
    }
}

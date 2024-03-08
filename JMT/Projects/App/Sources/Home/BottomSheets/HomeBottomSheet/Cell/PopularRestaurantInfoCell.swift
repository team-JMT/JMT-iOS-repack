//
//  PopularRestaurantInfoCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit
import SkeletonView
import Kingfisher

class PopularRestaurantInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var reviewContainerView: UIView!
    @IBOutlet weak var reviewUserProfileImageView: UIImageView!
    @IBOutlet weak var reviewNicknameLabel: UILabel!
    @IBOutlet weak var reviewCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        restaurantImageView.layer.cornerRadius = 16
        
        reviewUserProfileImageView.layer.cornerRadius = reviewUserProfileImageView.frame.height / 2
        
        reviewContainerView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stopSkeletonAnimation()
        hideSkeleton()
        setupData(model: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        self.layoutSkeletonIfNeeded()
    }
    
    func setupData(model: SearchMapRestaurantItems?) {
        
        if let model = model {
            userNicknameLabel.text = model.userNickName
            
            if let url = URL(string: model.userProfileImageUrl) {
                userProfileImageView.kf.setImage(with: url)
            } else {
                userProfileImageView.image = JMTengAsset.defaultProfileImage.image
            }
            
            if let url = URL(string: model.restaurantImageUrl ?? "") {
                restaurantImageView.kf.setImage(with: url)
            } else {
                restaurantImageView.image = JMTengAsset.emptyResult.image
            }
            
            restaurantNameLabel.text = model.name
            introduceLabel.text = model.introduce
        } else {
            userNicknameLabel.text = ""
            userProfileImageView.image = nil
            restaurantImageView.image = nil
            restaurantNameLabel.text = nil
            introduceLabel.text = nil
        }
    }
}

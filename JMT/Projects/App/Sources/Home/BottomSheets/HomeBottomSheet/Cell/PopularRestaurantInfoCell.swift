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
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var drinkLiquorView: UIView!
    @IBOutlet weak var drinkLiquorLabel: UILabel!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var reviewContainerView: UIView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var reviewUserProfileImageView: UIImageView!
    @IBOutlet weak var reviewNicknameLabel: UILabel!
    @IBOutlet weak var reviewCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        categoryView.isHidden = true
        drinkLiquorView.isHidden = true
        
        skeletonCornerRadius = 10
        
        categoryView.layer.cornerRadius = 4
        drinkLiquorView.layer.cornerRadius = 4
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        restaurantImageView.layer.cornerRadius = 16
        
        reviewUserProfileImageView.layer.cornerRadius = reviewUserProfileImageView.frame.height / 2
        
        reviewContainerView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryView.isHidden = true
        drinkLiquorView.isHidden = true
        
        userNicknameLabel.text = nil
        userProfileImageView.image = nil
        userProfileImageView.backgroundColor = .clear
        restaurantImageView.image = nil
        restaurantNameLabel.text = nil
        introduceLabel.text = nil
        reviewContainerView.isHidden = true
        reviewCountLabel.text = nil
        categoryLabel.text = nil
        drinkLiquorLabel.text = nil
    }
    
    func setupData(model: RestaurantListModel?) {
        
        guard let model = model 
        else { return }
        
        categoryLabel.text = model.category
        drinkLiquorLabel.text = model.canDrinkLiquor == true ? "주류 가능" : "주류 불가능"
        
        userNicknameLabel.text = model.userNickName ?? "이름 없음"
        userProfileImageView.loadImage(urlString: model.userProfileImageUrl ?? "defaultImg", defaultImage: JMTengAsset.defaultProfileImage.image)
        
        restaurantImageView.loadImage(urlString: model.restaurantImageUrl ?? "defaultImg", defaultImage: JMTengAsset.emptyResult.image)
        restaurantNameLabel.text = model.name
        introduceLabel.text = model.introduce

        reviewContainerView.isHidden = model.reviews.isEmpty
        
        if let review = model.reviews.first {
            reviewUserProfileImageView.loadImage(urlString: review.reviewerImageUrl ?? "defaultImg", defaultImage: JMTengAsset.defaultProfileImage.image)
            
            reviewNicknameLabel.text = review.userName
            reviewCommentLabel.text = review.reviewContent
            reviewCountLabel.text = "\(review.totalCount)"
        } else {
            reviewCountLabel.text = "0"
        }
        
        categoryView.isHidden = false
        drinkLiquorView.isHidden = false
    }
}

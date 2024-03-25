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
        
        self.isSkeletonable = true
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
        
        userNicknameLabel.text = ""
        userProfileImageView.image = nil
        restaurantImageView.image = nil
        restaurantNameLabel.text = nil
        introduceLabel.text = nil
        reviewContainerView.isHidden = true
        reviewCountLabel.text = nil
        categoryLabel.text = nil
        drinkLiquorLabel.text = nil
    }
    
    func setupData(model: SearchMapRestaurantModel?) {
        guard let model = model else {
            // 모델이 없는 경우의 처리
            return
        }
        
        categoryLabel.text = model.category
        drinkLiquorLabel.text = model.canDrinkLiquor == true ? "주류 가능" : "주류 불가능"
        
        userNicknameLabel.text = model.userNickName ?? "이름 없음"
        loadImage(urlString: model.userProfileImageUrl, defaultImage: JMTengAsset.defaultProfileImage.image, imageView: userProfileImageView)
        loadImage(urlString: model.restaurantImageUrl, defaultImage: JMTengAsset.emptyResult.image, imageView: restaurantImageView)

        restaurantNameLabel.text = model.name
        introduceLabel.text = model.introduce

        reviewContainerView.isHidden = model.reviews.isEmpty
        if let review = model.reviews.first {
            loadImage(urlString: review.reviewerImageUrl, defaultImage: JMTengAsset.defaultProfileImage.image, imageView: reviewUserProfileImageView)
            reviewNicknameLabel.text = review.userName
            reviewCommentLabel.text = review.reviewContent
            reviewCountLabel.text = "\(review.totalCount)"
        } else {
            reviewCountLabel.text = "0"
        }
    }

    // 이미지 로딩을 위한 공통 함수
    private func loadImage(urlString: String?, defaultImage: UIImage, imageView: UIImageView) {
        if let urlString = urlString, !urlString.isEmpty, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = defaultImage
        }
    }
}

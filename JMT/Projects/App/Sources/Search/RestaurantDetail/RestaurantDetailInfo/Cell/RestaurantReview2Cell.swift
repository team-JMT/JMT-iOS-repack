//
//  RestaurantReview2Cell.swift
//  JMTeng
//
//  Created by PKW on 3/12/24.
//

import UIKit

class RestaurantReview2Cell: UICollectionViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImageView.layer.cornerRadius = 10
        self.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userProfileImageView.image = nil
        userNameLabel.text = nil
    }
    
    func setupData(reviewData: RestaurantReviewModel?) {
        if let profileImageUrl = URL(string: reviewData?.reviewerImageUrl ?? "") {
            userProfileImageView.kf.setImage(with: profileImageUrl)
        } else {
            userProfileImageView.image = JMTengAsset.defaultProfileImage.image
        }
        
        userNameLabel.text = reviewData?.userName ?? ""
        reviewCommentLabel.text = reviewData?.reviewContent ?? ""
    }
}

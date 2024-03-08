//
//  PopularRestaurantInfoCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit
import SkeletonView

class PopularRestaurantInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    
    @IBOutlet weak var menuImageView: UIImageView!
    
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
        menuImageView.layer.cornerRadius = 16
        
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
    
    func setupData(model: GroupRestaurantsInfoModel?) {
        userNicknameLabel.text = model?.userNickName ?? ""
        restaurantNameLabel.text = model?.name ?? ""
        introduceLabel.text = model?.introduce ?? ""
        likeCountLabel.text = "\(model?.likeCount ?? 0)"
        
        if model?.comments.isEmpty == false {
            reviewContainerView.isHidden = false
            reviewNicknameLabel.text = model?.comments[0].userNickname
            reviewCommentLabel.text = model?.comments[0].comment
        }
    }
}

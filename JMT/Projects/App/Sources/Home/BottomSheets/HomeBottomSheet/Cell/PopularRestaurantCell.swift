//
//  PopularRestaurantCell.swift
//  JMTeng
//
//  Created by PKW on 2024/02/14.
//

import UIKit
import SkeletonView

class PopularRestaurantCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        restaurantImageView.layer.cornerRadius = 20
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        
        userInfoView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        userInfoView.layer.cornerRadius = 20
        
        self.layer.shadowColor = UIColor(red: 0.086, green: 0.102, blue: 0.114, alpha: 0.08).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 16
        self.layer.masksToBounds = false
        
        self.contentView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.stopSkeletonAnimation()
        self.hideSkeleton()
    }
    
    func setupData(model: GroupRestaurantsInfoModel?) {
        userNicknameLabel.text = model?.userNickName ?? ""
        restaurantNameLabel.text = model?.name ?? ""
    }
}




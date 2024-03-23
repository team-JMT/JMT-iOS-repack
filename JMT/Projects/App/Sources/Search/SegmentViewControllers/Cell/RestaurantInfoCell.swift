//
//  RestaurantInfoCell.swift
//  JMTeng
//
//  Created by PKW on 3/15/24.
//

import UIKit
import Kingfisher

class RestaurantInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var restaurantProfileImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantProfileImageView.layer.cornerRadius = 8
        userProfileImageView.layer.cornerRadius = 10

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        restaurantProfileImageView.image = nil
        groupNameLabel.text = nil
        restaurantNameLabel.text = nil
        userProfileImageView.image = nil
        userNameLabel.text = nil
    }
    
    func setupRestaurantData(restaurantData: SearchRestaurantsItems?) {
        if let data = restaurantData {
            
            if let restaurantImageUrl = URL(string: data.restaurantImageUrl ?? "") {
                restaurantProfileImageView.kf.setImage(with: restaurantImageUrl)
            } else {
                restaurantProfileImageView.image = JMTengAsset.defaultProfileImage.image
            }
            
            if let userProfileImageUrl = URL(string: data.userProfileImageUrl ?? "") {
                userProfileImageView.kf.setImage(with: userProfileImageUrl)
            } else {
                userProfileImageView.image = JMTengAsset.defaultProfileImage.image
            }
            
            groupNameLabel.text = data.groupName
            restaurantNameLabel.text = data.name
            userNameLabel.text = data.userNickName
        }
    }
    
    func setupOutBoundrestaurantData(outBoundrestaurantData: SearchRestaurantsOutBoundModel?) {
        if let data = outBoundrestaurantData {
            
            if let restaurantImageUrl = URL(string: data.restaurantImageUrl ?? "") {
                restaurantProfileImageView.kf.setImage(with: restaurantImageUrl)
            } else {
                restaurantProfileImageView.image = JMTengAsset.defaultProfileImage.image
            }
            
            if let userProfileImageUrl = URL(string: data.userProfileImageUrl ?? "") {
                userProfileImageView.kf.setImage(with: userProfileImageUrl)
            } else {
                userProfileImageView.image = JMTengAsset.defaultProfileImage.image
            }
            
            groupNameLabel.text = data.groupName
            restaurantNameLabel.text = data.name
            userNameLabel.text = data.userNickName

        }
    }
}
